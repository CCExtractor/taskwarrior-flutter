import 'dart:io';
import 'package:native_assets_cli/native_assets_cli.dart';
import 'package:native_assets_cli/code_assets.dart';

void main(List<String> args) async {
  await build(args, (input, output) async {
    final targetOS = input.config.code.targetOS;

    // Only support Linux and Windows for now.
    // macOS support will be added once tested on a Mac environment.
    if (targetOS != OS.linux && targetOS != OS.windows) return;

    final rustDir = input.packageRoot.resolve('rust/');

    // Determine the correct library filename for the target OS
    final String libName;
    if (targetOS == OS.windows) {
      libName = 'tc_helper.dll';
    } else {
      libName = 'libtc_helper.so';
    }

    // 1. Run cargo build --release
    final result = await Process.run(
      'cargo',
      ['build', '--release'],
      workingDirectory: rustDir.toFilePath(),
    );

    if (result.exitCode != 0) {
      stdout.write(result.stdout);
      stderr.write(result.stderr);
      throw Exception('Rust build failed on $targetOS');
    }

    // 2. Locate the compiled library
    final libPath = rustDir.resolve('target/release/$libName');

    if (!await File.fromUri(libPath).exists()) {
      throw Exception(
        'Built library not found at $libPath.\n'
        'Make sure Rust and Cargo are installed and the build succeeded.',
      );
    }

    // 3. Register the native asset with Flutter
    output.assets.code.add(CodeAsset(
      package: input.packageName,
      name: 'main.dart',
      linkMode: DynamicLoadingBundled(),
      file: libPath,
    ));
  });
}
