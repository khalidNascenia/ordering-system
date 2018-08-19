class AddUserRefernceToOrder < ActiveRecord::Migration[5.2]
  def up
    add_reference :orders, :user, index: true
  end

  def down 
    remove_reference :orders, :user, index: true
  end
end
