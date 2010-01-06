require 'rubygems'
require 'sinatra'
require 'config/environment'

# ===============
# = Basic Stuff =
# ===============
get '/' do
  'OMGHI2U =)'
end

get '/debug/env' do
  Sinatra.options.environment.to_s
end

get '/debug/root' do
  Sinatra.options.root.to_s
end

# ======================
# = Normal SQL Queries =
# ======================

get '/sample.xml' do
  content_type :xml
  output = { :sample => 'content' }.to_xml
  headers['Content-Length'] = output.length
  return output
end

get '/sample.html' do
  content_type :html
  output = "<pre>#{{ :sample => 'content' }.to_yaml}</pre>"
  return output
end

get '/sample.json' do
  content_type :json
  output = { :sample => 'content' }.to_json
  return output
end