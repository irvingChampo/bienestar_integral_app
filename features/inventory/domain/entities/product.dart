class Product {
  final int id;
  final String name;
  final String description; // (+) Nuevo
  final int categoryId;
  final String unit;
  final bool perishable;
  final int? shelfLifeDays; // (+) Nuevo (puede ser nulo si no es perecedero)

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.unit,
    required this.perishable,
    this.shelfLifeDays,
  });
}