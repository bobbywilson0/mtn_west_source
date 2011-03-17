require 'grit'
require 'json/ext'

repo = ::Grit::Repo.new('~/projects/opensource/ruby')
commit_count = Grit::Commit.count(repo, 'trunk')
commits = []

(0..commit_count).each do |i|
  repo.commits('trunk', 1, i).each do |c|
    File.open(File.dirname(__FILE__) + '/ruby.json', 'w') do |f|
      commits << { :sha              => c.sha,
      						 :date             => c.date,
      						 :total            => c.stats.total,
      						 :additions        => c.stats.additions,
      						 :deletions        => c.stats.deletions,
       						 :committer_email  => c.committer.email,
      					   :committer        => c.committer.name.force_encoding('UTF-8'),
      					   :author_email     => c.author.email,
      						 :author           => c.author.name.force_encoding('UTF-8'),
                   :message          => c.message.force_encoding('UTF-8') }
      f.puts(commits.to_json)
    end
  end
end
