import 'dart:io';

/// RapidWeave Build Manager
///
/// This tool orchestrates template-specific builds by:
/// 1. Syncing template assets to the active bundle
/// 2. Injecting build-time constants for tree-shaking
/// 3. Executing the Flutter build command
void main(List<String> args) async {
  if (args.isEmpty) {
    printUsage();
    return;
  }

  final command = args[0];
  if (command == 'help') {
    printUsage();
    return;
  }

  if (args.length < 2) {
    print('Error: Template ID required.');
    printUsage();
    return;
  }

  final templateId = args[1];
  final platform = args.length > 2 ? args[2] : 'web';

  switch (command) {
    case 'prepare':
      await prepareAssets(templateId);
      break;
    case 'build':
      await prepareAssets(templateId);
      await runBuild(templateId, platform);
      break;
    default:
      print('Unknown command: $command');
      printUsage();
  }
}

void printUsage() {
  print('RapidWeave Build Manager');
  print('Usage: dart tool/build_manager.dart <command> <template> [platform]');
  print('');
  print('Commands:');
  print('  prepare <template>         Sync assets for a template');
  print('  build   <template> <plat>  Prepare and run flutter build');
  print('');
  print('Example:');
  print('  dart tool/build_manager.dart build healthcare web');
}

Future<void> prepareAssets(String templateId) async {
  print('--- Preparing Assets for [$templateId] ---');
  
  final commonDir = Directory('assets/configs');
  final targetDir = Directory('assets/active');

  // 1. Clean and Ensure Target Directory
  if (targetDir.existsSync()) {
    targetDir.deleteSync(recursive: true);
  }
  targetDir.createSync(recursive: true);

  print('Syncing common configs...');
  if (commonDir.existsSync()) {
    await _copyDirectory(commonDir, targetDir);
  }
  
  print('Success: Common assets synced to root workspace.');
}

Future<void> _copyDirectory(Directory source, Directory target) async {
  await for (var entity in source.list(recursive: true)) {
    if (entity is File) {
      final relativePath = entity.path.replaceFirst(source.path, '');
      final newPath = '${target.path}$relativePath';
      
      // Ensure subdirectories exist
      await File(newPath).parent.create(recursive: true);
      await entity.copy(newPath);
    }
  }
}

Future<void> runBuild(String templateId, String platform) async {
  print('--- Executing Optimized Build [$templateId | $platform] ---');

  final process = await Process.start('flutter', [
    'build',
    platform,
    '--dart-define=TEMPLATE=$templateId',
    '--dart-define=WHITE_LABEL=true',
  ], runInShell: true);

  // Stream output to terminal
  stdout.addStream(process.stdout);
  stderr.addStream(process.stderr);

  final exitCode = await process.exitCode;
  if (exitCode == 0) {
    print('\n🚀 Build Successful! Optimized for [$templateId].');
  } else {
    print('\n❌ Build Failed with exit code $exitCode.');
    exit(exitCode);
  }
}
