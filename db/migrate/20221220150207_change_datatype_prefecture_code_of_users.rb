class ChangeDatatypePrefectureCodeOfUsers < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :prefecture_code, :integer
  end
end
