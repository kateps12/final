# Set up for the application and database. DO NOT CHANGE. #############################
require "sinatra"                                                                     #
require "sinatra/reloader" if development?                                            #
require "sequel"                                                                      #
require "logger"                                                                      #
require "twilio-ruby"                                                                 #
require "bcrypt"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB ||= Sequel.connect(connection_string)                                              #
DB.loggers << Logger.new($stdout) unless DB.loggers.size > 0                          #
def view(template); erb template.to_sym; end                                          #
use Rack::Session::Cookie, key: 'rack.session', path: '/', secret: 'secret'           #
before { puts; puts "--------------- NEW REQUEST ---------------"; puts }             #
after { puts; }                                                                       #
#######################################################################################

spots_table = DB.from(:spots)
votes_table = DB.from(:votes)
users_table = DB.from(:users)

get "/" do
    puts spots_table.all
    @spots = spots_table.all.to_a
    view "spots"
end

get "/spots/:thincrust/" do
    @spots = spots_table.all.to_a
    view "thinspots"
end

get "/spots/:id" do
    @spot = spots_table.where(id: params[:id]).to_a[0]
    @votes = votes_table.where(spots_id: @spot[:id])
    @vote_count = votes_table.where(spots_id: @spot[:id]).sum(:like)
    @users_table = users_table
    view "spot"
end
###
get "/spots/:id/spots/new" do
    @spot = spots_table.where(id: params[:id]).to_a[0]
    view "new_spot"
end

get "/spots/:id/votes/create" do
    puts params
    @spot = spots_table.where(id: params[:id]).to_a[0]
    votes_table.insert(spots_id: params["id"],
                       user_id: session["user_id"],
                       like: params["like"],
                       comments: params["comments"])
    view "create_vote"
end

