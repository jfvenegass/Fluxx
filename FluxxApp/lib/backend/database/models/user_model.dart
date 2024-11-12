class User {
  final int? id; // Opcional si el ID es generado automáticamente
  final String name;
  final String email;

  User({
    this.id,
    required this.name,
    required this.email,
  });

  // Convertir un mapa (de la base de datos o backend) a un objeto User
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      name: map['name'] as String,
      email: map['email'] as String,
    );
  }

  // Convertir un objeto User a un mapa (para la base de datos o backend)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
