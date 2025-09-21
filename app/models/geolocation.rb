class Geolocation < ApplicationRecord
  IP_ADDRESS_REGEXP = /\A[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\z/

  validates :latitude, presence: true, numericality: { greater_than: -90, less_than_or_equal_to: 90 }
  validates :longitude, presence: true, numericality: { greater_than: -180, less_than_or_equal_to: 180 }
  validates :ipaddress, presence: true, format: { with: self::IP_ADDRESS_REGEXP }
end
