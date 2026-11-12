class Cbar < Formula
  desc "Native macOS menu-bar monitor for Claude, Codex, Grok, and Antigravity usage"
  homepage "https://github.com/HeymoKou/cbar"
  url "https://github.com/HeymoKou/cbar/archive/refs/tags/v0.2.23.tar.gz"
  sha256 "0f6d48aec72c9ce678a10a50095ae2b97acb1875f6efc7b577bb9ebd4a0d4bda"
  license "MIT"

  bottle do
    root_url "https://github.com/HeymoKou/homebrew-tap/releases/download/cbar-0.2.22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f33d572eaa57122974d1b1c8fa484c363103b00d1e4a3457d4af3cb99328651"
  end

  depends_on :macos

  # Bottles are built by .github/workflows/tests.yml on macos-15 and published by
  # publish.yml. Macs without a matching bottle (older macOS, Intel) build from source.
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
