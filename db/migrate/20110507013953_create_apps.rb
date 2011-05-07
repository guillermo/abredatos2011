class CreateApps < ActiveRecord::Migration
  def self.up
    create_table :apps do |t|
      t.string :name
      t.string :url
      t.text :description
      t.string :price
      t.string :author
      t.string :app_type
      t.references :category
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :apps
  end
end
