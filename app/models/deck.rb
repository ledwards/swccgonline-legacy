class Deck < ActiveRecord::Base
  has_many :deck_items
  has_many :cards, :through => :deck_items
  has_one :post
  belongs_to :user
  
  validates_presence_of :title
  
  has_attached_file :import_file
  
  def before_save
    self.locked ||= false
    self.shared ||= false
    return true
  end
  
  def self.find_decks
    find(:all, :order => :title)
  end
  
  def self.get_my_decks(user_id)
    # this should go to the User.rb file I think
    find(:all, :conditions => [ "user_id = ?", user_id])
  end
  
  def get_cards
    cards = []
    for deck_item in deck_items
      cards << [deck_item.card] * deck_item.quantity
    end
    cards.flatten
  end
  
  def get_main_deck_cards
    cards = []
    for deck_item in deck_items
      if deck_item.tab == "main_deck"
        cards << [deck_item.card] * deck_item.quantity
      end
    end
    cards.flatten
  end
  
  def get_cards_by_card_type
    self.get_main_deck_cards.group_by(&:card_type)
  end
  
  def get_side_deck_cards
    cards = []
    for deck_item in deck_items
      if deck_item.tab == "side_deck"
        cards << [deck_item.card] * deck_item.quantity
      end
    end
    cards.flatten
  end
  
  def get_sixtyfirst_cards
    cards = []
    for deck_item in deck_items
      if deck_item.tab == "sixtyfirst_cards"
        cards << [deck_item.card] * deck_item.quantity
      end
    end
    cards.flatten
  end
  
  def add_deck_items_from_decklist(decklist)
    decklist.items.each do |item|
      di = DeckItem.from_decklist_item(item)
      deck_items << di
    end
  end
  
  def update_deck_items_from_decklist(decklist)
    deck_items = []
    save
    add_deck_items_from_decklist(decklist)
  end
  
  def side
    # this should be a real attribute
    if not cards.empty?
      cards.first.side
    else
      "Dark"
    end
  end
  
  def shortened_description
    if not description.nil?
      description.first(40)
    else
      "No description."
    end
  end
  
  def created_on_date
    created_at.month.to_s + "." + created_at.day.to_s + "." + created_at.year.to_s.last(2)
  end
  
end