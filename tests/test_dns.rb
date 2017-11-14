class DNSTest

    def initialize(hosts, domain)
     @hosts = hosts
     @domain = domain
     @ip = nil
     @hostname = nil
     @interface = "en0"

     setup
    end

    def setup
      @ip = %x(ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
      @hostname = %x(hostname)
    end

    def run
      test_name_resolution
      test_reverse_dns
    end


    def test_name_resolution
      @hosts.each do |hostname, ip|
        next if @hostname.to_s == hostname.to_s
        host_ip = %x(host #{hostname.to_s}#{@domain})
        puts assert_equal(ip, host_ip)
      end
    end

    def test_reverse_dns
      @hosts.each do |hostname, ip|
        next if @hostname.to_s == hostname.to_s
        host_name = %x(dig +short -x #{ip})
        puts assert_equal(host_name, hostname)
      end
    end

    def assert_equal(a,b)
      return a == b
    end

end

test_dns = DNSTest.new(
  {"gw":"10.0.0.1", "server":"10.0.0.2", "client1": "10.0.0.3", "client2":"10.0.0.4"},
  ".51.sysinst.ida.liu.se"
)
test_dns.run


