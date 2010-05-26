class DecklistItem

  attr_reader :card, :quantity, :tab
  
  def initialize(card, tab)
    @card = card
    @quantity = 1
    @tab = tab || "main_deck"
  end
  
  def increment_quantity
    @quantity += 1
  end
  
  def decrement_quantity
    @quantity -= 1
  end
  
  def quantity=(q)
    @quantity = q
  end
  
  def tab=(t)
    @tab = t
  end
  
  def self.from_deck_item(deck_item)
    di = self.new(deck_item.card, deck_item.tab)
    di.quantity = deck_item.quantity
    di
  end
  
end
