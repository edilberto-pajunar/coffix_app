import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffix_app/core/constants/constants.dart';
import 'package:firebase_core/firebase_core.dart';

class FirestoreService {
  static FirebaseFirestore get instance => FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: AppConstants.databaseId,
  );
}