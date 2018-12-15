class CreateBanknotes < ActiveRecord::Migration[5.2]
  def change
    create_table :banknotes do |t|
      t.integer :face_value
      t.integer :quantity

      t.timestamps
    end
  end
end
