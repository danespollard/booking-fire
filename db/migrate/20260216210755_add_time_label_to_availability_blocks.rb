class AddTimeLabelToAvailabilityBlocks < ActiveRecord::Migration[8.0]
  def change
    add_column :availability_blocks, :time_label, :integer, default: 0, null: false
  end
end
