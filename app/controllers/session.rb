get '/session/new' do
  erb :"session/new"
end

post '/session' do
  if user = User.authenticate(params[:username], params[:password])
    session[:user_id] = user.id
    redirect '/'
  else
    @message = "Something went wrong"
    erb :"session/new"
  end
end

get '/logout' do
  session.delete(:user_id)
  redirect '/'
end

get '/not_authorized' do
  erb :not_authorized
end