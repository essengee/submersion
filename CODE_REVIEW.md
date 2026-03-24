# Code Review — PR #43: Cressi Leonardo Serial-over-USB Support

Source: https://github.com/submersion-app/submersion/pull/43

## Copilot Review

### C1. Await `expectLater` in stream assertion test

**File:** `packages/libdivecomputer_plugin/test/serial_transport_test.dart` (lines 85–87)

`expectLater(service.downloadEvents, emits(...))` returns a Future that must be awaited, otherwise the test can complete before the stream assertion runs — leading to flaky results or missed failures. Capture the future, fire the event, then await it:

```dart
final expectation =
    expectLater(service.downloadEvents, emits(isA<DownloadErrorEvent>()));
service.onError(error);
await expectation;
```

### C2. Windows auto-detect stops at first openable COM port

**File:** `packages/libdivecomputer_plugin/windows/dive_computer_host_api_impl.cc`

The auto-detect path breaks on the first serial port that can be opened, but many COM ports open successfully even when they aren't the target dive computer. This can cause downloads to fail or hang without trying other ports. Instead, attempt the actual libdivecomputer connection per port (closing between attempts) and only commit to a port after the device is recognized.

### C3. Linux auto-detect has the same first-openable-port problem

**File:** `packages/libdivecomputer_plugin/linux/dive_computer_host_api_impl.cc` (lines 236–253)

Same issue as C2 — the manual-selection auto-detect opens the first `/dev/tty*` path that succeeds and proceeds to `libdc_download_run`. Many serial devices are openable but aren't the selected dive computer. Retry by attempting the libdivecomputer open/download per candidate port, closing the stream between attempts.

## Maintainer Review (@ericgriffin)

### M1. Blind port probing is risky

The auto-probe logic tries every available serial port until one connects. This could send unintended handshake bytes to unrelated serial devices (GPS modules, Arduinos, etc.), interfere with devices held open by other applications, or be slow when many ports exist.

Safer approach: filter candidates to known patterns — only probe `/dev/ttyUSB*` and `/dev/ttyACM*` on Linux, or filter by VID/PID on Windows. At minimum, consider letting the user confirm before probing multiple ports.

### M2. Windows COM port detection is too loose

```cpp
bool is_com_port = (address.size() >= 4 &&
    (address[0] == 'C' || address[0] == 'c') &&
    (address[1] == 'O' || address[1] == 'o') &&
    (address[2] == 'M' || address[2] == 'm'));
```

This matches strings like `"COMBO_device"` or `"COMMAND"`. Should also verify a digit follows:

```cpp
bool is_com_port = (address.size() >= 4 &&
    _strnicmp(address.c_str(), "COM", 3) == 0 &&
    address[3] >= '0' && address[3] <= '9');
```

### M3. macOS has no auto-probe path — intentional?

Linux and Windows both have enumerate-and-try logic for manual model selection, but macOS doesn't. If macOS serial connections go through a different mechanism (Swift layer?), a comment explaining why would help future readers.

### M4. No logging on probe failures

When auto-probe tries a port and fails, it silently moves to the next. Add debug-level logging for field debugging:

```c
// Linux
if (serial_io_stream_open(ctx->serial_stream, ports[i])) {
    opened = TRUE;
    break;
} else {
    g_debug("Auto-probe: failed to open %s, trying next port", ports[i]);
}

// Windows
if (serial_stream_->Open(port)) {
    io_callbacks = serial_stream_->MakeCallbacks();
    connected = true;
    break;
} else {
    OutputDebugStringA(("Auto-probe: failed to open " + port + "\n").c_str());
}
```

### M5. `python_script_runner.dart` diff is a full file rewrite

The diff shows -108/+111 but the actual semantic change is ~3 lines (the `Platform.isWindows` check). This is likely a line-ending reformatting (CRLF vs LF). Configure editor to use LF for `.dart` files, or recommit just the meaningful change to keep the diff reviewable. Verify with:

```bash
git diff --check feature/cressi-leonardo-import -- test/helpers/python_script_runner.dart
```

## Follow-up Review (post-fix commits fd75ab40..b75fcd42)

