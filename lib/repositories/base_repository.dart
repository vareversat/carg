import 'package:carg/exceptions/repository_exception.dart';
import 'package:carg/models/carg_object.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseRepository<T extends CargObject> {
  final String database;
  final String environment;
  final FirebaseFirestore provider;
  late final String connectionString;

  BaseRepository(
      {required this.database,
      required this.environment,
      required this.provider}) {
    connectionString = '$database-$environment';
  }

  /// Get a [T] object from the database
  /// Take an [id] and return a [T]
  Future<T?> get(String id);

  /// Delete a [T] object from the database
  /// Take an [id] and return nothing
  Future<void> delete(String id) async {
    try {
    await provider.collection(connectionString).doc(id).delete();
    } on FirebaseException catch (e) {
      throw RepositoryException(e.message!);
    }
  }

  /// Update specific [fieldName] value of [T] identified by the [id] by a given [value]
  /// Take a [T] and return nothing
  Future<void> updateField(String id, String fieldName, dynamic value) async {
    try {
      await provider
          .collection(connectionString)
          .doc(id)
          .update({fieldName: value});
    } on FirebaseException catch (e) {
      throw RepositoryException(e.message!);
    }
  }

  /// Update a [T] object in the database
  /// Take a [T] and return nothing
  Future<void> update(T t) async {
    try {
      await provider
          .collection(connectionString)
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
          .collection(connectionString)
          .add(t.toJSON());
      return documentReference.id;
    } on FirebaseException catch (e) {
      throw RepositoryException(e.message!);
    }
  }
}
