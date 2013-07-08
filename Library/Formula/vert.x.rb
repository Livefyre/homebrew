require 'formula'

class VertX < Formula
  homepage 'http://vertx.io'
  url 'https://github.com/Livefyre/vert.x.git', :branch => 'voom3.1'
  version '1.3.1'
  depends_on "java7"
  depends_on "jython"
  depends_on "gradle"
  depends_on "voom-java"

  def install
    system "./mk install dist"
    # Remove Windows files
    rm_f Dir["build/vert.x-1.3.1.final/bin/*.bat"]    
    libexec.install Dir['build/vert.x-1.3.1.final/lib/*.jar']
    prefix.install Dir['build/vert.x-1.3.1.final/*']

    #inreplace "#{bin}/vertx" do |s|
    #  Replace CLASSPATH paths to use libexec instead of lib
    #  s.gsub! /\$\{APP_HOME\}\/lib\//, "\${APP_HOME}/libexec/"
    #end
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test vert.x`.
    #system "false"
  end
end
