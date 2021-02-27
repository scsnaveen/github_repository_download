class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.string 	:name
      t.integer :folder
      t.integer :sub_folder
      t.string 	:url
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
