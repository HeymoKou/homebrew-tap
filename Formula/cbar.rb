class Cbar < Formula
  desc "Native macOS menu-bar monitor for Claude account usage"
  homepage "https://github.com/HeymoKou/cbar"
  url "https://github.com/HeymoKou/cbar/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "35cf3bbbe1947e3b5f1455404e18f9bfc1ab6c9b8f420f4b24a8d2f74c4935de"
  license "MIT"

  depends_on :macos

  def install
    # build.sh is the one place that builds the bundle and writes its version, so
    # the formula runs it rather than keeping a second copy of the plist here —
    # that copy is why brew shipped an app stamped 0.2.0 from a 0.2.5 tag.
    # --disable-sandbox because SwiftPM's sandbox cannot run inside Homebrew's.
    system "./build.sh", "--disable-sandbox"
    libexec.install "Cbar.app"
  end

  service do
    run [opt_libexec/"Cbar.app/Contents/MacOS/Cbar"]
    keep_alive true
    log_path var/"log/cbar.log"
    error_log_path var/"log/cbar.log"
  end

  test do
    plist = libexec/"Cbar.app/Contents/Info.plist"
    stamped = shell_output("/usr/libexec/PlistBuddy -c 'Print CFBundleShortVersionString' #{plist}").strip
    assert_equal version.to_s, stamped
  end
end
