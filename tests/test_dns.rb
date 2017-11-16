class DNSTest

    def initialize(hosts, domain)
     @hosts = hosts
     @domain = domain
     @ip = nil
     @hostname = nil
     @interface = "eth0"

     setup
    end

    def setup
      @ip = %x(ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
      @hostname = %x(hostname)
    end

    def run
      puts "All tests should respond with TRUE"
      puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      test_name_resolution
      test_reverse_dns
      test_dig_hosts
      test_ping_hosts
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

    def test_dig_hosts
      @hosts.each do |key, value|
        puts %x(dig #{key}.51.sysinst.ida.liu.se).split.include?("sysinst.ida.liu.se.")
      end
    end

    def test_ping_hosts
      @hosts.each do |key, value|
        puts %x(dig #{value}.51.sysinst.ida.liu.se).split.include?("sysinst.ida.liu.se.")
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


