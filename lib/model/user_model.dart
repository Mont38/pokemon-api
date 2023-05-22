class Users {
  String? id;
  String? name;
  String? email;
  double? emailVerified;

  Users({
    this.id,
    this.email,
    this.name,
    this.emailVerified,
  });

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      id: map['id'],
      email: map['email'],
      name: map['name'],
      emailVerified: map['emailVerified'],
    );
  }
}
