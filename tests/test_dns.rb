#test = %x( hostname )

#puts test


class DNSTest

    def initialize(hosts, domain)
     @hosts = hosts
     @domain = domain
     @ip = nil
    end

    def setup
      @ip = %x()
    end


    def run
      puts @hosts
    end



end

test_dns = DNSTest.new(
  {"gw":"10.0.0.1", "server":"10.0.0.2", "client1": "10.0.0.3", "client2":"10.0.0.4"},
  "51.sysinst.ida.liu.se"
)
test_dns.run


