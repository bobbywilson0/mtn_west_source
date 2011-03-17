require 'rubyvis'
require 'mongo'
include Mongo

db = Connection.new.db('repo')
ruby_repo = db.collection('ruby')

commit_width = 500;
commit_height = 200;
bar_width = 15;
gap = 1;

additions = ruby_repo.find().limit(20).map { |doc| doc['additions'] }
deletions = ruby_repo.find().limit(20).map { |doc| doc['deletions'] }

add_scale = Rubyvis::Scale.linear(additions).range(0, commit_height/2);
delete_scale = Rubyvis::Scale.linear(deletions).range(0, commit_height/2);

vis = Rubyvis::Panel.new do 
  width(commit_width)
  height(commit_height+5)

  bar do
    data(additions)
    bottom(commit_height/2)
    width(bar_width-gap)
    height(lambda { |d| add_scale[d] })
    left(lambda { |d| index * bar_width })
    fillStyle('green')
  end

  bar do
    data(deletions)
    top(commit_height/2 + 10)
    width(bar_width-gap)
    height(lambda{ |d| delete_scale[d] })
    left(lambda { |d| index * bar_width })
    fillStyle('red')
  end
end

vis.render()
File.open('additions_deletions.html', 'w+') do |f|
  f.puts '<html><head></head><body>'
  f.puts vis.to_svg
  f.puts '</body></html>'
end
