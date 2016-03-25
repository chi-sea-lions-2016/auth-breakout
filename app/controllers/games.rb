before '/games*' do
  redirect '/session/new' unless logged_in?
end

get '/games' do
  @games = Game.all
  erb :"games/index"
end

get '/games/new' do
  @game = Game.new
  erb :"games/new"
end

post '/games' do
  @game = Game.new(params[:game])

  if @game.save
    current_user.games << @game
    redirect '/games'
  else
    erb :"games/new"
  end
end

get '/games/:id' do
  @game = Game.find_by(id: params[:id])
  erb :"games/show"
end

get '/games/:id/edit' do
  @game = Game.find_by(id: params[:id])

  if owner?(@game)
    erb :"games/edit"
  else
    redirect '/not_authorized'
  end
end

put '/games/:id' do
  @game = Game.find_by(id: params[:id])

  if owner?(@game)
    if @game.update_attributes(params[:game])
      redirect '/games'
    else
      erb :"games/edit"
    end
  else
    redirect '/not_authorized'
  end
end

delete '/games/:id' do
  if owner?(@game)
    @game = Game.find_by(id: params[:id])
    @game.destroy
    redirect '/games'
  else
    redirect '/not_authorized'
  end
end

