class AddTrackChangesToTables < ActiveRecord::Migration[6.0]
  def change
  	add_column :users, :track_changes, :json, array:true, default: []
  	add_column :roles, :track_changes, :json, array:true, default: []
  	add_column :conversations, :track_changes, :json, array:true, default: []
  	add_column :friendships, :track_changes, :json, array:true, default: []
  	add_column :posts, :track_changes, :json, array:true, default: []
  	add_column :messages, :track_changes, :json, array:true, default: []

  end
end
