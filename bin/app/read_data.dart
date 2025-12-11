// import 'package:flutter/material.dart';
// import 'package:flutter_lab/app/read_controller.dart';
// import 'package:flutter_lab/app/write_controller.dart';
// import 'dart:io';
// import 'package:flutter_test/flutter_test.dart';

// import 'app/model.dart';

// void main() {
//   const String schema = "summary.sqlite";
//   // print("object");
//   test('read', () async {
//     // await readData('file.sqlite');
//     var table = await ReadController.readTableName(schema);
//     var data = await ReadController.readDataTable(schema);
//     // print(table);
//     await WriteController.generateModel(tableName: table!, dataTables: data!);
//     await WriteController.generateTable(tableName: table, dataTables: data);
//   });
// }

import 'dart:async';
import 'dart:io';
import 'read_controller.dart';
import 'write_controller.dart';

// Future<void> main() async {
//   print("Reading Sqlite...");
//   const String schema = "summary.sqlite";

//   var table = await ReadController.readTableName(schema);
//   var data = await ReadController.readDataTable(schema);

//   await WriteController.generateModel(
//     tableName: table!,
//     dataTables: data!,
//   );

//   await WriteController.generateTable(
//     tableName: table,
//     dataTables: data,
//   );

//   // print("Generation completed!");
// }

Future<void> readData() async {
  stdout.write("Enter your sqlite filename (example: example.sqlite): ");
  final schema = stdin.readLineSync();

  if (schema == null || schema.isEmpty) {
    print("Filename cannot be empty.");
    return;
  }

  print("Processing $schema ...");

  // Call your controllers
  final table = await ReadController.readTableName(schema);
  final data = await ReadController.readDataTable(schema);

  await WriteController.generateModel(
    tableName: table!,
    dataTables: data!,
  );

  await WriteController.generateTable(
    tableName: table,
    dataTables: data,
  );

  print("Model and table generated successfully!");
}
