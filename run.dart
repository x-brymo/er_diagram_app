import 'dart:io';

void main() async {
  final file = File('packages.txt');

  if (await file.exists()) {
    List<String> packages = await file.readAsLines();
    List<String> installedPackages = [];

    // Get already installed packages
    ProcessResult listResult = await Process.run('dart', ['pub', 'list']);
    if (listResult.exitCode == 0) {
      installedPackages = listResult.stdout.toString().split('\n');
    }

    int totalPackages = packages.length;
    int installedCount = 0;
    int skippedCount = 0;

    for (String package in packages) {
      package = package.trim();
      if (package.isNotEmpty) {
        if (!installedPackages.contains(package)) {
          installedCount++;
          stdout.write('\rInstalling: $package [$installedCount/$totalPackages]');
          ProcessResult result = await Process.run('dart', ['pub', 'add', package]);
          print('\n' + result.stdout);
          print(result.stderr);
        } else {
          skippedCount++;
          print('Skipping (already installed): $package');
        }
      }
    }
    print('\nTotal Packages: $totalPackages');
    print('Installed: $installedCount');
    print('Skipped: $skippedCount');
  } else {
    print('packages.txt not found!');
  }
}
