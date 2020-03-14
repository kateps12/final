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
  String :thincrust
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
                   thincrust: "Yes")

spots_table.insert(name: "Pequod's Pizza", 
                   address: "2207 N Clybourn Ave, Chicago, IL 60614",
                   phone: "(773) 327-1512",
                   website: "pequodspizza.com",
                   thincrust: "No")

spots_table.insert(name: "Lou Malnati's (chain - many locations)", 
                   address: "6649 North Lincoln Avenue, Lincolnwood, IL 60712",
                   phone: "(847) 673-0800",
                   website: "loumalnatis.com",
                   thincrust: "No")

spots_table.insert(name: "Marie's Pizza & Liquors", 
                   address: "4129 W Lawrence Ave, Chicago, IL 60630",
                   phone: "(773) 725-1812",
                   website: "mariespizzachicago.com",
                   thincrust: "Yes")

spots_table.insert(name: "Barones Of Glen Ellyn", 
                   address: "475 Pennsylvania Ave, Glen Ellyn, IL 60137",
                   phone: "(630) 858-0555",
                   website: "bpizza.com",
                   thincrust: "Yes")

spots_table.insert(name: "Giordano's (chain - many locations)", 
                   address: "730 N Rush St, Chicago, IL 60611",
                   phone: "(312) 951-0747",
                   website: "giordanos.com",
                   thincrust: "No")

spots_table.insert(name: "Pizzeria Uno (Original location)", 
                   address: "29 E Ohio St, Chicago, IL 60611",
                   phone: "(312) 321-1000",
                   website: "pizzeriaunodue.com",
                   thincrust: "No")

spots_table.insert(name: "Fox's Pizza & Irish Pub", 
                   address: "9655 W 143rd St, Orland Park, IL 60462",
                   phone: "(708) 349-2111",
                   website: "foxspubs.com",
                   thincrust: "Yes")

spots_table.insert(name: "Barraco's Pizza", 
                   address: "3701 95th St, Evergreen Park, IL 60805",
                   phone: "(708) 424-8182",
                   website: "barracos.com",
                   thincrust: "Yes")

spots_table.insert(name: "Beggars Pizza", 
                   address: "10240 Central Ave, Oak Lawn, IL 60453",
                   phone: "(708) 499-0505",
                   website: "beggarspizza.com",
                   thincrust: "Yes")

spots_table.insert(name: "The Art of Pizza", 
                   address: "3033 N Ashland Ave, Chicago, IL 60657",
                   phone: "(773) 327-5600",
                   website: "theartofpizzamenu.com",
                   thincrust: "No")

spots_table.insert(name: "My Pi Pizza", 
                   address: "2010 N Damen Ave, Chicago, IL 60647",
                   phone: "(773) 394-6900",
                   website: "mypiepizza.com",
                   thincrust: "No")