class AppDataTable {
  String name;
  String type;

  AppDataTable({required this.name, required this.type});

  @override
  String toString() {
    return '{name: $name, type: $type}';
  }
}
