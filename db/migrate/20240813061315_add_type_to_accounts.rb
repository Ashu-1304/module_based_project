class AddTypeToAccounts < ActiveRecord::Migration[7.1]
  def change
    add_column :accounts, :type, :string
  end
end
