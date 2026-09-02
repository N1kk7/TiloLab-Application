class NpCity {
  final String ref;
  final String present;
  final String mainDescription;

  const NpCity({
    required this.ref,
    required this.present,
    required this.mainDescription,
  });

  factory NpCity.fromJson(Map<String, dynamic> json) => NpCity(
        ref: json['Ref'] as String,
        present: json['Present'] as String,
        mainDescription: json['MainDescription'] as String,
      );
}