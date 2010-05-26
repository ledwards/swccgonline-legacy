class CreateRates < ActiveRecord::Migration
  def self.up
    create_table :rates do |t|
      t.references :user
      t.references :rateable, :polymorphic => true
      t.integer :stars
      t.string :dimension

      t.timestamps
    end
    
    add_index :rates, :user_id
    add_index :rates, :rateable_id
    
    add_column :users, :rating_average_skill, :decimal, :default => 0
    add_column :users, :rating_average_sportsmanship, :decimal, :default => 0
    add_column :posts, :rating_average, :decimal, :default => 0
    
  end

  def self.down
    drop_table :rates
    
    remove_column :users, :rating_average_skill
    remove_column :users, :rating_average_sportsmanship
    remove_column :posts, :rating_average
  end
end
