// import 'package:flutter_lab/app/model.dart';

import 'model.dart';

class Helper {
  static String tableNameModel(String input) {
    List<String> parts = input.split('_');

    var word = parts.last;
    if (word.substring(word.length - 3) == 'ies') {
      parts.last = '${word.substring(0, word.length - 3)}y';
    } else if (word.substring(word.length - 1) == 's') {
      parts.last = '${word.substring(0, word.length - 1)}';
    }

    return parts.join("_");
  }

  static String tableNameConvert(String input) {
    List<String> parts = input.split('_');

    List<String> capitalizedParts = parts.map((part) {
      return part.substring(0, 1).toUpperCase() + part.substring(1);
    }).toList();

    var word = capitalizedParts.last;
    if (word.substring(word.length - 3) == 'ies') {
      capitalizedParts.last = '${word.substring(0, word.length - 3)}y';
    } else if (word.substring(word.length - 1) == 's') {
      capitalizedParts.last = '${word.substring(0, word.length - 1)}';
    }

    return 'table${capitalizedParts.join()}';
  }

  static String tableNameField(String input) {
    List<String> parts = input.split('_');

    List<String> capitalizedParts = parts.map((part) {
      return part.substring(0, 1).toUpperCase() + part.substring(1);
    }).toList();

    var word = capitalizedParts.last;
    if (word.substring(word.length - 3) == 'ies') {
      capitalizedParts.last = '${word.substring(0, word.length - 3)}y';
    } else if (word.substring(word.length - 1) == 's') {
      capitalizedParts.last = '${word.substring(0, word.length - 1)}';
    }

    return '${capitalizedParts.join()}Fields';
  }

  static String tableNamePlain(String input) {
    List<String> parts = input.split('_');

    List<String> capitalizedParts = parts.map((part) {
      return part.substring(0, 1).toUpperCase() + part.substring(1);
    }).toList();

    var word = capitalizedParts.last;
    if (word.substring(word.length - 3) == 'ies') {
      capitalizedParts.last = '${word.substring(0, word.length - 3)}y';
    } else if (word.substring(word.length - 1) == 's') {
      capitalizedParts.last = '${word.substring(0, word.length - 1)}';
    }

    return capitalizedParts.join();
  }

  static bool nullableType(String input) {
    if (input.substring(input.length - 1) == '?') {
      return true;
    } else {
      return false;
    }
  }

  static String absoluteType(String input) {
    if (input.substring(input.length - 1) == '?') {
      return input.substring(0, input.length - 1);
    } else {
      return input;
    }
  }

  static String convertType(String input) {
    String text = absoluteType(input);

    String? result;
    switch (text) {
      case 'varchar':
        result = 'String';
        break;
      case 'double':
        result = 'int';
        break;
      case 'datetime':
        result = 'DateTime';
        break;
      default:
        return input;
    }

    if (nullableType(input)) {
      return '$result?';
    } else {
      return result;
    }
  }

  static String absoluteConvertType(String input) {
    String converted = convertType(input);
    String result = absoluteType(converted);
    return result;
  }

  static String fromJsonString({
    required String tableName,
    required String name,
    required String type,
  }) {
    String tableField = tableNameField(tableName);
    if (absoluteConvertType(type) == 'DateTime') {
      if (nullableType(type)) {
        return '$name: json[$tableField.$name] != null && json[$tableField.$name] is String ? DateTime.tryParse(json[$tableField.$name] as String) : null';
      } else {
        return '$name: DateTime.parse(json[$tableField.$name] as String)';
      }
    }

    return '$name: json[$tableField.$name] as ${convertType(type)}';
  }

  static String toJsonString({
    required String tableName,
    required String name,
    required String type,
  }) {
    String tableField = tableNameField(tableName);
    // print('$name: ${convertType(type)}');

    if (name == 'id') {
      return '';
    }

    if (absoluteConvertType(type) == 'DateTime') {
      if (nullableType(type)) {
        return '$tableField.$name: $name != null ? $name!.toIso8601String() : 0';
      } else {
        return '$tableField.$name: $name.toIso8601String()';
      }
    }

    if (absoluteConvertType(type) == 'String') {
      // print("$name: checkString");
      if (nullableType(type)) {
        return "$tableField.$name: $name ?? ''";
      } else {
        return '$tableField.$name: $name';
      }
    }

    if (absoluteConvertType(type) == 'int') {
      // print("$name: checkInt");
      if (nullableType(type)) {
        return "$tableField.$name: $name ?? ''";
      } else {
        return '$tableField.$name: $name';
      }
    }

    // print(absoluteConvertType(type));
    return '';
  }

