# frozen_string_literal: true

require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def is_barber_exists?(db, name)
  db.execute('select * from Barbers where name=?', [name]).length.positive?
end

def seed_db(db, barbers)
  barbers.each do |barber|
    db.execute 'insert into Barbers (name) values (?)', [barber] unless is_barber_exists? db, barber
  end
end

before do
  db = SQLite3::Database.new 'barbershop.db'
  @barbers = db.execute 'select * from Barbers'
end

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

  db.execute 'CREATE TABLE IF NOT EXISTS
    "Barbers"
      (
        "id" INTEGER PRIMARY KEY AUTOINCREMENT,
        "name" TEXT
      )'

  seed_db db, ['Jessie Pinkman', 'Walter White', 'Gus Fring', 'Mike Ehrmantraut']
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
  else
    @title = 'Access denied'
    @message = %w[Try later]
  end
  erb :message
end

get '/about' do
  erb :about
end

get '/visit' do
  @message = @barbers
  erb :visit
end

# Отправить данные
post '/visit' do
  @name = params[:name]
  @phone_number = params[:phone_number]
  @date_time = params[:date_time]
  @barber = params[:barber]
  @color = params[:color]
  @message = @barbers

  db = SQLite3::Database.new 'barbershop.db'
  db.execute 'insert into Users (username, phone, date_stamp, barber, color)
    values (?, ?, ?, ?, ?)', [@name, @phone_number, @date_time, @barber, @color]

  erb :visit
end

get '/contacts' do
  erb :contacts
end
