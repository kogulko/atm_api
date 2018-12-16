class CreateBanknotes < ActiveRecord::Migration[5.2]
  def change
    create_table :banknotes do |t|
      t.column :face_value, :integer, index: { unique: true }
      t.integer :quantity, default: 0

      t.timestamps
    end
  end
end
