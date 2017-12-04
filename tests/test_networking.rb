class NetworkingTest
  def initialize(hostnames, addresses)
    @hostnames = hostnames
    @addresses = addresses
    @ip = %x(hostname --ip-address).strip!
    @hostname = %x(hostname).strip!
  end

  def run
    puts "All tests should respond with TRUE"
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    test_basic_networking
    test_hostname
    test_ip
    test_ping_on_ip
    test_ping_on_hostname
  end

  def test_basic_networking
    puts "-> test_basic_networking"
    @addresses.each do |addr|
      next if @ip.to_s == addr.to_s
      res = %x(ping -c 1 #{addr} >/dev/null && echo 'OK').strip!
      puts assert_equal("OK", res)
    end
  end

  def test_hostname
    puts "-> test_hostname"
    puts @hostnames.include? @hostname
  end

  def test_ip
    puts "-> test_ip"
    puts @addresses.include? @ip
  end

  def test_ping_on_ip
    puts "-> test_ping_on_ip"
    for addr in @addresses do
      puts assert_equal(%x(ping -c 1 #{addr} | grep "1 packets").split[5].to_i, 0)
    end
  end

  def test_ping_on_hostname
    puts "-> test_ping_on_hostname"
    for name in @hostnames do
      puts assert_equal(%x(ping -c 1 #{name} | grep "1 packets").split[5].to_i, 0)
    end
  end

  def assert_equal(a,b)
    return a == b
  end
end
test_networking = NetworkingTest.new(["gw", "server", "client-1", "client-2"], ["10.0.0.1", "10.0.0.2", "10.0.0.3", "10.0.0.4"])
test_networking.run
