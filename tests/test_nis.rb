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
    test_process_running
    test_server_ypwhich
    test_ypcat_passwd
  end

  def test_process_running
    return if @hostname == "gw"
  end

  def test_server_ypwhich
    return if @hostname == "gw"
  end

  def test_ypcat_passwd
    return if @hostname == "gw"
  end

end

test_nis = NISTest.new
test_nis.run

