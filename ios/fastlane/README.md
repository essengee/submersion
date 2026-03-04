fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```text
For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios screenshots

```sh
[bundle exec] fastlane ios screenshots
```text
Capture App Store screenshots on iPhone and iPad simulators

### ios upload_screenshots

```sh
[bundle exec] fastlane ios upload_screenshots
```text
Upload screenshots to App Store Connect

### ios capture_and_upload

```sh
[bundle exec] fastlane ios capture_and_upload
```text
Capture screenshots and upload to App Store Connect

### ios build

```sh
[bundle exec] fastlane ios build
```text
Build the iOS app for App Store distribution

### ios beta

```sh
[bundle exec] fastlane ios beta
```text
Build and upload to TestFlight for beta testing

### ios release

```sh
[bundle exec] fastlane ios release
```text
Build and upload to App Store for production release

### ios full_release

```sh
[bundle exec] fastlane ios full_release
```text
Full release: capture screenshots, upload everything, and submit build

### ios clean_screenshots

```sh
[bundle exec] fastlane ios clean_screenshots
```text
Clean up screenshot directories

### ios list_simulators

```sh
[bundle exec] fastlane ios list_simulators
```text
List available simulators for screenshots

### ios clean

```sh
[bundle exec] fastlane ios clean
```text
Clean build artifacts

### ios lanes_help

```sh
[bundle exec] fastlane ios lanes_help
```

Show all available lanes

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
