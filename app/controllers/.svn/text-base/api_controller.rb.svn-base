class ApiController < ApplicationController
  skip_before_filter :authorize
  
  def card_lookup
    card_title = params[:name]
    card = Card.find_by_title(card_title)
    render :json => card.to_json
  end
end