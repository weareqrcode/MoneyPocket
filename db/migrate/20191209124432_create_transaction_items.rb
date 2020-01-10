class CreateTransactionItems < ActiveRecord::Migration[6.0]
  def change
    create_table :transaction_items do |t|
      t.string :title
      t.integer :quantity
      t.decimal :price
      t.decimal :total
      t.references :transaction, null: false, foreign_key: true

      t.timestamps
    end
  end
end
