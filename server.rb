require 'sinatra'
require 'git'
require 'logger'

get '/' do
  working_dir = Dir.pwd
  g = Git.open(working_dir, :log => Logger.new(STDOUT))
  logs = g.log
  list = []
  logs.each do |commit|
    line = commit.sha + " " + commit.author.name + " " + commit.date.strftime("%m-%d-%y")
    # line += "\n"
    list.push line
  end
  list.join("<br>").html_safe
end

get "/status" do

end
