require 'sinatra'

get '/' do
  p `pwd`
  p `git status`
  'Hello world!'
end

get "/status" do

end
