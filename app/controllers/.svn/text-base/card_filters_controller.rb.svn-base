class CardFiltersController < ApplicationController

  def new
    @card_filter = CardFilter.new
    @card_filter.card_filter_items.build
  end
  
  def create
    @card_filter = CardFilter.new(params[:card_filter])
    @card_filter.user_id = @current_user.id
    if @card_filter.save
      redirect_to :controller => 'deckbuilder', :action => 'index'
    else
      render :action => "new"
    end
  end
  
  def edit
    @card_filter = CardFilter.find(params[:id])
  end
  
  def update
    params[:card_filter][:existing_card_filter_item_attributes] ||= {}
    
    @card_filter = CardFilter.find(params[:id])
    if @card_filter.update_attributes(params[:card_filter])
      redirect_to :controller => 'deckbuilder'
    else
      render :action => 'edit'
    end
  end

  def delete
    @card_filter = CardFilter.find(params[:id])
    if @card_filter.destroy
      redirect_to :controller => 'deckbuilder'
    end
  end

end