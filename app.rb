#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/' do
	erb :welcome		
end
get '/admin' do
  erb :admin
end

post '/admin' do
   @login = params['login']
  @password = params['pass']

  if @login == 'admin' && @password == 'secret'
    @message = File.read('public/users.txt')
    @title = 'Textfile'
    erb :message
  else
    @title = "Access denied"
    @message = "Try at later"
    erb :message
  end
end

get '/about' do
  erb :about
end

get '/visit' do
  erb :visit
end

#Отправить данные
post '/visit' do
  @name = params[:name]
  @phone_number = params[:phone_number]
  @date_time = params[:date_time]
  @barber = params[:barber]
  @color = params[:color]

  f = File.open 'public/users.txt', 'a'
  f.write "User: #{@name}, Barber: #{@barber}, Phone: #{@phone_number}, Date and Time: #{@date_time} Color: #{@color}\n"
  f.close

  erb :visit
end

get '/contacts' do
  @error = 'something wrong'
  erb :contacts
end