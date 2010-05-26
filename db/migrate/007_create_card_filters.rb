class CreateCardFilters < ActiveRecord::Migration
  def self.up
    create_table :card_filters do |t|
      t.string :name
      
      t.integer :user_id, :null => false, :options =>
        "CONSTRAINT: fk_card_filter_users REFERENCES users(id)"
      
    end
    
    create_table :card_filter_items do |t|
      
      t.string :category
      t.string :condition
      t.string :value
      
      t.integer :card_filter_id, :null => false, :options =>
        "CONSTRAINT fk_card_filter_item_card_filters REFERENCES decks(id)"
        
    end
  end

  def self.down
    drop_table :card_filters
    drop_table :card_filter_items
  end
end
