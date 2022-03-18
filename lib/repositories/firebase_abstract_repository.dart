import 'package:carg/exceptions/repository_exception.dart';
import 'package:carg/models/carg_object.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirebaseAbstractRepository<T extends CargObject> {
  final String database;
  final String environment;
  final FirebaseFirestore provider;

  FirebaseAbstractRepository(
      {required this.database,
      required this.environment,
      required this.provider});

  /// Get a [T] object from the database
  /// Take an [id] and return a [T]
  Future<T?> get(String id);

  /// Delete a [T] object from the database
  /// Take an [id] and return nothing
  Future<void> delete(String id) async {
      await provider.collection(database + '-' + environment).doc(id).delete();
  }

  /// Update a [T] object in the database
  /// Take a [T] and return nothing
  Future<void> update(T t) async {
    try {
      await provider
          .collection(database + '-' + environment)
          .doc(t.id)
          .update(t.toJSON());
    } on FirebaseException catch (e) {
      throw RepositoryException(e.message!);
    }
  }

  /// Create a [T] object in the database
  /// Take a [T] and return the ID of the new document
  Future<String> create(T t) async {
    try {
      var documentReference = await provider
          .collection(database + '-' + environment)
          .add(t.toJSON());
      return documentReference.id;
    } on FirebaseException catch (e) {
      throw RepositoryException(e.message!);
    }
  }
}
