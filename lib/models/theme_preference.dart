class ThemePreference {
  const ThemePreference({required this.isDarkMode});

  final bool isDarkMode;

  factory ThemePreference.fromMap(Map<String, dynamic> map) =>
      ThemePreference(isDarkMode: (map['isDarkMode'] as bool?) ?? false);

  Map<String, dynamic> toMap() => {'isDarkMode': isDarkMode};

  ThemePreference copyWith({bool? isDarkMode}) =>
      ThemePreference(isDarkMode: isDarkMode ?? this.isDarkMode);
}
