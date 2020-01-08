class CreateIncomes < ActiveRecord::Migration[6.0]
  def change
    create_table :incomes do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.decimal :total

      t.timestamps
    end
  end
end
