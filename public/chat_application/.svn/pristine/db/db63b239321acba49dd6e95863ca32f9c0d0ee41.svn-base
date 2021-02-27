class CreateRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :roles do |t|
   		t.string :role_name

      t.timestamps
    end
      	add_column :admins, :role_id, :string
      	add_column :users, :role_id, :string
  end
end
