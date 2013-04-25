require 'formula'

class Lfdj < Formula
  homepage 'http://github.com/Livefyre/lfdj'
  #head 'git@github.com:Livefyre/lfdj.git'
  url 'https://raw.github.com/gist/7181e7f98f07ca234595/e81cb0a56c2e82cf88efe77dcb49ee4028193c5b/supervisord.conf'
  version '1.0'
  depends_on 'libevent'
  depends_on 'lfpython'
  depends_on 'lfservices'

  def install
    prefix.mkpath
    (var + 'log/lfdj').mkpath
  end
end
