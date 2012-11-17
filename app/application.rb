require "rubygems"
require "httparty"
require "sinatra"
require "omniauth-singly"
require "rest-client"

SINGLY_API_BASE = "https://api.singly.com"
SINGLY_ID = "b6bec79037046c1acadbe7f3dc8077fb"
SINGLY_SECRET = "5eb4bba7309db6ba8ad7610e5fb02c9b"

enable :sessions

use OmniAuth::Builder do
  provider :singly, SINGLY_ID, SINGLY_SECRET
end

get "/" do
  if session[:access_token]
    @profiles = HTTParty.get(profiles_url, {
                  :query => {:access_token => session[:access_token]}
                }).parsed_response
  end
  erb :index
end

get "/auth/singly/callback" do
  auth = request.env["omniauth.auth"]
  session[:access_token] = auth.credentials.token
  redirect "/"
end

get "/logout" do
  session.clear
  redirect "/"
end

def profiles_url
  "#{SINGLY_API_BASE}/profiles"
end
