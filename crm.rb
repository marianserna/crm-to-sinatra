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
    note: params["contact"]["note"],
    is_active: params["contact"]["is_active"]
  })

  if @contact.save
    redirect to ("/contacts")
  else
    erb :"contacts/new"
  end
end

# index
get '/contacts' do
  @contacts = Contact.all
  # raise @contacts.inspect
  erb :"contacts/index"
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
    note: params["contact"]["note"],
    is_active: params["contact"]["is_active"]
  })

  if @contact.save
    redirect to ("/contacts")
  else
    erb :"contacts/:id"
  end
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

# search
get '/search' do
  # @contacts = case params[:search_field]
  # when "first_name"
  #   # Contact.where(first_name: params[:q])
  #   Contact.where("first_name like ?", "%#{params[:q]}%")
  # when "last_name"
  #   Contact.where("last_name like ?", "%#{params[:q]}%")
  # when "email"
  #   Contact.where("email like ?", "%#{params[:q]}%")
  # else
  #   []
  # end
  if ["first_name", "last_name", "email"].include?(params[:search_field])
    @contacts = Contact.where("#{params[:search_field]} like ?", "%#{params[:q]}%")
    @search = true
  else
    @search = false
  end

  erb :search
end

# MiniRecord config
after do
  ActiveRecord::Base.connection.close
end
