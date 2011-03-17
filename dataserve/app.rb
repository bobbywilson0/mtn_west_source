class App < Sinatra::Base
  set :public,   File.expand_path(File.dirname(__FILE__) + '/public')
  include Mongo
  
  get '/:repo/commits.json' do
    db = Mongo::Connection.new.db('repo')
    content_type :json
    commits = db.collection(params[:repo]).find({'total' => {'$gt' => 300}}).sort('date', 'ascending').map do |c| 
      fields = { :additions => c['additions'], :deletions => c['deletions'], 
        :author => c['author'], :date => c['date'], :total => c['total'], :sha => c['sha'] }
    end
    commits.to_json
  end
end


