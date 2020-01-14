class ChangeChecksTableName < ActiveRecord::Migration[6.0]
  def change
    rename_table(:checks, :prizes)
  end
end
