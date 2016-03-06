class CreateLawns < ActiveRecord::Migration
  def change
    create_table :lawns do |t|
      t.integer :width
      t.integer :height

      t.timestamps null: false
    end
  end
end
