require 'formula'

class Lfstream < Formula
  homepage 'http://github.com/Livefyre/perseids'
  #head 'git@github.com:Livefyre/lfdj.git'
  url 'https://raw.github.com/gist/7181e7f98f07ca234595/e81cb0a56c2e82cf88efe77dcb49ee4028193c5b/supervisord.conf'
  version 'dev'
  depends_on 'supervisord'
  depends_on 'lfpython'
  depends_on 'lfservices'
  depends_on 'maven'
  depends_on 'java7'

  def install
    dir = (etc + 'supervisor/conf.d/lfstream')
    dir.mkpath
    (dir + 'servers.conf').write servers
    (dir + 'group.conf').write program_group
  end

  def program_group
    return <<-EOS
[group:stream]
programs=ct,mq2,mq
priority=500
    EOS
  end

  def servers
    return <<-EOS
[program:ct]
command = #{ENV['USER']}/dev/perseids/bin/runserver.sh
redirect_stderr=True
process_name = ct
directory = #{ENV['USER']}/dev/perseids
priority = 999
autorestart = false
autostart = false
stopsignal = KILL
killasgroup = true
user = #{ENV['USER']}

[program:mq2]
command = #{ENV['USER']}/dev/lfdj/lfbootstrap/bin/django run_mqueue_v2 --workers=1 --reqlimit=100000 --disable-wal
redirect_stderr=True
process_name = mq2
directory = #{ENV['USER']}/dev/lfdj/lfbootstrap
priority = 999
autorestart = false
autostart = false
stopsignal = KILL
killasgroup = true
user = nino

[program:mq]
command = #{ENV['USER']}/dev/lfdj/lfbootstrap/bin/django run_mqueue --workers=1 --reqlimit=100000 --disable-wal
redirect_stderr=True
process_name = mq
directory = #{ENV['USER']}/dev/lfdj/lfbootstrap
priority = 999
autorestart = false
autostart = false
stopsignal = KILL
killasgroup = true
user = nino
    EOS
  end
end