All five Copilot items (C1–C3) and all five maintainer items (M1–M5) were addressed. The fixes are generally solid, but the following issues remained or were introduced by the fix commits. All have been resolved in commits fe5d50ff..811553da.

### F1. ~~`on_download_progress` and `on_dive_downloaded` still called from download thread (Linux) — thread-safety bug~~ ✅ Fixed

**File:** `packages/libdivecomputer_plugin/linux/dive_computer_host_api_impl.cc`
**Fix:** fe5d50ff — Wrapped both callbacks with `g_idle_add` using the same pattern as `send_error_from_thread`.

The fix commits correctly moved error dispatch and completion dispatch to the main thread via `g_idle_add`. However, `on_download_progress` and `on_dive_downloaded` were still calling Flutter API methods directly from the download thread. These invoke Pigeon-generated GObject methods that push data into the Dart engine — which is not thread-safe. During multi-port probing this was especially risky.

### F2. ~~`python_script_runner.dart` still has CRLF line endings — M5 not actually fixed~~ ✅ Fixed

**File:** `test/helpers/python_script_runner.dart`
**Fix:** 6f87bcb3 — Converted to LF line endings.

Commit 756e7952 intended to fix M5 but the file still had CRLF line endings. `git diff --check` flagged every line as trailing whitespace.

### F3. ~~Phantom dives from failed port attempts leak to Flutter (Linux & Windows)~~ ✅ Fixed

**Files:** `linux/dive_computer_host_api_impl.cc`, `windows/dive_computer_host_api_impl.cc`
**Fix:** 0f9f7055 — Buffer dives per probe attempt; flush on success, discard on failure.

When the probe loop tried a wrong port, `libdc_download_run` could partially succeed — some devices respond to the initial handshake before the protocol diverges. The `on_dive` callback fired for each parsed dive, sending it to Flutter immediately. If the download then failed and the loop moved to the next port, those phantom dives had already been dispatched.

### F4. ~~Windows: `SetupDiGetDeviceRegistryPropertyA` failure silently includes non-USB ports~~ ✅ Fixed

**File:** `packages/libdivecomputer_plugin/windows/serial_scanner.cc`
**Fix:** 2c8a4839 — Changed to fail-closed: skip ports when hardware ID cannot be read.

If `SetupDiGetDeviceRegistryPropertyA` failed, the hardware ID check was skipped and the port was included in the probe list. This undermined the USB-only filtering from M1.

### F5. ~~Non-English ARB files have no `@` metadata for `serialConnectFailedWithDetails`~~ ✅ Fixed

**Files:** All 9 non-English ARB files
**Fix:** 6a485bbf — Added `@` metadata blocks with placeholder definitions.

The English ARB file had the metadata block but the other 9 locale files did not. While not a runtime bug (Flutter reads metadata from the template only), this prevented independent validation.

### F6. ~~`download_step_widget.dart` error localization matches on English substring~~ ✅ Fixed

**File:** `lib/features/dive_computer/presentation/widgets/download_step_widget.dart`
**Fix:** e205befe — Introduced dedicated `no_serial_ports` error code; Dart matches on `errorCode` instead of message text.

The `_localizedError` method was checking `state.errorMessage!.contains('No USB serial ports')` — fragile coupling to the native message wording. Now uses a structured error code on both Linux and Windows.

### F7. ~~Session reuse across probe attempts is safe but undocumented~~ ✅ Fixed

**Files:** `linux/dive_computer_host_api_impl.cc`, `windows/dive_computer_host_api_impl.cc`
**Fix:** c8b2fd53 — Added comments at session creation sites.

Both platforms reuse a single `libdc_download_session_t` across multiple `libdc_download_run` calls. This is safe but non-obvious. Comments now explain the design decision.

### F8. ~~Native C test uses `strncasecmp` — won't compile on Windows~~ ✅ Fixed

**File:** `packages/libdivecomputer_plugin/test/native/test_serial_callbacks.c`
**Fix:** 811553da — Added `#ifdef _WIN32` guard mapping `strncasecmp` to `_strnicmp`.

The test used `strncasecmp` (POSIX, from `<strings.h>`) which is not available on Windows.
