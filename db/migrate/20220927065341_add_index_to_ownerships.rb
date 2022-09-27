class AddIndexToOwnerships < ActiveRecord::Migration[7.0]
  def change
    add_index :ownerships, %i[branch_id accountable_type client_id], unique: true, name: 'my_index'
    # add_index :ownerships, :branch_id , unique: true
    # add_index :ownerships, :client_id, unique: true
 
  end
end
