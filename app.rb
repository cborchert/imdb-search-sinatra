#app.rb
require 'rubygems'
require 'sinatra'
require 'json'
#I had to manually install filmbuff v.1.0.0 from git. rubygems' most recent version is 0.1.6
require 'filmbuff'

get '/' do
    haml :search
end

get '/search' do
    haml :search
end

get '/search/' do
    haml :search
end

post '/search' do
    @search_query = params[:search_query]
    @num_results = 5
    @json_only = params[:json_only]
    if @json_only == "on"
        haml :JSON
    else
        haml :search
    end
end

get '/search/:query' do
    @search_query = params[:query]
    #num_results any string, or zero would return all the movies
    @num_results = "all"
    haml :search
end

get '/search/:query/' do
    @search_query = params[:query]
    #num_results any string, or zero would return all the movies
    @num_results = "all"
    haml :search
end

get '/search/:query/:num_results' do
    @search_query = params[:query]
    @num_results = params[:num_results]
    haml :search
end
