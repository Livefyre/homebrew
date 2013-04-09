require 'formula'

class VertXBusmodAmqp < Formula
  homepage 'https://github.com/jaklaassen/voom-java'
  url 'git@github.com:jaklaassen/vert.x-busmod-amqp.git', :using => GitDownloadStrategy
  version '1.2.0'
  depends_on "vert.x"
  depends_on "voom-java"

  def install
     prefix.install Dir['*']
     system "cd #{prefix} && mvn install"
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test vert.x`.
    #system "false"
  end
end
