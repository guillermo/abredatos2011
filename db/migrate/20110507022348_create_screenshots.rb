class CreateScreenshots < ActiveRecord::Migration
  def self.up
    create_table :screenshots do |t|
      t.string :url
      t.references :about, :polymorphic => true
      t.string :uuid
      t.string :workflow_state
      t.text :build_log
      t.timestamps
    end
  end

  def self.down
    drop_table :screenshots
  end
end
