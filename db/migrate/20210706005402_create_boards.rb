class CreateBoards < ActiveRecord::Migration[6.1]
  def change
    create_table :boards do |t|
      t.string :name
      t.integer :height
      t.integer :width
      t.boolean :enabled
      t.integer :mines
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
