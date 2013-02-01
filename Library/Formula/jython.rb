require 'formula'

class Jython < Formula
  homepage 'http://www.jython.org'
  url "http://search.maven.org/remotecontent?filepath=org/python/jython-installer/2.5.3/jython-installer-2.5.3.jar"
  sha1 '6b6ac4354733b6d68d51acf2f3d5c823a10a4ce4'

  devel do
    url "http://downloads.sourceforge.net/project/jython/jython-dev/2.7.0a2/jython_installer-2.7a2.jar"
    sha1 'b4a0bd80800221d9a6b5462120c327e27b307544'
  end

  def install
    system "java", "-jar", "jython-installer-#{version}.jar", "-s", "-d", libexec
    bin.install_symlink libexec/'bin/jython'
    # setup a file for evaluating in your .profile
    rc_dir = (prefix + 'rc')
    (rc_dir + 'jython').write "export JYTHON_HOME=#{prefix}/libexec"
    share.install rc_dir
  end

  def caveats; <<-EOS.undent
    You should add to your .profile or .bashrc (if not already added):

        for f in /usr/local/share/rc/*; do source $f; done

    EOS
  end
end
