require 'rubygems'
require 'sinatra'
require 'json'
require 'filmbuff'

##########################METHODS####################################

#Takes a search string and modifies the variables accessed by search.haml
def getResults (search_query, num_results)
    @headerMessage = ""
    @headerClass =""
    @listing = ""
    @footerMessage = ""

    #Handle the error caused by an empty search string
    if search_query == ""
        getErrorMessage("You must enter a search term")

    #Create a list for the search, unless the search query is somehow nil
    elsif !search_query.nil?
        #convert recieved String for num_results to an integer. All non-numeric text == 0.
        num_results = num_results.to_i

        #Create a new imdb object so we can initiate the search
        imdb = FilmBuff.new

        #Initiate the search and handle the not found error thrown by filmBuff
        begin
            imdb_results = imdb.search_for_title(search_query)
        rescue FilmBuff::NotFound
            #Rescue the no results error
            getErrorMessage("No results fitting #{search_query}")
            #imdb_results = Hash.new
        rescue NoMethodError
            #Rescue the Hey Jude input error (Why does this even happen?? It's internal to filmBuff)
            getErrorMessage("An error occurred")
        else

            #Show the results, unless there was an error
            unless imdb_results.length < 1
                #the header text will either be 'Top results for x (of y total)' 'All results for x'
                result_string = "results for &ldquo;#{search_query}&rdquo;"
                if num_results < imdb_results.length && num_results != 0
                    @headerMessage = "Top " + result_string + " (of #{imdb_results.length} total)"
                else
                    @headerMessage = "All " + result_string
                end

                #Generate the actual list of titles

                #If an invalid number of results is needed, give all results
                if num_results <= 0
                    num_results = imdb_results.length
                end

                #populate the list
                @listing = "<ul>"
                for movie_num in 0...num_results
                    unless movie_num >= imdb_results.length
                        @listing += "<li>#{imdb_results[movie_num][:title]} (Released: #{imdb_results[movie_num][:release_year]}) <a href='http://www.imdb.com/title/#{imdb_results[movie_num][:imdb_id]}'>View on IMDb</a></li>"
                    end
                end
                @listing += "</ul>"

                #if not all results are shown, give option to see all
                if imdb_results.length > num_results
                    @footerMessage += "<p><a href = '/search/#{search_query}'> Show all results for <em>#{search_query}</em></a><br><br>"
                end
            end
        end
    end
end

def getErrorMessage (msg)
        @headerMessage = msg
        @headerClass = "error"
end

#stores json results into the variable accessed by json.haml
def jsonResults(search_query)
    imdb_results = Hash.new
    unless search_query == "" || search_query.nil?
        imdb = FilmBuff.new
        begin
            imdb_results = imdb.search_for_title(search_query)
        rescue FilmBuff::NotFound
        rescue NoMethodError
        end
    end
    @imdb_results = imdb_results
end

##################################ROUTING######################################

get '/?' do
    haml :search
end

get '/search/?' do
    haml :search
end

post '/search' do
    @json_only = params[:json_only]
    if @json_only == "on"
        jsonResults(params[:search_query])
        haml :JSON
    else
        getResults(params[:search_query], 5)
        haml :search
    end
end

get '/search/:query/?' do
    getResults(params[:query], "all")
    haml :search
end

get '/search/:query/:num_results' do
    getResults(params[:query], params[:num_results])
    haml :search
end

not_found do
    @headerMessage = "Page not found."
    @headerClass = "error"
    haml :search
end
