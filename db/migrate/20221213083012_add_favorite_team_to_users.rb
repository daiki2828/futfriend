class AddFavoriteTeamToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :favorite_team, :string
  end
end
