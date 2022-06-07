class CreateFields < ActiveRecord::Migration[7.0]
  def change
    create_table :fields do |t|
      t.references :addon, null: false, foreign_key: true
      t.string :key
      t.string :name
      t.string :data_type
      t.integer :position

      t.timestamps
    end
  end
end
