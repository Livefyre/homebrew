require 'formula'

class VoomJava < Formula
  homepage 'https://github.com/jaklaassen/voom-java'
  url 'http://packages.livefyre.com/buildout/packages/amqp-busmod-1.2.0-SNAPSHOT-jar-with-dependencies.jar'
  version '1.2.0'
  sha1 'a57fba1cfc9a221d9c088467fe3223b42ff10a2c'
  depends_on "java7"
  depends_on "jython"

  def install
     prefix.install Dir['*']
     system "mvn install:install-file -Dfile=#{prefix}/amqp-busmod-1.2.0-SNAPSHOT-jar-with-dependencies.jar -DgroupId=com.livefyre -DartifactId=voom -Dversion=0.0.5 -Dpackaging=jar"
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test vert.x`.
    #system "false"
  end
end
