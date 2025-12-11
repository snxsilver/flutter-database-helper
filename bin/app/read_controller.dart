import 'dart:convert';
import 'dart:io';

import 'helper.dart';
import 'model.dart';

// import 'package:flutter_lab/app/helper.dart';
// import 'package:flutter_lab/app/model.dart';

class ReadController {
  static Future<List<AppDataTable>?> readDataTable(String fileName) async {
    // Specify the path to the file you want to read
    // Get the current working directory
    String currentDirectory = Directory.current.path;

    // Specify the path to the file you want to read
    String filePath = '$currentDirectory/bin/schema/$fileName';

    // Open the file
    File file = File(filePath);

    List<AppDataTable> dataTable = [];
    try {
      // Read the contents of the file asynchronously
      String contents = await file.readAsString();
      // print('content: $contents');

      // Split the input string into lines
      List<String> lines = contents.split('\n');

      // Skip the first line containing the table name
      List<String> linesx = lines.sublist(0, lines.length - 1).sublist(1);
      // print(linesx.length);

      // Extract column names and data types
      for (var line in linesx) {
        // Remove leading and trailing whitespace from the line
        line = line.trim();
        // Split the line into words
        List<String> words = line.split(' ');
        // print('check2');
        if (words.length >= 2) {
          // Extract column name and data type
          String columnName = words[0];
          String dataType = words[1];
          // Return the column definition
          // return '$columnName $dataType';
          dataTable.add(AppDataTable(name: columnName, type: dataType));
          // print(columnName);
        }
      }

      // Print the column definitions
      // columns.forEach(print);
      // print(dataTable);
    } catch (error) {
      // Handle any errors that occur during file reading
      print('Error reading file: $error');
    }
    return dataTable;
    // print("object");
  }

  static Future<String?> readTableName(String fileName) async {
    // Specify the path to the file you want to read
    // Get the current working directory
    String currentDirectory = Directory.current.path;

    // Specify the path to the file you want to read
    String filePath = '$currentDirectory/bin/schema/$fileName';

    // Open the file
    File file = File(filePath);

    List<AppDataTable> dataTable = [];
    String? tableName;
    try {
      // Read the contents of the file asynchronously
      String contents = await file.readAsString();
      // print('content: $contents');

      // Split the input string into lines
      List<String> lines = contents.split('\n');

      // Extract the first line containing the table name
      String firstLine = lines.first.trim();

      // Extract the table name from the first line
      tableName = firstLine.split(' ')[1];

      // print('Table name: $tableName');
    } catch (error) {
      // Handle any errors that occur during file reading
      print('Error reading file: $error');
    }
    return tableName;
    // print("object");
  }

  static Future<Map<String, dynamic>?> readJson(String fileName) async {
    // Specify the path to the file you want to read
    // Get the current working directory
    String currentDirectory = Directory.current.path;

    // Specify the path to the file you want to read
    String filePath = '$currentDirectory/bin/schema/$fileName';

    // Open the file
    File file = File(filePath);
    List<String> lines = fileName.split('.');
    String title = lines.first;

    // List<AppDataTable> dataTable = [];
    Map<String, dynamic>? result;
    try {
      // Read the contents of the file asynchronously
      String contents = await file.readAsString();

      dynamic jsonData = json.decode(contents);
      result = Helper.extractMap(title, jsonData);
    } catch (error) {
      // Handle any errors that occur during file reading
      print('Error reading file: $error');
    }
    return result;
  }
}