  static String createColumnTable({
    required String tableName,
    required String name,
    required String type,
  }) {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const integerType = 'INTEGER NOT NULL';
    const integerNullType = 'INTEGER NULL';
    const textType = 'TEXT NOT NULL';
    const textNullType = 'TEXT NULL';

    if (name == 'id') {
      return '_id $idType';
    }

    if (absoluteConvertType(type) == 'int') {
      // print("$name: checkInt");
      if (nullableType(type)) {
        return "$name $integerNullType";
      } else {
        return "$name $integerType";
      }
    } else {
      if (nullableType(type)) {
        return "$name $textNullType";
      } else {
        return "$name $textType";
      }
    }
  }

  static Map<String, dynamic> extractMap(String title, jsonData) {
    Map<String, dynamic> resMap = {};
    List<AppDataTable> itemMap = [];
    if (jsonData is Map) {
      // Get all keys from the map
      Iterable<dynamic> keys = jsonData.keys;

      // Print or use the keys as needed
      for (String key in keys) {
        AppDataTable? item;
        if (jsonData[key] is Map) {
          item = AppDataTable(name: key, type: key);
          resMap[key] = extractMap(key, jsonData[key]);
        } else if (jsonData[key] is List) {
          item = AppDataTable(name: key, type: extractList(key, jsonData[key]));
        } else {
          if (isDateTime(jsonData[key].toString())) {
            item = AppDataTable(name: key, type: "DateTime");
          } else {
            item = AppDataTable(
                name: key, type: jsonData[key].runtimeType.toString());
          }
        }
        // print(item);
        itemMap.add(item);
      }
    }
    resMap[title] = itemMap;
    return resMap;
  }

  static String extractList(String key, jsonData) {
    if (jsonData is List) {
      // print("$key: List<${jsonData[0].runtimeType}>");
      return "List<${jsonData[0].runtimeType}>";
    } else {
      // print('JSON data is not a List');
      return "";
    }
  }

  static bool isDateTime(String value) {
    try {
      DateTime.parse(value);
      return true; // Parsing succeeded, so it's a valid DateTime
    } catch (e) {
      return false; // Parsing failed, so it's not a valid DateTime
    }
  }

  static List<String>? getKeys(mapData) {
    List<String>? result = [];
    if (mapData is Map) {
      // Get all keys from the map
      Iterable<dynamic> keys = mapData.keys;

      // Print or use the keys as needed
      // print(keys);
      for (String key in keys) {
        // print("check");
        result.add(key);
      }
    }
    // print(result);
    return result;
  }

  static String jsonString(
    jsonData, {
    bool title = true,
    bool product = false,
  }) {
    List<String> keys = Helper.getKeys(jsonData) ?? [];
    String fileName = keys.last;

    List<AppDataTable> datas = jsonData[fileName];

    String reqVar = '''
''';

    String decVar = '''
''';

    String fromJson = '''
''';

    String toJson = '''
''';

    String addClass = '''
''';

    String preClass = '''
''';

    for (AppDataTable data in datas) {
      reqVar += 'required this.${data.name},\n';

      if (data.name == data.type) {
        decVar += '${capitalizeWord(data.name)} ${data.name};\n';
        fromJson +=
            "${data.name}: ${capitalizeWord(data.name)}.fromJson(json['${data.name}']),\n";
        toJson += "'${data.name}': ${data.name}.toJson,\n";
        addClass += jsonString(jsonData[data.name], title: false);
      } else {
        decVar += '${data.type} ${data.name};\n';
        fromJson += "${data.name}: json['${data.name}'] as ${data.type},\n";
        toJson += "'${data.name}': ${data.name},\n";
      }
    }

    String? setting;

    if (title && !product) {
      setting = '${capitalizeWord(fileName)}Setting';
    } else {
      setting = capitalizeWord(fileName);
    }

    if (product) {
      preClass += '''
class ${setting}s {
  ${setting}s({
    required this.${fileName}s,
  });

  List<$setting> ${fileName}s;

  factory ${setting}s.fromJson(Map<String, dynamic> json) => ${setting}s(
    ${fileName}s: List<$setting>.from(json["$fileName"].map((item) => $setting.fromJson(item))),
      );

  Map<String, dynamic> toJson() => {
     "${fileName}s": List<dynamic>.from(${fileName}s.map((item) => item.toJson())),
      };
}
''';
    }

    String fileContent = '''
$preClass

class $setting {
  $setting({
    $reqVar
  });

  $decVar

  factory $setting.fromJson(Map<String, dynamic> json) => $setting(
    $fromJson
      );

  Map<String, dynamic> toJson() => {
    $toJson
      };
}

$addClass
''';
    return fileContent;
  }

  static String capitalizeWord(String word) {
    if (word.isEmpty) return ''; // Return empty string if input word is empty
    return word.substring(0, 1).toUpperCase() + word.substring(1).toLowerCase();
  }
}
