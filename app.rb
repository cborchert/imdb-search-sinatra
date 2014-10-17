#app.rb
require 'rubygems'
require 'sinatra'
require 'filmbluff'

get '/' do
    haml :search
end

get '/search' do
    haml :search
end

post '/search' do
    @search_query = params[:search_query]
    @num_results = 5
    haml :search
end

get '/search/:query' do
    @search_query = params[:search_query]
    #num_results = -1 could be used for all results?
    @num_results = "all"
    haml :search
end

get '/search/:query/:num_results' do
    @search_query = params[:search_query]
    @num_results = params[:num_results]
    haml :search
end
