class NFSTest

  def initialize
    @hostname = %x(hostname).strip!
  end

  def run
    puts "All tests should respond with true"
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    test_is_empty_home if @hostname == "server"
    test_exports if @hostname == "server"
    test_automount_on_client if ["client-1", "client-2"].include? @hostname
    test_auto_dot_home if ["client-1", "client-2"].include? @hostname
  end

  def test_is_empty_home
    response = %x(ls -l /home/ | wc -l).to_i
    puts assert_equal(response, 1)
  end

  def test_exports
    response = %x(cat /etc/exports | grep home1).strip!.split
    puts assert_equal(response[0], "/home1")
    puts assert_equal(response[1].split('(')[0], "10.0.0.3")

    response = %x(cat /etc/exports | grep home2).strip!.split
    puts assert_equal(response[0], "/home2")
    puts assert_equal(response[1].split('(')[0], "10.0.0.4")

    response = %x(cat /etc/exports | grep local).strip!.split
    puts assert_equal(response[0], "/usr/local")
    puts assert_equal(response[1].split('(')[0], "10.0.0.3")

    puts assert_equal(response[2], "/usr/local")
    puts assert_equal(response[3].split('(')[0], "10.0.0.4")
  end


  def test_automount_on_client
    response = %x(df -h | grep local).split
    puts assert_equal(response[0], "10.0.0.2:/usr/local")
    puts assert_equal(response[-1], "/usr/local")
  end

  def test_auto_dot_home
    response = %x(cat /etc/auto.home | grep home).split
    puts assert_equal(response[0], "*")
    puts assert_equal(response[1].split(':')[0], "10.0.0.2")
    puts assert_equal(response[1].split(':')[1], "/home1/&") if @hostname == "client-1"
    puts assert_equal(response[1].split(':')[1], "/home2/&") if @hostname == "client-2"
  end

  def assert_equal(a,b)
    return a == b
  end

end

test_nfs = NFSTest.new
test_nfs.run
