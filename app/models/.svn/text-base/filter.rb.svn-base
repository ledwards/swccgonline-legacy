class Filter < ActiveRecord::Base
  has_many :filter_items, :dependent => :destroy
  after_update :save_filter_items

  def self.get_filters_for(user_id)
    find_all_by_user_id(user_id)
  end
  
  def self.get_filter_names_for(user_id)
    names = []
    self.find_all_by_user_id(user_id).each do |f|
      names << f.name
    end
    names
  end
  
  def self.get_filter_ids_for(user_id)
    ids = []
    self.find_all_by_user_id(user_id).each do |f|
      ids << f.id
    end
    ids
  end
  
  def apply_to_list(card_list)
    #applies this filter to the input list of cards
    get_cards & card_list
  end
  
  def new_filter_item_attributes=(filter_item_attributes)
    filter_item_attributes.each do |attributes|
      filter_items.build(attributes)
    end
  end
  
  def existing_filter_item_attributes=(filter_item_attributes)
    filter_items.reject(&:new_record?).each do |filter_item|
      attributes = filter_item_attributes[filter_item.id.to_s]
      if attributes
        filter_item.attributes = attributes
      else
        filter_items.delete(filter_item)
      end
    end
  end
  
  def add_new_filter_item(fi)
    filter_items << fi
  end
  
  def add_filter
    # do something with the current filter here
    filter_items = []
  end
  
  def get_cards
    cards = filter_items.first.get_cards
    filter_items.each do |fi|
      cards = cards & fi.get_cards
    end
    return cards
  end
  
  def save_filter_items
    filter_items.each do |filter_item|
      filter_item.save(false)
    end
  end

  
end