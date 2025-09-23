require "resolv"

class GeolocationService
  class << self
    def lookup(ip)
      [37.330528259277344, -121.83822631835938]
    end

    def extract_host_from_url(url)
      URI.parse(url).host rescue nil
    end

    def resolve_hostname(hostname)
      Resolv.getaddresses(hostname).find{|ip|
        Resolv::IPv4::Regex.match ip
      }
    end
  end
end
