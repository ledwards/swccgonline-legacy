class CreateDecks < ActiveRecord::Migration
  def self.up
    create_table :decks do |t|
      t.string :title
      t.text :description
      
      t.integer :user_id, :null => false, :options =>
        "CONSTRAINT: fk_deck_users REFERENCES users(id)"
      
      t.timestamps
    end
  end

  def self.down
    drop_table :decks
  end
end
