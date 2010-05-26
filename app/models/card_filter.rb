class CardFilter < ActiveRecord::Base
  has_many :card_filter_items, :dependent => :destroy
  after_update :save_card_filter_items

  def self.get_card_filters_for(user_id)
    find_all_by_user_id(user_id)
  end
  
  def self.get_card_filter_names_for(user_id)
    names = []
    self.find_all_by_user_id(user_id).each do |f|
      names << f.name
    end
    names
  end
  
  def self.get_card_filter_ids_for(user_id)
    ids = []
    self.find_all_by_user_id(user_id).each do |f|
      ids << f.id
    end
    ids
  end
  
  def apply_to_list(card_list)
    #applies this card_filter to the input list of cards
    get_cards & card_list
  end
  
  def new_card_filter_item_attributes=(card_filter_item_attributes)
    card_filter_item_attributes.each do |attributes|
      card_filter_items.build(attributes)
    end
  end
  
  def existing_card_filter_item_attributes=(card_filter_item_attributes)
    card_filter_items.reject(&:new_record?).each do |card_filter_item|
      attributes = card_filter_item_attributes[card_filter_item.id.to_s]
      if attributes
        card_filter_item.attributes = attributes
      else
        card_filter_items.delete(card_filter_item)
      end
    end
  end
  
  def add_new_card_filter_item(fi)
    card_filter_items << fi
  end
  
  def add_card_filter
    # do something with the current card_filter here
    card_filter_items = []
  end
  
  def get_cards
    cards = card_filter_items.first.get_cards
    card_filter_items.each do |fi|
      cards = cards & fi.get_cards
    end
    return cards
  end
  
  def save_card_filter_items
    card_filter_items.each do |card_filter_item|
      card_filter_item.save(false)
    end
  end

  
end