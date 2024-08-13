class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.string :place_name
      t.string :longitude
      t.string :latitude
      t.string :state

      t.timestamps
    end
  end
end
