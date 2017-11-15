class NTPTests

  def initialize()
    @hostname = %x(hostname)
    @expected_source = "*ida-gw" if @hostname == "gw"
    @expected_source = "*gw" if @hostname == "gw"
  end

  def run
    result = %(ntpq -p)
    source = result.split("\n")[-1].split[0].split('.')[0]
    assert_equal(source, @expected_source)
  end

  def assert_equal(a,b)
    return a == b
  end

end

test_ntp = NTPTests.new
test_ntp.run
