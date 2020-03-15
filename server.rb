require 'sinatra'
require 'git'
require 'logger'
require_relative 'diff'
require_relative 'string'

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
  untracked_files = g.status.untracked
  puts "\n" * 5
  puts g.status.pretty
  @status = `git status`
  @wild = g.status.pretty
  @current_branch = g.branches.select(&:current).first
  @diff = g.diff
  @diff = WebGit::Diff.diff_to_html(g.diff.to_s)

  erb :status
end

post "/commit" do
  title = params[:title]
  description = params[:description]
  p title
  puts "------"
  working_dir = Dir.pwd
  g = Git.open(working_dir, :log => Logger.new(STDOUT))
  g.add(:all=>true)  
  g.commit(title)
  redirect to("/status")
end
