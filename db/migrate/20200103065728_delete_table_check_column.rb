class DeleteTableCheckColumn < ActiveRecord::Migration[6.0]
  def change
    remove_column :checks, :invoYm, :string
    remove_column :checks, :superPrizeNo, :integer
    remove_column :checks, :spcPrizeNo, :integer
    remove_column :checks, :firstPrizeNo1, :integer
    remove_column :checks, :firstPrizeNo2, :integer
    remove_column :checks, :firstPrizeNo3, :integer
    remove_column :checks, :sixthPrizeNo1, :integer
    remove_column :checks, :sixthPrizeNo2, :integer
    remove_column :checks, :sixthPrizeNo3, :integer
  end
end
