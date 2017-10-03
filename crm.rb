require_relative 'contact'
require 'sinatra'

get '/' do
  erb :index
end

get '/contacts' do
  @contacts = Contact.all
  # raise @contacts.inspect
  erb :contacts
end


# MiniRecord config

after do
  ActiveRecord::Base.connection.close
end
