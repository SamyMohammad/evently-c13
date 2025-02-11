import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_c13/db/model/AppUser.dart';

class UsersDao {
  static var db = FirebaseFirestore.instance;

  static CollectionReference<AppUser> getUsersCollection() {
    return db.collection(AppUser.collectionName).withConverter<AppUser>(
          fromFirestore: (snapshot, options) =>
              AppUser.fromFireStore(snapshot.data()),
          toFirestore: (object, options) => object.toFireStore(),
        );
  }

  static Future<AppUser> createUser(
      String authUId, String email, String name) async {
    // insert user in DB
    var document = getUsersCollection().doc(authUId);

    var databaseUser = AppUser(id: authUId, email: email, name: name);
    await document.set(databaseUser);
    return databaseUser;
  }

  static Future<AppUser?> readUser(String authId) async {
    var docRef = getUsersCollection().doc(authId);
    var docSnapshot = await docRef.get();
    var user = docSnapshot.data();
    return user;
  }
}
