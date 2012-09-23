require 'formula'

class Webdis < Formula
  homepage 'https://github.com/nicolasff/webdis'
  head 'https://github.com/nicolasff/webdis.git'

  depends_on 'libevent'

  def install
    ENV.j1
    system "make clean all"
    bin.install ['webdis']
    share.install ['webdis.json', 'webdis.prod.json']
    (bin/'run_webdis').write <<-EOS.undent
      #!/bin/bash
      #{bin}/webdis #{share}/webdis.json
    EOS
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test webdis`.
    system "false"
  end
end
