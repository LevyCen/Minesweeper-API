class CreateSquares < ActiveRecord::Migration[6.1]
  def change
    create_table :squares do |t|
      t.integer :row
      t.integer :column
      t.integer :value
      t.boolean :mine
      t.boolean :open
      t.references :board, null: false, foreign_key: true

      t.timestamps
    end
  end
end
