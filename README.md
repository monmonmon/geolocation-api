# README

```
# register records by ip addresses
$ curl 'localhost:3000/geolocations/ip' -d ip=1.1.1.1
{"latitude":"39.641369","longitude":"-104.95459","ipaddress":"1.1.1.1","url_fqdn":null}
$ curl 'localhost:3000/geolocations/ip' -d ip=1.1.1.999
{"error":"Failed"}
$ curl 'localhost:3000/geolocations/ip' -d ip=x
{"error":"Failed"}

# register records by urls
$ curl 'localhost:3000/geolocations/url' -d url=https://example.com
{"latitude":"39.043701","longitude":"-77.474197","ipaddress":"23.215.0.136","url_fqdn":"example.com"}
$ curl 'localhost:3000/geolocations/url' -d url=example.com
{"error":"Failed"}
$ curl 'localhost:3000/geolocations/url' -d url=x
{"error":"Failed"}

# lookup by ip addresses
$ curl 'localhost:3000/geolocations/ip/1.1.1.1'
{"latitude":"39.641369","longitude":"-104.95459","ipaddress":"1.1.1.1","url_fqdn":null}
$ curl 'localhost:3000/geolocations/ip/1.1.1.255'
{"error":"Not found"}
$ curl 'localhost:3000/geolocations/ip/1.1.1.999'
{"error":"invalid IP address: 1.1.1.999"}
$ curl 'localhost:3000/geolocations/ip/x'
{"error":"invalid IP address: x"}

# lookup by urls
$ curl 'localhost:3000/geolocations/url/https%3A%2F%2Fexample%2Ecom'
{"latitude":"-89.215041","longitude":"-154.909556","ipaddress":"1.2.3.4","url_fqdn":"example.com"}
$ curl 'localhost:3000/geolocations/url/https%3A%2F%2Fexample%2Enosuchdomain'
{"error":"Not found"}
$ curl 'localhost:3000/geolocations/url/xx'
{"error":"invalid URL: xx"}

# delete by ip addresses
$ curl 'localhost:3000/geolocations/ip/1.1.1.1' -XDELETE # 204 No Content
$ curl 'localhost:3000/geolocations/ip/1.1.1.255' -XDELETE
{"error":"Not found"}
$ curl 'localhost:3000/geolocations/ip/1.1.1.999' -XDELETE
{"error":"invalid IP address: 1.1.1.999"}

# delete by urls
$ curl 'localhost:3000/geolocations/url/https%3A%2F%2Fexample%2Ecom' -XDELETE # 204 No Content
$ curl 'localhost:3000/geolocations/url/https%3A%2F%2Fexample%2Enosuchdomain' -XDELETE
{"error":"Not found"}
$ curl 'localhost:3000/geolocations/url/xx' -XDELETE
{"error":"invalid URL: xx"}
```
