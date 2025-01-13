import 'package:flutter/material.dart';
import 'package:rehuddle/services/firestore_services.dart';

class HomeViewModel extends ChangeNotifier {
  FirestoreServices firestoreServices = FirestoreServices();

  Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      return await firestoreServices.getUsers();
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }
}
