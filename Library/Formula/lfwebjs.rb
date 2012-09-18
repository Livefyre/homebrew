require 'formula'

class Lfwebjs < Formula
  homepage 'http://github.com/Livefyre/lfwebjs'
  #head 'git@github.com:Livefyre/lfdj.git'
  url 'https://raw.github.com/gist/7181e7f98f07ca234595/e81cb0a56c2e82cf88efe77dcb49ee4028193c5b/supervisord.conf'
  version 'dev'
  depends_on 'plovr'
  depends_on 'supervisord'
  depends_on 'lfpython'
  depends_on 'lfservices'

  def install
    system "npm", "install", "http-proxy"
    libexec.install "node_modules"

    (libexec + 'proxy.js').write proxy_js

    dir = (etc + 'supervisor/conf.d/lfwebjs')
    dir.mkpath
    (dir + 'proxy.conf').write proxy
    (dir + 'adv_proxy.conf').write adv_proxy
    (dir + 'plovr.conf').write plovr
    (dir + 'conv_asset_server.conf').write conv_asset_server
    (dir + 'conv_sample_server.conf').write conv_sample_server
    (dir + 'admin_asset_server.conf').write admin_asset_server
    (dir + 'group.conf').write program_group
  end

  def proxy_js
    return <<-EOS
var httpProxy = require('http-proxy');

httpProxy.createServer({
 hostnameOnly: false,
 router: {
   'widget.localhost': 'localhost:9111',
   'admin.localhost': 'localhost:9001',
   'admin.localhost/site_media': 'localhost:9101',
   'admin.localhost/admin': 'localhost:9101',
   'admin.localhost/wjs': 'localhost:9102'
 }
}).listen(80);
    EOS
  end

  def program_group
    return <<-EOS
[group:proxy]
programs=proxy
priority=500

[group:widget]
programs=plovr,conv_asset_server,conv_sample_server
priority=500

[group:admin]
programs=admin_asset_server
priority=500
    EOS
  end

  def proxy
    return <<-EOS
[program:proxy]
command = #{HOMEBREW_PREFIX}/bin/node proxy.js
process_name = proxy
directory = #{libexec}
priority = 500
autorestart = true
autostart = true
startsecs = 5
startretries = 10
environment = PATH="#{HOMEBREW_PREFIX}/share/npm/bin:$PATH"
    EOS
  end

  def adv_proxy
    return <<-EOS
[program:adv_proxy]
command = /usr/local/bin/node #{ENV['HOME']}/dev/lfdev/proxy/proxy.js
process_name = adv_proxy
directory = #{libexec}
priority = 500
autorestart = true
autostart = true
startsecs = 5
startretries = 10
environment = PATH="#{HOMEBREW_PREFIX}/share/npm/bin:$PATH"
    EOS
  end

  def plovr
    return <<-EOS
[program:plovr]
command = #{HOMEBREW_PREFIX}/bin/plovr serve --port 9111 #{ENV['HOME']}/dev/lfwebjs/lfconv/parts/plovr/plovr.dev.js
process_name = plovr
directory = #{var}
priority = 500
autorestart = true
autostart = true
startsecs = 5
startretries = 10
user = #{ENV['USER']}
    EOS
  end

  def conv_sample_server
    return <<-EOS
[program:conv_sample_server]
command = python -m SimpleHTTPServer 9113
process_name = conv_sample_server
directory = #{ENV['HOME']}/dev/lfwebjs/lfconv/samples
priority = 500
autorestart = true
autostart = true
startsecs = 5
startretries = 10
user = #{ENV['USER']}
    EOS
  end

  def conv_asset_server
    return <<-EOS
[program:conv_asset_server]
command = #{ENV['HOME']}/dev/lfwebjs/lfconv/bin/asset_server 9112
process_name = conv_asset_server
directory = #{var}
priority = 500
autorestart = true
autostart = true
startsecs = 5
startretries = 10
user = #{ENV['USER']}
    EOS
  end

  def admin_asset_server
    return <<-EOS
[program:admin_asset_server]
command = #{ENV['HOME']}/dev/lfwebjs/lfadmin/bin/asset_server 9101
process_name = admin_asset_server
directory = #{var}
priority = 500
autorestart = true
autostart = true
startsecs = 5
startretries = 10
user = #{ENV['USER']}
    EOS
  end

end
