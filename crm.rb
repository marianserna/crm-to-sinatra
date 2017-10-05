require_relative 'contact'
require 'sinatra'

get '/' do
  @contacts = Contact.all
  erb :index
end

get '/about' do
  erb :about
end

# new
get '/contacts/new' do
  @contact = Contact.new
  erb :"contacts/new"
end

# create
post '/contacts' do
  # raise params.inspect
  @contact = Contact.new({
    first_name: params["contact"]["first_name"],
    last_name: params["contact"]["last_name"],
    email: params["contact"]["email"],
    note: params["contact"]["note"]
  })

  if @contact.save
    redirect to ("/contacts")
  else
    erb :"contacts/new"
  end
end

# edit
get '/contacts/:id/edit' do
  begin
    @contact = Contact.find(params[:id])
    erb :"contacts/edit"
  rescue ActiveRecord::RecordNotFound
    raise Sinatra::NotFound
  end
end

# update
put '/contacts/:id' do
  @contact = Contact.find(params[:id])
  @contact.update({
    first_name: params["contact"]["first_name"],
    last_name: params["contact"]["last_name"],
    email: params["contact"]["email"],
    note: params["contact"]["note"]
  })

  if @contact.save
    redirect to ("/contacts")
  else
    erb :"contacts/:id"
  end
end

# index
get '/contacts' do
  @contacts = Contact.all
  # raise @contacts.inspect
  erb :"contacts/index"
end

# show
get '/contacts/:id' do
  begin
    @contact = Contact.find(params[:id])
    erb :"contacts/show"
  rescue ActiveRecord::RecordNotFound
    raise Sinatra::NotFound
  end

  # @contact = Contact.find_by({id: params[:id].to_i})
  # if @contact
  #   erb :show_contact
  # else
  #   raise Sinatra::NotFound
  # end
end

# delete
delete '/contacts/:id' do
  begin
    @contact = Contact.find(params[:id])
    @contact.delete
    redirect to('/contacts')
  rescue ActiveRecord::RecordNotFound
    raise Sinatra::NotFound
  end
end

# MiniRecord config
after do
  ActiveRecord::Base.connection.close
end
