class DeckboxController < ApplicationController

  def index
    @current_user = User.find_by_id(session[:user_id])
    @decks = @current_user.decks.paginate :page => params[:page], :order => "created_at"
  end
  
  def make_current_deck
    session[:deck_id] = params[:deck_id]
    redirect_to(:controller => "game", :action => "play")
  end
  
  def make_public

  end
end
