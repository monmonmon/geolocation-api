class CreateGeolocations < ActiveRecord::Migration[8.0]
  def change
    create_table :geolocations do |t|
      t.decimal :latitude, null: false, precision: 9, scale: 6
      t.decimal :longitude, null: false, precision: 9, scale: 6
      t.string :ipaddress, null: false
      t.string :url_fqdn

      t.index :ipaddress, unique: true

      t.timestamps
    end
  end
end
