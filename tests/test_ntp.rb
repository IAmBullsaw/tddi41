class NTPTests

  def initialize()
    @hostname = %x(hostname).strip!
    @expected_source = "*ida-gw" if @hostname == "gw"
    @expected_source = "*gw" if @hostname != "gw"
  end

  def run
    puts "All tests should respond with true"
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    test_running_server
    test_reach
  end

  def test_running_server
    result = %x(ntpq -p)
    source = result.split("\n")[-1].split[0].split('.')[0]
    puts assert_equal(source, @expected_source)
  end

  def test_reach
    result = %x(ntpq -p)
    puts assert_equal("377", result.strip.split[17])
  end

  def assert_equal(a,b)
    return a == b
  end

end

test_ntp = NTPTests.new
test_ntp.run
