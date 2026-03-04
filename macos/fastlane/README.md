fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```text
For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## Mac

### mac screenshots

```sh
[bundle exec] fastlane mac screenshots
```text
Capture Mac App Store screenshots via integration test

### mac upload_screenshots

```sh
[bundle exec] fastlane mac upload_screenshots
```text
Upload screenshots to Mac App Store Connect

### mac capture_and_upload

```sh
[bundle exec] fastlane mac capture_and_upload
```text
Capture screenshots and upload to App Store Connect

### mac build

```sh
[bundle exec] fastlane mac build
```text
Build the macOS app for Mac App Store distribution

### mac beta

```sh
[bundle exec] fastlane mac beta
```text
Build and upload to TestFlight for beta testing

### mac release

```sh
[bundle exec] fastlane mac release
```text
Build and upload to Mac App Store

### mac full_release

```sh
[bundle exec] fastlane mac full_release
```text
Full release: capture screenshots, upload everything, and submit build

### mac clean_screenshots

```sh
[bundle exec] fastlane mac clean_screenshots
```text
Clean up screenshot directories

### mac clean

```sh
[bundle exec] fastlane mac clean
```text
Clean build artifacts

### mac lanes_help

```sh
[bundle exec] fastlane mac lanes_help
```

Show all available lanes

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
