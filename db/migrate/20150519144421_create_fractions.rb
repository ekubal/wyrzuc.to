class CreateFractions < ActiveRecord::Migration
  def change
    create_table :fractions do |t|
      t.string :name
      t.integer :waste_data_id

      t.timestamps
    end
  end
end
