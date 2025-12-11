import 'dart:io';

import 'helper.dart';
import 'model.dart';
// import 'package:flutter_lab/app/helper.dart';
// import 'package:flutter_lab/app/model.dart';

class WriteController {
  static Future<void> generateModel({
    required String tableName,
    required List<AppDataTable> dataTables,
  }) async {
    String rootDirectory = Directory.current.path;
    String folderDirectoryPath = '$rootDirectory/bin/generated';
    String fileDirectoryPath = '$rootDirectory/bin/generated/model';

    Directory folderDirectory = Directory(folderDirectoryPath);
    Directory fileDirectory = Directory(fileDirectoryPath);

    // Check if the directory exists
    bool folderExists = await folderDirectory.exists();

    if (!folderExists) {
      folderDirectory.create();
    }

    // Check if the directory exists
    bool fileExists = await fileDirectory.exists();

    if (!fileExists) {
      fileDirectory.create();
    }

    String filePath =
        'bin/generated/model/${Helper.tableNameModel(tableName)}.dart';
    File file = File(filePath);

    String valueTable = '''
''';

    String valueTableConst = '''
''';

    String finalVar = '''
''';

    String finalConst = '''
''';

    String fromJson = '''
''';

    String toJson = '''
''';

    String toString = '';

    for (AppDataTable data in dataTables) {
      valueTable += "${data.name},\n";

      if (data.name != 'id') {
        valueTableConst +=
            "static const String ${data.name} = '${data.name}';\n";
        finalVar += "final ${Helper.convertType(data.type)} ${data.name};\n";

        if (Helper.nullableType(data.type)) {
          finalConst += "this.${data.name},\n";
        } else {
          finalConst += "required this.${data.name},\n";
        }
      } else {
        valueTableConst += "static const String ${data.name} = '_id';\n";

        finalVar +=
            "final ${Helper.absoluteConvertType(data.type)}? ${data.name};\n";

        finalConst += "this.${data.name},\n";
      }

      fromJson +=
          "${Helper.fromJsonString(tableName: tableName, name: data.name, type: data.type)},\n";

      if (Helper.toJsonString(
              tableName: tableName, name: data.name, type: data.type) !=
          '') {
        toJson +=
            "${Helper.toJsonString(tableName: tableName, name: data.name, type: data.type)},\n";
      }

      if (data == dataTables.last) {
        toString += "${data.name}: \$${data.name}";
      } else {
        toString += "${data.name}: \$${data.name}, ";
      }
    }

    String fileContent = '''
const String ${Helper.tableNameConvert(tableName)} = '$tableName';

class ${Helper.tableNameField(tableName)} {
  static final List<String> values = [
    $valueTable
  ];

  $valueTableConst
}

class ${Helper.tableNamePlain(tableName)} {
  $finalVar

  const ${Helper.tableNamePlain(tableName)}({
    $finalConst
  });

  static ${Helper.tableNamePlain(tableName)} fromJson(Map<String, Object?> json) =>
      ${Helper.tableNamePlain(tableName)}(
        $fromJson
      );

  Map<String, Object> toJson() => {
      $toJson
      };

  @override
  String toString() {
    return '{$toString}';
  }
}
''';
    await file.writeAsString(fileContent);
    print('Table model created: $filePath');
  }

  static Future<void> generateTable({
    required String tableName,
    required List<AppDataTable> dataTables,
  }) async {
    String rootDirectory = Directory.current.path;

    String folderDirectoryPath = '$rootDirectory/bin/generated';
    String fileDirectoryPath = '$rootDirectory/bin/generated/table';

    Directory folderDirectory = Directory(folderDirectoryPath);
    Directory fileDirectory = Directory(fileDirectoryPath);

    // Check if the directory exists
    bool folderExists = await folderDirectory.exists();

    if (!folderExists) {
      folderDirectory.create();
    }

    // Check if the directory exists
    bool fileExists = await fileDirectory.exists();

    if (!fileExists) {
      fileDirectory.create();
    }

    String filePath = 'bin/generated/table/$tableName.sqlite';
    File file = File(filePath);

    String valueTable = '''
''';

    print(dataTables.last);

    for (AppDataTable data in dataTables) {
      if (data == dataTables.last) {
        valueTable +=
            "${Helper.createColumnTable(tableName: tableName, name: data.name, type: data.type)}\n";
      } else {
        valueTable +=
            "${Helper.createColumnTable(tableName: tableName, name: data.name, type: data.type)},\n";
      }
    }

    String fileContent = """
'''
CREATE TABLE $tableName(
  $valueTable)
'''
""";
    await file.writeAsString(fileContent);
    print('Table query created: $filePath');
  }

  static Future<void> generateJsonModel({
    required Map<String, dynamic> jsonData,
    bool product = false,
  }) async {
    String rootDirectory = Directory.current.path;

    String folderDirectoryPath = '$rootDirectory/bin/generated';
    String fileDirectoryPath = '$rootDirectory/bin/generated/json';

    Directory folderDirectory = Directory(folderDirectoryPath);
    Directory fileDirectory = Directory(fileDirectoryPath);

    // Check if the directory exists
    bool folderExists = await folderDirectory.exists();

    if (!folderExists) {
      folderDirectory.create();
    }

    // Check if the directory exists
    bool fileExists = await fileDirectory.exists();

    if (!fileExists) {
      fileDirectory.create();
    }

    // print(jsonData);
    List<String> keys = Helper.getKeys(jsonData) ?? [];
    String fileName = keys.last;

    String filePath = 'bin/generated/json/${fileName}s_setting.dart';
    File file = File(filePath);

    String fileContent;
    if (product) {
      fileContent = Helper.jsonString(jsonData, product: true);
    } else {
      fileContent = Helper.jsonString(jsonData);
    }

    await file.writeAsString(fileContent);
    print('Json model created: $filePath');
  }
}
