class RenamePrefactureNameColumnToUsers < ActiveRecord::Migration[6.1]

  def change
    rename_column :users, :prefacture_name, :prefecture_code
  end
end
