FactoryBot.define do
  factory :geolocation do
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    ipaddress { Faker::Internet.public_ip_v4_address }
    url_fqdn { Faker::Internet.domain_name }
  end
end
