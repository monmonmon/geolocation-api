require "resolv"

class GeolocationService
  class << self
    def ip_to_geolocation(ip)
      raise "Invalid IP address" unless Resolv::IPv4::Regex.match ip
      response = Faraday.get("https://api.ipstack.com/#{ip}", {
        access_key: ENV["IPSTACK_ACCESS_KEY"],
        format: 1,
      })
      data = JSON.parse(response.body)
      raise data["error"]["info"] if data["error"]
      raise "Failed to get the geolocation" if data["latitude"].blank? or data["longitude"].blank?
      [data["latitude"], data["longitude"]]
    end

    def extract_host_from_url(url)
      raise "Invalid URL" unless URI.regexp.match url
      URI.parse(url).host rescue nil
    end

    def resolve_hostname(hostname)
      Resolv.getaddresses(hostname).find { |ip|
        Resolv::IPv4::Regex.match ip
      }
    end
  end
end
