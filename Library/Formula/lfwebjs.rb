require 'formula'

class Lfwebjs < Formula
  homepage 'http://github.com/Livefyre/lfwebjs'
  #head 'git@github.com:Livefyre/lfdj.git'
  url 'https://raw.github.com/gist/7181e7f98f07ca234595/e81cb0a56c2e82cf88efe77dcb49ee4028193c5b/supervisord.conf'
  version '1.0'
  depends_on 'plovr'
  depends_on 'supervisord'
  depends_on 'lfpython'
  depends_on 'lfservices'

  def install
    # Nothing to do -- the lfwebjs repo installs its supervisors personally
  end
end
