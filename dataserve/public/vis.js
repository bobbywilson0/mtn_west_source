var commits;
$(function() {
  var url = "http://localhost:9292/rails-repo/commits.json";
  $.get(url, function(data) {
    commits = data;
  });
});
