class NetworkingTest

  def initialize(hostnames, addresses)
    @hostnames = hostnames
    @addresses = addresses
    @ip = %x(hostname --ip-address)
    @hostname = %x(hostname)
  end

  def run
    test_basic_networking
    test_hostname
  end

  def test_basic_networking
    addresses.each do |addr|
      next if @ip.to_s == addr.to_s
      res = %x(ping -c 1 #{addr} >/dev/null && echo 'OK')
      assert_equal("OK", res)
    end
  end


  def test_hostname
    @hostnames.include? @hostname
  end


  def assert_equal(a,b)
    return a == b
  end

end

test_networking = NetworkingTest.new(["gw", "server", "client-1", "client-2"], ["10.0.0.1", "10.0.0.2", "10.0.0.3", "10.0.0.4"])
test_networking.run
