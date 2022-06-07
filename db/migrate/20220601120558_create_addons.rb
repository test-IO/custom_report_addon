class CreateAddons < ActiveRecord::Migration[7.0]
  def change
    create_table :addons do |t|
      t.string :key, null: false
      t.string :title, null: false
      t.string :description
      t.string :status
      t.string :client_key
      t.string :shared_secret_key

      t.timestamps
    end
  end
end
