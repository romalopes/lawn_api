class CreateLawns < ActiveRecord::Migration
  def change
    create_table :lawns do |t|
      t.integer :width
      t.integer :height
    end
  end
end
