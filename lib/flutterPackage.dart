class FlutterPackage {
  String name;
  String currentVersion;
  String description;
  String homePage;
  List<dynamic> topics;

  FlutterPackage({
    required this.name,
    required this.currentVersion,
    required this.description,
    required this.homePage,
    required this.topics,
  });

  factory FlutterPackage.fromJson(Map<String, dynamic> json) {
    return FlutterPackage(
      name: json.containsKey('name') ? json['name'] as String : '',
      currentVersion: json['latest'].containsKey('version')
          ? json['latest']['version'] as String
          : '',
      description: json['latest']['pubspec'].containsKey('description')
          ? json['latest']['pubspec']['description'] as String
          : '',
      homePage: json['latest']['pubspec'].containsKey('homepage') &&
              json['latest']['pubspec']['homepage'] != null
          ? json['latest']['pubspec']['homepage'] as String
          : '',
      topics: json['latest']['pubspec'].containsKey('topics')
          ? json['latest']['pubspec']['topics']
          : [],
    );
  }
}
