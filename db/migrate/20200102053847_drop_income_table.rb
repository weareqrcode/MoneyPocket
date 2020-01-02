class DropIncomeTable < ActiveRecord::Migration[6.0]
  def up
    drop_table :incomes
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
