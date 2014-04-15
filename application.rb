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

end
