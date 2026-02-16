class CreateAvailabilityBlocks < ActiveRecord::Migration[8.0]
  def change
    create_table :availability_blocks do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date, null: false
      t.integer :status, null: false, default: 0
      t.string :note

      t.timestamps
    end

    add_index :availability_blocks, [ :user_id, :date ], unique: true
  end
end
