require 'sinatra/base'
require 'bcrypt'

class Application < Sinatra::Application

  enable :sessions

  def initialize(app=nil)
    super(app)
  end

  get '/' do
    if session[:id]
      user = DB[:users].where(id: session[:id]).first
    else
      user = false
    end
    erb :index, locals: {:user => user}
  end

  get '/register' do
    erb :register
  end

  post '/register' do
    hashed_password = BCrypt::Password.create(params[:password])
    new_id = DB[:users].insert(
      email: params[:email],
      password: hashed_password
    )
    session[:id] = new_id
    redirect '/'
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  get '/login' do
    erb :login, locals: {:error_message => nil}
  end

  post '/login' do
    user = DB[:users].where(email: params[:email]).first

    # if we have user and the password that matches
    #  good stuff
    # else
    #  error message

    if user && BCrypt::Password.new(user[:password]) == params[:password]
      session[:id] = user[:id]
      redirect '/'
    else
      erb :login, locals: {:error_message => "Email/password is invalid"}
    end
  end

end
