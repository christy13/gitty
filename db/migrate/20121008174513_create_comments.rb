class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :description
      t.references :author, :null => false
      t.references :commentable, :polymorphic => true

      t.timestamps
    end
  end
end
