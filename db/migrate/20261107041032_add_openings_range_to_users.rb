class AddOpeningsRangeToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :openings_range, :string, null: false, default: "month"
    add_column :users, :openings_from, :date
    add_column :users, :openings_to, :date
  end
end
