class CreateBaseLocationTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :location_types do |t|
      t.string :name, null: false, default: ''
      t.integer :depth_level, null: false, default: 1, limit: 1
      t.references :base_location_type, foreign_key: true, null: false

      t.timestamps
    end

    add_index :location_types, :name, unique: true
  end
end