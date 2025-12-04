// features/home/domain/entities/kitchen.dart (MODIFICADO para incluir imageUrl en toDisplayData)

class Kitchen {
  final int id;
  final String name;
  final String description;
  final int stateId;
  final int municipalityId;
  final String imageUrl; // Ya existe, pero se asegura que se use.

  Kitchen({
    required this.id,
    required this.name,
    required this.description,
    required this.stateId,
    required this.municipalityId,
    required this.imageUrl,
  });

  // Método helper para pasar datos a la siguiente pantalla fácilmente.
  // Se asegura que la URL de la imagen se pase, ya que el endpoint de detalles puede no tenerla.
  Map<String, String> toDisplayData() {
    return {
      'title': name,
      'location': description, // Usamos la descripción como un subtítulo de ubicación en el modal.
      'image': imageUrl, // Aseguramos que la imagen se pase.
      'description': description, // También pasamos la descripción para el modal.
    };
  }
}