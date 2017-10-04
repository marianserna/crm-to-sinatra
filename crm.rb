require_relative 'contact'
require 'sinatra'

get '/' do
  @contacts = Contact.all
  erb :index
end

get '/contacts' do
  @contacts = Contact.all
  # # raise @contacts.inspect
  erb :contacts
end

get '/contacts/:id' do
  # @contact = Contact.find(params[:id])
  @contact = Contact.find_by({id: params[:id].to_i})
  if @contact
    erb :show_contact
  else
    raise Sinatra::NotFound
  end
end

get '/about' do
  erb :about
end

# MiniRecord config
after do
  ActiveRecord::Base.connection.close
end
