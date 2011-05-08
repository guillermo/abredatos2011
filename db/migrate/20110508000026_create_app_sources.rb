class CreateAppSources < ActiveRecord::Migration
  def self.up
    create_table :app_sources do |t|
      t.references :app
      t.references :source

      t.timestamps
    end
  end

  def self.down
    drop_table :app_sources
  end
end
