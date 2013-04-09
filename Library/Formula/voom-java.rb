require 'formula'

class VoomJava < Formula
  homepage 'https://github.com/jaklaassen/voom-java'
  url 'git@github.com:jaklaassen/voom-java.git', :using => GitDownloadStrategy
  version '0.0.2'
  depends_on "java7"

  def install
     prefix.install Dir['*']
     # TODO: We're manipulating the path here so protoc is on the path
     # We should really have protoc as a dependency.
     system "cd #{prefix} && PATH=$PATH:/usr/local/bin mvn install"
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test vert.x`.
    #system "false"
  end
end
