class Unit {
  final String key;   // Ej: "kg", "pcs" (Lo que se envía al back)
  final String label; // Ej: "Kilogramos", "Pieza" (Lo que ve el usuario)

  Unit({required this.key, required this.label});
}