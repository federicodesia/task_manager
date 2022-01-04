class User{
  final String? uuid;
  final String? email;
  final String? name;

  const User({
    required this.uuid,
    required this.email,
    required this.name
  });

  static const empty = User(
    uuid: null,
    email: null,
    name: null
  );
}