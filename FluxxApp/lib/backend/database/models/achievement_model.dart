class Achievement {
  final int? id; // Opcional si el ID es generado automáticamente
  final String title; // Título del logro
  final bool unlocked; // Estado del logro (desbloqueado o no)

  Achievement({
    this.id,
    required this.title,
    required this.unlocked,
  });

  // Convertir un mapa (de la base de datos) a un objeto Achievement
  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      id: map['id'] as int?,
      title: map['title'] as String,
      unlocked: map['unlocked'] == 1, // Convertir 1/0 a true/false
    );
  }

  // Convertir un objeto Achievement a un mapa (para la base de datos)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'unlocked': unlocked ? 1 : 0, // Convertir true/false a 1/0
    };
  }
}
