class CreateTemplates < ActiveRecord::Migration[8.0]
  def change
    create_table :templates do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.text :body, null: false
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :templates, [ :user_id, :position ]
  end
end
