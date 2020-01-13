class CreateChecks < ActiveRecord::Migration[6.0]
  def change
    create_table :checks do |t|
      t.string :invoYm
      t.integer :superPrizeNo
      t.integer :spcPrizeNo
      t.integer :firstPrizeNo1
      t.integer :firstPrizeNo2
      t.integer :firstPrizeNo3
      t.integer :sixthPrizeNo1
      t.integer :sixthPrizeNo2
      t.integer :sixthPrizeNo3

      t.timestamps
    end
  end
end
