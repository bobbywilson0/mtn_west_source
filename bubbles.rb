require 'rubyvis'
require 'mongo'
include Mongo

db = Connection.new.db('repo')
ruby_repo = db.collection('ruby')

map = "function() { emit(this.author, this.total); }"
reduce = <<EOF 
  function(k,vals) { 
    var sum = 0; 
    for(var i in vals) sum += vals[i]; 
    return sum;
  }
EOF

data = ruby_repo.map_reduce(map, reduce).find().to_a
empty_array = data.map { |d| '' }

nodes = Rubyvis.nodes(empty_array)
nodes.each_with_index do |node, index|
  class << node
    attr_accessor :node_name, :node_value
  end
  break if index == 73
  node.node_name = data[index]['_id']
  node.node_value = data[index]['value']
end

format = Rubyvis.Format.number

vis = Rubyvis::Panel.new.width(600).height(600)
c20=Rubyvis::Colors.category19()
vis.add(pv.Layout.Pack)
    .top(-50)
    .bottom(-50)
    .nodes(nodes)
    .size(lambda {|d| d.node_value.to_f })
    .spacing(0)
    .order(nil)
  .node.add(Rubyvis::Dot)
    .fill_style(lambda {|d| c20.scale(d.node_name)})
    .stroke_style(lambda {|d| c20.scale(d.node_name).darker})
    .title(lambda {|d| d.node_name })
    .visible(lambda {|d| d.node_value.to_i > 0 || d.node_name == "svn" })
  .anchor("center").add(pv.Label)
  .text(lambda {|d| d.node_name })


vis.render()
File.open('ruby_bubbles.html', 'w+') do |f|
  f.puts '<html><head></head><body>'
  f.puts vis.to_svg
  f.puts '</body></html>'
end
