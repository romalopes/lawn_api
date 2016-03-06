class CreateMowers < ActiveRecord::Migration
  def change
    create_table :mowers do |t|
      t.integer :x
      t.integer :y
      t.string :headings
      t.string :commands
      t.references :lawn, index: true

      t.timestamps null: false
    end
  end
end
