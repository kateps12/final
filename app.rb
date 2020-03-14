# Set up for the application and database. DO NOT CHANGE. #############################
require "sinatra"                                                                     #
require "sinatra/reloader" if development?                                            #
require "sequel"                                                                      #
require "logger"                                                                      #
require "twilio-ruby"                                                                 #
require "bcrypt"   
require "geocoder"                                                                #
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

before do
    @current_user = users_table.where(id: session["user_id"]).to_a[0]
    @spots = spots_table.all.to_a
end

get "/" do
    puts spots_table.all
    view "spots"
end

# get "/spots/thincrust" do
#     puts params
#     view "thincrust"
# end

# get "/spots/deepdish" do
#     view "deepdish"
# end

get "/spots/:id" do
    @spot = spots_table.where(id: params[:id]).to_a[0]
    @votes = votes_table.where(spots_id: @spot[:id])
    @vote_count = votes_table.where(spots_id: @spot[:id]).sum(:like)
    @users_table = users_table
    view "spot"
end

get "/spots/:id/votes/new" do
    puts params
    @spot = spots_table.where(id: params[:id]).to_a[0]
    view "new_vote"
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

# get "/spots/newspot" do
#     puts params
#     @spots = spots_table.all.to_a
#     @spot = spots_table.where(id: params[:id]).to_a[0]
#     view "new_spot"
# end

# get "/spots/create" do
#     puts params
#     spots_table.insert(id: params["id"],
#                        name: session["name"],
#                        address: params["address"],
#                        phone: params["phone"],
#                        website: params["website"],
#                        thincrust: params["thincrust"])
#     view "create_spot"
# end

get "/users/new" do
    view "new_user"
end

get "/users/create" do
    puts params
    users_table.insert(name: params["name"],
                       email: params["email"],
                       password: BCrypt::Password.create(params["password"]))
    view "create_user"
end

get "/logins/new" do
    view "new_login"
end

post "/logins/create" do
    puts params
    email_address = params["email"]
    password = params["password"]

    @user = users_table.where(email: email_address).to_a[0]
    #is there a user in the users table where the email is equal to the email address?
    #we will select a user from the users table where the email address is equal to the email. 
    #need to check it, so use IF statement.

    if @user
        if BCrypt::Password.new(@user[:password]) == password #see variable defined above, where password = params["password"]
            session["user_id"] = @user[:id]
            view "create_login"
        else 
            view "create_login_failed"
        end
    else 
        view "create_login_failed"
    end
end

get "/logout" do
    session["user_id"] = nil
    view "logout"
end
