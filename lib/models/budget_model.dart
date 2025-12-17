class Budget {
  final double total;
  final double spent;
  final List<BudgetCategory> categories;

  Budget({
    required this.total,
    required this.spent,
    required this.categories,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      total: (json['total'] ?? 0).toDouble(),
      spent: (json['spent'] ?? 0).toDouble(),
      categories: (json['categories'] as List?)
              ?.map((c) => BudgetCategory.fromJson(c))
              .toList() ??
          [],
    );
  }
}

class BudgetCategory {
  final String name;
  final double allocated;
  final double spent;
  final List<SubCategory>? subCategories;

  BudgetCategory({
    required this.name,
    required this.allocated,
    required this.spent,
    this.subCategories,
  });

  factory BudgetCategory.fromJson(Map<String, dynamic> json) {
    return BudgetCategory(
      name: json['name'] ?? '',
      allocated: (json['allocated'] ?? 0).toDouble(),
      spent: (json['spent'] ?? 0).toDouble(),
      subCategories: (json['subCategories'] as List?)
          ?.map((s) => SubCategory.fromJson(s))
          .toList(),
    );
  }
}

class SubCategory {
  final String name;
  final double allocated;
  final double spent;

  SubCategory({
    required this.name,
    required this.allocated,
    required this.spent,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      name: json['name'] ?? '',
      allocated: (json['allocated'] ?? 0).toDouble(),
      spent: (json['spent'] ?? 0).toDouble(),
    );
  }
}