#!/usr/bin/env bash
#
# Fail if a built APK is missing libtc_helper.so for any ABI it should carry.
#
# Why this exists: the Gradle hook that compiles the Rust library is deliberately
# non-fatal, so a contributor without a Rust toolchain can still build. The cost of
# that choice is that a *misconfigured CI runner* also silently skips the compile —
# and the resulting APK installs perfectly, launches, and then dies inside
# RustLib.init() because there is no native library to bind to. A build that fails
# loudly is safe; one that emits a broken artifact is not. This script converts
# that silent failure into a red build.
#
# This checks the APK itself rather than jniLibs/, so it catches both "cargo never
# ran" and "cargo ran but Gradle didn't package the result".
#
# Usage: scripts/verify_apk_native_libs.sh <apk> [<apk> ...]
#
# Expected ABIs are inferred from the filename: a split APK
# (app-arm64-v8a-release.apk) must contain exactly its own ABI; anything else is
# treated as a universal APK and must contain all three.

set -euo pipefail

ALL_ABIS="arm64-v8a armeabi-v7a x86_64"
LIB="libtc_helper.so"

if [ "$#" -eq 0 ]; then
  echo "usage: $0 <apk> [<apk> ...]" >&2
  exit 2
fi

# Prefer unzip; fall back to Python where the runner lacks it.
list_entries() {
  if command -v unzip >/dev/null 2>&1; then
    unzip -Z1 "$1"
  else
    python3 -c 'import sys,zipfile;print("\n".join(zipfile.ZipFile(sys.argv[1]).namelist()))' "$1"
  fi
}

fail=0

for apk in "$@"; do
  if [ ! -f "$apk" ]; then
    echo "::error::APK not found: $apk"
    fail=1
    continue
  fi

  expected=""
  for abi in $ALL_ABIS; do
    case "$(basename "$apk")" in
      *"$abi"*) expected="$abi" ;;
    esac
  done
  [ -n "$expected" ] || expected="$ALL_ABIS"

  entries="$(list_entries "$apk")"
  echo "== $apk"
  echo "   expecting: $expected"

  for abi in $expected; do
    if printf '%s\n' "$entries" | grep -qx "lib/$abi/$LIB"; then
      echo "   ok       lib/$abi/$LIB"
    else
      echo "::error file=$apk::missing lib/$abi/$LIB — this APK installs cleanly and then crashes at RustLib.init()"
      fail=1
    fi
  done
done

if [ "$fail" -ne 0 ]; then
  echo "::error::native library verification FAILED — do not publish these artifacts"
  exit 1
fi

echo "All APKs carry $LIB for every expected ABI."
