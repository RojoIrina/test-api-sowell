class CreateLocationTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :location_types do |t|
      t.string :name
      t.integer :depth_level
      t.references :base_location_type, null: false, foreign_key: true

      t.timestamps
    end
    add_index :location_types, :name
  end
end
