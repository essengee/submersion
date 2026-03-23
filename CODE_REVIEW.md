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
