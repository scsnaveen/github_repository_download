class AddColsToVersions < ActiveRecord::Migration[6.0]
  def change
  	add_column :admins, :track_changes, :json, array:true, default: []
  end
end
