class AddPraiseToComments < ActiveRecord::Migration
  def change
    add_column :comments, :praise_count, :integer, :null => false, :default => 0
  end
end
