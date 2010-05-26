class DecksController < ApplicationController

  def index
  end
  
  def new
    @deck = Deck.new(params[:deck])
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @deck }
    end
  end

  # GET /decks/1/edit
  def edit
    @deck = Deck.find(params[:id])
    
    respond_to do |format|
      format.html # edit.html.erb
    end
  end

  # ??? /decks/create
  def create
    @deck = Deck.new(params[:deck])
    @deck.user_id = @current_user.id
    @decklist = session[:decklist]
    
    respond_to do |format|
      if @deck.save
        @deck.add_deck_items_from_decklist(@decklist)
        @deck.save
        flash[:notice] = 'Deck was successfully created.'
        format.html { redirect_back_or_default("/deckbuilder") }
        format.xml  { render :xml => @deck, :status => :created, :location => @deck }
      else
        format.html { render :controller => "deckbuilder" }
        format.xml  { render :xml => @deck.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /decks/1
  # PUT /decks/1.xml
  def update
    @deck = Deck.find(params[:id])
    @deck.deck_items = []
    @deck.add_deck_items_from_decklist(session[:decklist])

    respond_to do |format|
      if @deck.update_attributes(params[:deck])
        flash[:notice] = 'Deck was successfully updated.'
        format.html { redirect_to :controller => "deckbuilder" }
        format.xml  { head :ok }
      else
        format.html { render :controller => "deckbuilder" }
        format.xml  { render :xml => @deck.errors, :status => :unprocessable_entity }
      end
    end
  end
  

end
