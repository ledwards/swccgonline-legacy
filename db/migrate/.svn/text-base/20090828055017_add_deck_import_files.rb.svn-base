class AddDeckImportFiles < ActiveRecord::Migration
  def self.up
    add_column :decks, :import_file_file_name, :string # Original filename
    add_column :decks, :import_file_content_type, :string # Mime type
    add_column :decks, :import_file_file_size, :integer # File size in bytes
    add_column :decks, :import_file_updated_at,   :datetime # Last file update time
  end

  def self.down
    remove_column :decks, :import_file_file_name # Original filename
    remove_column :decks, :import_file_content_type # Mime type
    remove_column :decks, :import_file_file_size # File size in bytes
    remove_column :decks, :import_file_updated_at # Last file update time
  end
end
