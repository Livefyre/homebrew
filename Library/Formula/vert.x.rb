require 'formula'

class VertX < Formula
  homepage 'http://vertx.io'
  url 'http://packages.livefyre.com/buildout/packages/vert.x-1.3.1.final.tar.gz'
  version '1.3.1'
  sha1 '7339d307a4fa4791e6bf4f70d9e13082'
  depends_on "java7"
  depends_on "jython"

  def install
    # Remove Windows files
    rm_f Dir["bin/*.bat"]    
    libexec.install Dir['lib/*.jar']
    prefix.install Dir['*']

    inreplace "#{bin}/vertx" do |s|
      # Replace CLASSPATH paths to use libexec instead of lib
      s.gsub! /\$\{APP_HOME\}\/lib\//, "\${APP_HOME}/libexec/"
    end
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test vert.x`.
    #system "false"
  end
end
