# homebrew-tap

Homebrew tap for [cbar](https://github.com/HeymoKou/cbar).

```bash
brew install heymokou/tap/cbar
brew services start heymokou/tap/cbar   # run + start at login
```

macOS only. On Apple Silicon with macOS 15 or newer, brew pours a prebuilt
bottle; on older or Intel Macs it builds from source (needs the Swift toolchain —
`xcode-select --install`). Neither path needs Apple signing or notarization:
bottles are built in this repo's CI and are not quarantined by brew.

## Releasing a new cbar version

Bump `Formula/cbar.rb` (`url`, `sha256`) **in a pull request**, not on main:

1. `brew test-bot` (tests.yml) builds and tests the bottle on macos-15.
2. When it is green, auto-publish.yml dispatches `brew pr-pull` (publish.yml),
   which uploads the bottle to a GitHub Release, commits the `bottle do` block
   and pushes to main.

A bump pushed straight to main keeps the previous version's bottle block; the
push run of tests.yml fails on it so it gets noticed.
