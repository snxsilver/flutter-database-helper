// import 'package:flutter/material.dart';
// import 'package:flutter_lab/app/read_controller.dart';
// import 'package:flutter_lab/app/write_controller.dart';
// import 'dart:io';
// import 'package:flutter_test/flutter_test.dart';

// import 'app/model.dart';

// void main() {
//   // print("object");
//   test('read', () async {
//     var result = await ReadController.readJson('delete.json');
//     await WriteController.generateJsonModel(jsonData: result ?? {});
//     // print(result);
//   });
// }

import 'dart:io';

import 'read_controller.dart';
import 'write_controller.dart';

// Future<void> main() async {
//   print("Reading JSON...");

//   var result = await ReadController.readJson('delete.json');

//   if (result == null) {
//     print("No data found in delete.json");
//     return;
//   }

//   await WriteController.generateJsonModel(jsonData: result);

//   // print("Done generating JSON model!");
// }

Future<void> readJson() async {
  stdout.write("Enter your JSON filename (example: example.json): ");
  final filename = stdin.readLineSync();

  if (filename == null || filename.isEmpty) {
    print("Filename cannot be empty.");
    return;
  }

  print("Processing $filename ...");

  final result = await ReadController.readJson(filename);

  await WriteController.generateJsonModel(
    jsonData: result ?? {},
  );

  print("JSON model generated successfully!");
}
