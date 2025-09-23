require "resolv"

class Geolocation < ApplicationRecord
  validates :latitude, presence: true, numericality: { greater_than: -90, less_than_or_equal_to: 90 }
  validates :longitude, presence: true, numericality: { greater_than: -180, less_than_or_equal_to: 180 }
  validates :ipaddress, presence: true, format: { with: Resolv::IPv4::Regex }

  class << self
    def find_by_url!(url)
      host = GeolocationService.extract_host_from_url(url)
      host ? self.find_by!(url_fqdn: host) : nil
    end

    def build_by_ipaddress(ip)
      latitude, longitude = GeolocationService.ip_to_geolocation(ip)
      build(
        latitude: latitude,
        longitude: longitude,
        ipaddress: ip,
      )
    end

    def build_by_url(url)
      host = GeolocationService.extract_host_from_url(url)
      raise "Failed to extract host" unless host
      ip = GeolocationService.resolve_hostname(host)
      raise "Failed to resolve: #{host}" unless ip
      geo = build_by_ipaddress(ip)
      geo.url_fqdn = host
      geo
    end
  end
end
