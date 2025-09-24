
def define_stab_for_api_access
  # define a stub to bypass api access and circumvent the rate limit
  @ipstack_response_json_body = '{"ip":"23.192.228.80","type":"ipv4","continent_code":"NA","continent_name":"NorthAmerica","country_code":"US","country_name":"UnitedStates","region_code":"CA","region_name":"California","city":"SanJose","zip":"95122","latitude":37.330528259277344,"longitude":-121.83822631835938,"msa":"41940","dma":"807","radius":"0","ip_routing_type":"fixed","connection_type":"tx","location":{"geoname_id":5392171,"capital":"WashingtonD.C.","languages":[{"code":"en","name":"English","native":"English"}],"country_flag":"https://assets.ipstack.com/flags/us.svg","country_flag_emoji":"🇺🇸  ","country_flag_emoji_unicode":"U+1F1FAU+1F1F8","calling_code":"1","is_eu":false}}'
  resp_double = instance_double("Faraday::Response")
  allow(Faraday).to receive(:get)
    .and_return(resp_double)
  allow(resp_double).to receive(:body)
    .and_return(@ipstack_response_json_body)
end
