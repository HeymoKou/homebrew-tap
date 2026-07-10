class Cbar < Formula
  desc "Native macOS menu-bar monitor for Claude account usage"
  homepage "https://github.com/HeymoKou/cbar"
  url "https://github.com/HeymoKou/cbar/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "56a2e1743aebc456892f56c35efd3528c92c731ce337c5a8406bfaa7e0b996fc"
  license "MIT"

  depends_on :macos

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"

    app = libexec/"Cbar.app"
    (app/"Contents/MacOS").mkpath
    cp ".build/release/Cbar", app/"Contents/MacOS/Cbar"
    (app/"Contents/Info.plist").write <<~PLIST
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>CFBundleName</key><string>Cbar</string>
        <key>CFBundleDisplayName</key><string>cbar</string>
        <key>CFBundleIdentifier</key><string>com.heymo.cbar</string>
        <key>CFBundleExecutable</key><string>Cbar</string>
        <key>CFBundlePackageType</key><string>APPL</string>
        <key>CFBundleShortVersionString</key><string>0.1.0</string>
        <key>CFBundleVersion</key><string>1</string>
        <key>LSUIElement</key><true/>
        <key>LSMinimumSystemVersion</key><string>14.0</string>
      </dict>
      </plist>
    PLIST
  end

  service do
    run [opt_libexec/"Cbar.app/Contents/MacOS/Cbar"]
    keep_alive true
    log_path var/"log/cbar.log"
    error_log_path var/"log/cbar.log"
  end

  test do
    system "swift", "--version"
  end
end
