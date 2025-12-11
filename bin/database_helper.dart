import 'dart:io';

// import 'app/read_controller.dart';
import 'app/read_data.dart';
import 'app/read_json.dart';
// import 'app/write_controller.dart';

void main() async {
  print("Welcome to Database Helper for Flutter");
  print("Please choose one of these options:");
  print("1. Sqlite");
  print("2. Json / API");

  stdout.write("Your choice: ");
  String? choice = stdin.readLineSync();

  switch (choice) {
    case "1":
      await readData();
      break;

    case "2":
      await readJson();
      afterWork();
      break;

    case "99":
      await deleteConfirm();
      break;

    default:
      print("Invalid choice.");
  }
}

Future<void> afterWork() async {
  print("Do you wanna generate another file?");
  print("Please choose one of these options:");
  print("1. Yes");
  print("2. No");

  stdout.write("Your choice: ");
  String? choice = stdin.readLineSync();

  switch (choice) {
    case "1":
      main();
      break;

    case "2":
      print("Thank you!");
      break;

    default:
      print("Invalid choice.");
  }
}

Future<void> clearFolders(List<String> folderPaths) async {
  for (var path in folderPaths) {
    final dir = Directory(path);

    if (await dir.exists()) {
      await for (var entity in dir.list(recursive: false)) {
        if (entity is File) {
          try {
            await entity.delete();
            print("Deleted: ${entity.path}");
          } catch (e) {
            print("Failed to delete ${entity.path}: $e");
          }
        }
      }
    } else {
      print("Directory does not exist: $path");
    }
  }
}

Future<void> delete() async {
  await clearFolders([
    'bin/generated/json',
    'bin/generated/model',
    'bin/generated/table',
  ]);

  print("All files cleared!");
  afterWork();
}

Future<void> deleteConfirm() async {
  print(
      "Are you sure you wanna delete all these Folders (json, model and table):");
  print("1. Yes");
  print("2. No");

  stdout.write("If you are sure type yes: ");
  String? choice = stdin.readLineSync();

  switch (choice) {
    case "yes":
      await delete();
      break;

    case "1":
      print("If you are sure type yes.");
      deleteConfirm();
      break;

    default:
      print("No file is deleted.");
      await afterWork();
  }
}
