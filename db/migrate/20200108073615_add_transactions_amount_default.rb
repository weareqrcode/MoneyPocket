class AddTransactionsAmountDefault < ActiveRecord::Migration[6.0]
  def change
    change_column_default :transactions, :amount, 0
  end
end
