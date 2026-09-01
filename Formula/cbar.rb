class Cbar < Formula
  desc "Native macOS menu-bar monitor for Claude account usage"
  homepage "https://github.com/HeymoKou/cbar"
  url "https://github.com/HeymoKou/cbar/archive/refs/tags/v0.2.9.tar.gz"
  sha256 "6a9723df0bd4da18bd8271b8dbfdbc4075b1228740e661649d1eff38099e097c"
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
