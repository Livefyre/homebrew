require 'formula'

class Lfstream < Formula
  homepage 'http://github.com/Livefyre/perseids'
  url 'http://packages.livefyre.com/buildout/packages/osx/perseids-1.0.0-Alpha1.zip'
  version '1.0.0-Alpha1'
  depends_on 'supervisord'
  depends_on 'lfpython'
  depends_on 'lfservices'

  def install
    dir = (prefix + 'sconf.lfstream')
    dir.mkpath
    libexec.install Dir["*.jar", "*.xml"]
    share.install dir
    (bin + 'runserver').write <<-EOS.undent
      #!/bin/bash
      dev_root=#{ENV['HOME']}/dev/perseids
      dev_script=bin/runserver.sh
      if [ -e "$dev_root/$dev_script" ]; then
         echo "Using development version"
         cd $dev_root
         exec $dev_script
         exit 0
      fi
      echo "Using packaged jar"
      exec java -server \
        -XX:+UseBiasedLocking -XX:+AggressiveOpts -XX:+UseFastAccessorMethods -XX:+HeapDumpOnOutOfMemoryError \
        -Dperseids.returnAddr=redis://127.0.0.1:6378/0 \
        -Dperseids.redisQueueHost=redis://127.0.0.1:6379/0 \
        -Dperseids.redisLivecountHost=redis://127.0.0.1:6379/0 \
        -Dperseids.numWorkers=1 \
        -Dperseids.statsdAddr=statsd://107.23.16.37:8125 \
        -Dperseids.statsdPrefix=`hostname | sed -e 's/\./-/'` \
        -Dlogback.configurationFile=#{libexec}/logback.xml \
        -cp #{libexec}/perseids-#{version}-jar-with-dependencies.jar \
         com.livefyre.perseids.server.Run
    EOS
  end
end
