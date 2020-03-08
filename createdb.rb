# Set up for the application and database. DO NOT CHANGE. #############################
require "sequel"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB = Sequel.connect(connection_string)                                                #
#######################################################################################

# Database schema - this should reflect your domain model
# DB.create_table! :events do
#   primary_key :id
#   String :title
#   String :description, text: true
#   String :date
#   String :location
# end
# DB.create_table! :rsvps do
#   primary_key :id
#   foreign_key :event_id
#   Boolean :going
#   String :name
#   String :email
#   String :comments, text: true
# end

DB.create_table! :spots do
  primary_key :id
  String :name
  String :address
  String :phone
  String :website
  Boolean :thincrust
  end
DB.create_table! :votes do
  primary_key :id
  foreign_key :spots_id
  foreign_key :user_id
  Boolean :like
  String :comments, text: true
end
DB.create_table! :users do
  primary_key :id
  String :name
  String :email
  String :password
end



# Insert initial (seed) data
spots_table = DB.from(:spots)

spots_table.insert(name: "Roseangela's", 
                   address: "2807 95th St, Evergreen Park, IL 60805",
                   phone: "(708) 422-2041",
                   website: "n/a",
                   thincrust: 1)

spots_table.insert(name: "Pequod's Pizza", 
                   address: "2207 N Clybourn Ave, Chicago, IL 60614",
                   phone: "(773) 327-1512",
                   website: "pequodspizza.com",
                   thincrust: 0)
