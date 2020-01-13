class AddJsonbTable < ActiveRecord::Migration[6.0]
  def change
    add_column :checks,:jsonb,:jsonb
  end
end
