class AddClientNameToAvailabilityBlocks < ActiveRecord::Migration[8.0]
  def change
    add_column :availability_blocks, :client_name, :string
  end
end
