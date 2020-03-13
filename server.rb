require 'sinatra'
require 'git'
require 'logger'

get '/' do
  working_dir = Dir.pwd
  g = Git.open(working_dir, :log => Logger.new(STDOUT))
  logs = g.log
  list = []
  logs.each do |commit|
    line = commit.sha + " " + commit.author.name + " " +
     commit.date.strftime("%m-%d-%y") + " " + commit.message
    list.push line
  end
  list.join("<br>")
end

get "/status" do
  working_dir = Dir.pwd
  g = Git.open(working_dir, :log => Logger.new(STDOUT))
  g.config('user.name')
  changed_files = g.status.changed
  @status = changed_files.to_s
  @current_branch = g.branches.select(&:current).first
  @diff = g.diff

  erb :status
end
