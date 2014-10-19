require 'rubygems'
require 'sinatra'
require 'json'
require 'filmbuff'


get '/?' do
    haml :search
end

get '/search/?' do
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

get '/search/:query/?' do
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
