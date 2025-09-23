require "resolv"

class GeolocationService
  class << self
    def ip_to_geolocation(ip)
      response = Faraday.get("https://api.ipstack.com/#{ip}", {
        access_key: ENV["IPSTACK_ACCESS_KEY"],
        format: 1,
      })
      data = JSON.parse(response.body)
      [data["latitude"], data["longitude"]]
    end

    def extract_host_from_url(url)
      URI.parse(url).host rescue nil
    end

    def resolve_hostname(hostname)
      Resolv.getaddresses(hostname).find { |ip|
        Resolv::IPv4::Regex.match ip
      }
    end
  end
end
