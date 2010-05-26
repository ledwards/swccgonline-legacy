class DeckbuilderController < ApplicationController
  #auto_complete_for :card, :title
  
  def index
    if params[:deck_id] 
      @deck = set_deck Deck.find(params[:deck_id])
      @decklist = set_decklist(Decklist.from_deck(@deck))
      @side = set_decklist_side(@deck.side)
      if @side.nil?
        @side = set_decklist_side("Dark")
      end
      redirect_to_index("Deck loaded")
    else
      @side = get_decklist_side
      @deck = get_deck
      @decklist = get_decklist
    end

    @saved_card_filters = get_saved_card_filters
    @applied_card_filters = set_applied_card_filters([])
    @search_term = set_search_term(nil)
    @search_results = refresh_search_results
    set_decklist_tab "main_deck"

    respond_to do |format|
      format.html { redirect_to "/m/denied" if not @deck.new_record? and @deck.user != @current_user }
      format.js { render :partial => "search_results" }
    end
  end
  
  def switch_tab
    set_decklist_tab params[:tab]
    respond_to do |format|
      format.js {  }
    end
  end
  
  def change_deck_item_quantity
    @card = Card.find(params[:card_id])
    @tab = get_decklist_tab
    @decklist = get_decklist
    @decklist_item = @decklist.items.find { |i| i.card == @card and i.tab == @tab }
    @qty = params[:quantity].to_i
    
    if @decklist_item.quantity != @qty
      @decklist_item.quantity = @qty
      set_decklist @decklist
    end
    
    respond_to do |format|
      format.js { }
    end
  end
  
  def move_between_tabs
    @card = Card.find(params[:card_id])
    @destination = params[:destination]
    @decklist = get_decklist
    @tab = get_decklist_tab
    @decklist_item = @decklist.items.find { |i| i.card == @card and i.tab == @tab }
    @decklist.move_item_to_tab(@decklist_item, @destination)
    respond_to { |format| format.js }
  end
  
  def paginate
    @search_results = refresh_search_results
    respond_to do |format| 
      format.js { render :partial => "search_results" }
    end
  end
  
  def from_file
  end
  
  def change_sides
    current_side = get_decklist_side
    
    if current_side == "Light"
      @side = "Dark"
    elsif current_side == "Dark"
      @side = "Light"
    end
    
    set_decklist_side(@side)
    @search_results = refresh_search_results
    
    respond_to { |format| format.js }
  end
  
  def add_to_decklist
    begin
      card = find_card(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid card #{params[:id]}")
      redirect_to_index("Invalid card")
    else
      @decklist = get_decklist
      @tab = get_decklist_tab
      @current_item = @decklist.add_card(card, @tab)
      respond_to { |format| format.js }
    end
  end
  
  def remove_from_decklist
    begin
      card = find_card(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid card #{params[:id]}")
      redirect_to_index("Invalid decklist item")
    else
      @decklist = get_decklist
      @tab = get_decklist_tab
      @current_item = @decklist.remove_card(card, @tab)
      respond_to { |format| format.js }
    end
  end
  
  def auto_complete_for_card_title
    #should search within normal results
    @cards = full_card_search(params[:card][:title])[0,10].collect {|c| Card.find(c)}
    render :partial => 'cards'
    #On click, submit a search or add to decklist
  end
  
  def apply_card_filter
    # TODO: only if the card_card_filter isn't already in the list
    @card_filter = CardFilter.find(params[:id])
    set_applied_card_filters(get_applied_card_filters + [params[:id].to_i])
    @applied_card_filters = get_applied_card_filters.collect {|f| CardFilter.find(f)}
    @saved_card_filters = get_saved_card_filters
    @search_term = get_search_term
    @search_results = refresh_search_results
    respond_to { |format| format.js }
  end
  
  def remove_card_filter
    @card_filter = CardFilter.find(params[:id])
    subtract_applied_card_filter(params[:id].to_i)
    @applied_card_filters = get_applied_card_filters.collect {|f| CardFilter.find(f)}
    @saved_card_filters = get_saved_card_filters - get_applied_card_filters
    @search_term = get_search_term
    @search_results = refresh_search_results
    respond_to { |format| format.js } 
  end
  
  def search
    # This search is performed on click for the Search button
    if params[:card][:title].empty?
      @search_results = get_card_pool
    else
      @search_term = set_search_term(params[:card][:title])
      @search_results = refresh_search_results
      respond_to { |format| format.js }
    end
  end
  
  def save_deck
    @deck = get_deck
    @decklist = get_decklist
    
    if @deck.new_record?
      @deck = Deck.new(params[:deck])
      @deck.user_id = @current_user.id
      @deck.save
      @deck.add_deck_items_from_decklist(@decklist)
      @deck.save #necessary?
    else
      @deck.update_attributes(params[:deck])
      @deck.deck_items = []
      @deck.save #necessary?
      @deck.add_deck_items_from_decklist(@decklist)
      @deck.save #necessary?
    end
    
    if @deck.title.nil?
      @deck.title = "untitled deck"
    end
    
    if @deck.errors.empty?
      @deck = set_deck Deck.new(:title=>"untitled deck")
      @decklist = set_decklist Decklist.new
      respond_to { |format| format.js }
    end
    
  end
  
  def clear_decklist
    @deck = set_deck Deck.new
    @decklist = set_decklist Decklist.new
    respond_to { |format| format.js }
  end
  
  def remove_search_term
    @search_term = set_search_term(nil)
    @search_results = refresh_search_results
    respond_to { |format| format.js }
  end
  
  def clear_results
    redirect_to_index "Cleared search results."
  end
  
  def add_new_criteria
    respond_to { |format| format.js }
  end

  def add_new_edit_criteria
    @card_filter = CardFilter.find(params[:id])
    respond_to { |format| format.js }
  end

  def edit_card_filter
    @card_filter = CardFilter.find(params[:id])
    respond_to { |format| format.js }
  end
  
  def hide_edit_card_filter
    @card_filter = CardFilter.find(params[:id])
    respond_to { |format| format.js }
  end

  def create_card_filter
    @card_filter = CardFilter.new(params[:card_filter])
    @card_filter.user_id = @current_user.id
    if @card_filter.save
      flash.now[:save_status] = "Success"
    else
      flash.now[:save_status] = @card_filter.errors.full_messages
    end
    respond_to { |format| format.js }
  end
  
  def update_card_filter
    @card_filter = CardFilter.find(params[:card_filter][:id])
    @applied_card_filters = get_applied_card_filters.collect {|f| CardFilter.find(f)}
    if @card_filter.update_attributes(params[:card_filter])
      flash.now[:save_status] = "Success"
    else
      flash.now[:save_status] = @card_filter.errors.full_messages
    end
    if @applied_card_filters.index @card_filter
      @search_results = refresh_search_results
    end 
    respond_to { |format| format.js }
  end
  
  def delete_card_filter
    @filter_id = params[:id].to_i
    subtract_applied_card_filter(@filter_id)
    CardFilter.find(@filter_id).destroy
    @search_results = refresh_search_results
    @applied_card_filters = get_applied_card_filters
    @saved_card_filters = get_saved_card_filters
    respond_to { |format| format.js }
  end

  private  
  
  # Get methods return proper objects by looking in the session store
  def get_deck
    session[:deck] || Deck.new(:title => "untitled deck")
  end
  
  def get_decklist
    session[:decklist] ||= Decklist.new
  end
  
  def get_decklist_tab
    session[:decklist_tab] || "main_deck"
  end
  
  def get_decklist_side
    session[:decklist_side] || "Dark"
  end
  
  def get_search_results
    # returns card ids, should return card objects
    session[:search_results] ||= get_card_pool.collect { |c| c.id }
  end
  
  def get_applied_card_filters
    session[:applied_card_filters] ||= []
  end
  
  def get_search_term
    session[:search_term]
  end
  
  def get_card_pool
    Card.find_all_by_side(get_decklist_side).collect{|c| c.id}
  end
  
  def get_saved_card_filters
    CardFilter.find_all_by_user_id(@current_user.id).collect{|f| f.id}
  end
  
  # Set methods store data in the session by ID
  
  def set_decklist_tab(tab)
    session[:decklist_tab] = tab
  end
  
  def set_search_term(search_term)
    session[:search_term] = search_term
  end
  
  def set_search_results(results)
    session[:search_results] = results.paginate :page => params[:page], :order => "title"
  end
  
  def set_deck(deck)
    session[:deck] = deck
  end
  
  def set_decklist(decklist)
    session[:decklist] = decklist
  end
  
  def set_decklist_side(side)
    session[:decklist_side] = side
  end
  
  def set_applied_card_filters(filters_list)
    session[:applied_card_filters] = filters_list
  end
  
  def add_applied_card_filter(f)
    session[:applied_card_filters] = session[:applied_card_filters] | [f]
  end
  
  def subtract_applied_card_filter(f)
    session[:applied_card_filters].delete(f)
  end
  
  #move to model
  def find_card(id)
    Card.find(id) #replace this with memcaching
  end

  def refresh_search_results
    if !get_search_term.nil?
      search_results = full_card_search(get_search_term)
    else
      search_results = get_card_pool
    end
    applied_card_filters = get_applied_card_filters
    unless applied_card_filters.empty?
      applied_card_filters.each{|f| search_results = search_results & CardFilter.find(f).get_cards.collect{|c|c.id} }
    end
    set_search_results search_results
  end
  
  # move this shit to model, dumbass, and use ferret or some shit
  def full_card_search(search_term)
    # Takes a param and searches Title, Gametext, Lore in Cards for it
    # Returns a list of IDs of matching cards
        
    #horribly inefficient
        
    results_ids = []
    set_search_term(search_term)
    if search_term.nil?
      search_term = ""
    end
    
    (Card.find(:all, :select => "id",
    :conditions => [ 'LOWER(title) LIKE ? AND side = ?',
    '%' + search_term + '%', get_decklist_side  ]) |
    Card.find(:all, :select => "id",
    :conditions => [ 'LOWER(gametext) LIKE ? AND side = ?',
    '%' + search_term + '%', get_decklist_side ]) |
    Card.find(:all, :select => "id",
    :conditions => [ 'LOWER(lore) LIKE ? AND side = ?',
    '%' + search_term + '%', get_decklist_side ])).each{ |card| results_ids << card.id  }
    
    #If this doesnt work, try LIKE instead of =
    
    results_ids
  end
  
  def redirect_to_index(msg)
    # This shouldn't be needed if everything is Ajax
    flash[:notice] = msg if msg
    redirect_to :action => :index
  end
  
end