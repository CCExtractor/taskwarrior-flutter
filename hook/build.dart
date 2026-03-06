import 'dart:io';
import 'package:native_assets_cli/native_assets_cli.dart';
import 'package:native_assets_cli/code_assets.dart';

void main(List<String> args) async {
  await build(args, (input, output) async {
    // Check if code assets are supported/requested
    // Note: hook/build.dart is only called if the package has native assets.
    
    final targetOS = input.config.code.targetOS;
    if (targetOS != OS.linux) return;

    final rustDir = input.packageRoot.resolve('rust/');
	
    // 1. Run cargo build --release
    final result = await Process.run(
      'cargo',
      ['build', '--release'],
      workingDirectory: rustDir.toFilePath(),
    );

    if (result.exitCode != 0) {
      stdout.write(result.stdout);
      stderr.write(result.stderr);
      throw Exception('Rust build failed');
    }

    // 2. Locate the library
    final libName = 'libtc_helper.so';
    final libPath = rustDir.resolve('target/release/$libName');

    if (!await File.fromUri(libPath).exists()) {
      throw Exception('Built library not found at $libPath');
    }

    // 3. Add the asset to the output
    output.assets.code.add(CodeAsset(
      package: input.packageName,
      name: 'main.dart', 
      linkMode: DynamicLoadingBundled(),
      file: libPath,
    ));
  });
}
