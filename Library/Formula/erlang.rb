require 'formula'

# Major releases of erlang should typically start out as separate formula in
# Homebrew-versions, and only be merged to master when things like couchdb and
# elixir are compatible.
class Erlang < Formula
  homepage 'http://www.erlang.org'
  # Download tarball from GitHub; it is served faster than the official tarball.
  url 'https://github.com/erlang/otp/archive/OTP_R16B02.tar.gz'
  sha1 '81f72efe58a99ab1839eb6294935572137133717'

  head 'https://github.com/erlang/otp.git', :branch => 'master'

  bottle do
    sha1 'f2f17d7e0fcfc8281a5a49316db73382e2ed2b77' => :mountain_lion
    sha1 '8afbd3e03333ca368e5036f48d0bcddeb4a4c8dd' => :lion
    sha1 'bf967eecc1475e38aa0d5636ffb68563df627c5f' => :snow_leopard
  end

  option 'disable-hipe', "Disable building hipe; fails on various OS X systems"
  option 'halfword', 'Enable halfword emulator (64-bit builds only)'
  option 'time', '`brew test --time` to include a time-consuming test'
  option 'no-docs', 'Do not install documentation'

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool
  depends_on 'unixodbc' if MacOS.version >= :mavericks
  depends_on 'fop' => :optional # enables building PDF docs

  fails_with :llvm

  def install
    ohai "Compilation takes a long time; use `brew install -v erlang` to see progress" unless ARGV.verbose?

    ENV.append "FOP", "#{HOMEBREW_PREFIX}/bin/fop" if build.with? 'fop'

    # Do this if building from a checkout to generate configure
    system "./otp_build autoconf" if File.exist? "otp_build"

    args = %W[
      --disable-debug
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-kernel-poll
      --enable-threads
      --enable-dynamic-ssl-lib
      --enable-shared-zlib
      --enable-smp-support
    ]

    args << "--with-dynamic-trace=dtrace" unless MacOS.version <= :leopard or not MacOS::CLT.installed?

    unless build.include? 'disable-hipe'
      # HIPE doesn't strike me as that reliable on OS X
      # http://syntatic.wordpress.com/2008/06/12/macports-erlang-bus-error-due-to-mac-os-x-1053-update/
      # http://www.erlang.org/pipermail/erlang-patches/2008-September/000293.html
      args << '--enable-hipe'
    end

    if MacOS.prefer_64_bit?
      args << "--enable-darwin-64bit"
      args << "--enable-halfword-emulator" if build.include? 'halfword' # Does not work with HIPE yet. Added for testing only
    end

    system "./configure", *args

    if ENV.compiler == :clang
      # Superenv does not pass -march=native during configure, causing
      # misdetection of this capability on some architectures:
      # https://github.com/mxcl/homebrew/issues/23754
      inreplace Dir['erts/*/config.h'].first, /^#define ETHR_HAVE___SYNC_VAL_COMPARE_AND_SWAP128 1$/, ''
    end

    system "make"
    ENV.j1 # Install is not thread-safe; can try to create folder twice and fail
    system "make install"

  end

  def caveats; <<-EOS.undent
    Man pages can be found in:
      #{opt_prefix}/lib/erlang/man

    Access them with `erl -man`, or add this directory to MANPATH.
    EOS
  end

  def test
    `#{bin}/erl -noshell -eval 'crypto:start().' -s init stop`

    # This test takes some time to run, but per bug #120 should finish in
    # "less than 20 minutes". It takes about 20 seconds on a Mac Pro (2009).
    if build.include?("time") && !build.head?
      `#{bin}/dialyzer --build_plt -r #{lib}/erlang/lib/kernel-2.16.3/ebin/`
    end
  end
end
