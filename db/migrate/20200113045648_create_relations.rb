class CreateRelations < ActiveRecord::Migration[6.0]
  def change
    create_table :relations do |t|
      t.belongs_to :category, null: false, foreign_key: true
      t.belongs_to :transaction_item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
