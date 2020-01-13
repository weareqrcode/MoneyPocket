class AddTransactionsInvoiceDateColumn < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :invoice_date, :date
  end
end
