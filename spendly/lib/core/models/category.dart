class CategoryModel {
  final String id;
  final String name;
  final String emoji;
  final String colorHex;
  final bool isExpense;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.emoji,
    required this.colorHex,
    this.isExpense = true,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json, String id) {
    return CategoryModel(
      id: id,
      name: json['name'] as String? ?? '',
      emoji: json['emoji'] as String? ?? '📦',
      colorHex: json['colorHex'] as String? ?? '#94A3B8',
      isExpense: json['isExpense'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'emoji': emoji,
      'colorHex': colorHex,
      'isExpense': isExpense,
    };
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? emoji,
    String? colorHex,
    bool? isExpense,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      colorHex: colorHex ?? this.colorHex,
      isExpense: isExpense ?? this.isExpense,
    );
  }
}
