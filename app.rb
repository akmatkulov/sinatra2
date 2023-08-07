#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'


configure do

  db = SQLite3::Database.new 'barbershop.db'
  db.execute 'CREATE TABLE IF NOT EXISTS 
    "Users" 
      (
        "id" INTEGER PRIMARY KEY AUTOINCREMENT,
        "username" TEXT,
        "phone" TEXT,
        "date_stamp" TEXT,
        "barber" TEXT,
        "color" TEXT
      )'
end

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
    db = SQLite3::Database.new 'barbershop.db'
    @message = db.execute 'select * from Users order by id desc'
    @title = 'Users in DATABASE'
    erb :message
  else
    @title = "Access denied"
    @message = ["Try", "later"]
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

  db = SQLite3::Database.new 'barbershop.db'
  db.execute 'insert into Users (username, phone, date_stamp, barber, color)
    values (?, ?, ?, ?, ?)', [@name, @phone_number, @date_time, @barber, @color]
  
  erb :visit
end

get '/contacts' do
  erb :contacts
end

