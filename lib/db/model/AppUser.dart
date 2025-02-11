class AppUser {
  static const String collectionName = "users";
  String? id;
  String? name;
  String? email;

  // db // api
  AppUser({this.id, this.email, this.name});

  AppUser.fromFireStore(Map<String, dynamic>? data)
      : this(id: data?["id"], email: data?["email"], name: data?["name"]);

  Map<String, dynamic> toFireStore() {
    return {"id": id, "name": name, "email": email};
  }
}
