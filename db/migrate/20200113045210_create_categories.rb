class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string :tag_name

      t.timestamps
    end
  end
end
