class AddCategoryToSource < ActiveRecord::Migration
  def self.up
    add_column :sources, :category_id, :integer
  end

  def self.down
    remove_column :sources, :category_id
  end
end
