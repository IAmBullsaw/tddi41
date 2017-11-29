class NISTest
  def initialize()
    @hostname = %x(hostname)
    if @hostname == "server"
      @expected_process = "ypserv"
      @expected_ypwhich = "localhost"
    else
      @expected_process = "ypbind"
      @expected_ypwhich = "server.51.sysinst.ida.liu.se"
    end
  end

  def run
    puts "All tests should respond with true"
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"    
    puts test_process_running.nil?  # if its nil the process is running as a daemon
    puts test_server_ypwhich
    puts test_ypcat_passwd
  end

  def test_process_running
    return if @hostname == "gw"
    proc_list = %x(ps aux)
    proc_list.split("\n").each do |attributes|
      unless attributes.split[6] == "?"
        next  # unless its a daemon
      else
        return if attributes.split[10].end_with?(@expected_process)
      end
    end
    return false
  end

  def test_server_ypwhich
    return if @hostname == "gw"
    sys_call = %x(ypwhich)
    assert_equal(sys_call, @expected_ypwhich)
  end

  def test_ypcat_passwd
    return if @hostname == "gw"
    sys_call = %x(ypcat passwd.byuid).strip.split[0].start_with?("testuser")
  end


  def assert_equal(a, b)
    a == b
  end

end

test_nis = NISTest.new
test_nis.run

