class Decklist
  attr_reader :items
  
  def initialize
    @items = []
  end
  
  def add_card(card, tab)
    current_items = @items.find_all {|item| item.card == card}
    
    if current_items.length > 0
      current_item = current_items.find { |item| item.tab == tab }
    end
    
    if current_item
      current_item.increment_quantity
    else
      current_item = DecklistItem.new(card, tab)
      @items << current_item
    end
    
    current_item
  end
  
  def remove_card(card, tab)
    current_item = @items.find {|item| item.card.id == card.id and item.tab == tab}
    if current_item
      @items.delete(current_item)
    end
  end
  
  def move_item_to_tab(item, destination)
    existing_decklist_item = @items.find { |i| i.card == item.card and i.tab == destination }
    if existing_decklist_item
      existing_decklist_item.quantity = existing_decklist_item.quantity + item.quantity
      @items.delete(item)
    else
      item.tab = destination
    end
  end
  
  def total_quantity
    @items.sum { |item| item.quantity }
  end
  
  def quantity_by_tab(tab)
    tab_items = find_all_by_tab(tab)
    tab_items.sum { |item| item.quantity }
  end
  
  def find_decklist_item_by_id(id)
    @items.find_all{|item|item.id==id.to_i}.first
  end
  
  def find_all_by_tab(tab)
    @items.find_all{|item|item.tab == tab}
  end
  
  def items=(items)
    @items = items
  end
  
  def self.from_deck(deck)
    d = Decklist.new
    d.items = deck.deck_items.collect { |di| DecklistItem.from_deck_item(di) }
    return d
  end
end