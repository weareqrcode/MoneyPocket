class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.string :invoice_num
      t.string :invoice_photo
      t.decimal :amount
      t.references :user, null: false, foreign_key: true
      t.integer :status
      t.jsonb :data

      t.timestamps
    end
  end
end
