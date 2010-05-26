class AddPublicDecklists < ActiveRecord::Migration
  def self.up
    add_column :decks, :shared, :boolean
    add_column :decks, :locked, :boolean
    add_column :posts, :deck_id, :integer
  end

  def self.down
    remove_column :decks, :shared
    remove_column :decks, :locked
    remove_column :posts, :deck_id
  end
end
