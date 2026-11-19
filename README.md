# iOSSpoof
kernel-level darwin uname(), uidevice, and corelocation gps spoofer with native ios settings panel by hacker // binarycrypted.


kernel-level darwin `uname()`, `uidevice`, and `corelocation` gps spoofing utility with native settings integration for ios 9.3.6 (`armv7`).

## features

- **hardware model spoof**: hooks `uname()` via `mshookfunction` to spoof machine identifiers (`iPhone12,1`, `iPhone14,2`, `iPhone16,1`, `iPad13,4`).
- **system version & name spoof**: overrides `UIDevice` properties (`systemVersion`, `name`) for third-party apps.
- **gps location spoof**: hooks `CLLocation` with 15 global preset cities/regions and an instant status bar double-tap toggle.
- **native settings panel**: configure hardware, ios version, device name, and location presets directly in `settings -> iosspoof`.

## installation

1. download `iOSSpoof-deb` from the latest **actions** build artifact.
2. install the `.deb` via **filza** (requires `mobilesubstrate` and `preferenceloader`).
3. respring and configure options in `settings -> iosspoof`.

## author

hacker // binarycrypted
