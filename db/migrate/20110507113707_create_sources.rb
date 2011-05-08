class CreateSources < ActiveRecord::Migration
  def self.up
    create_table :sources do |t|
      t.string :source_type
      t.string :index
      t.string :search
      t.string :title
      t.references :user
      t.text :description
      t.string :url
      t.timestamps
    end
  end

  def self.down
    drop_table :sources
  end
end
