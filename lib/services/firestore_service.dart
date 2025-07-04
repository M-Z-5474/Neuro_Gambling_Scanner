import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Save history to Firestore
  Future<void> saveHistory(String predictionResult, String riskLabel, String recoveryStrategy) async {
    User? user = _auth.currentUser;
    if (user == null) {
      print("No user logged in");
      return;
    }

    // Reference to the user's history document
    DocumentReference historyRef = _db.collection('history').doc(user.uid);

    // Get the current data from the document (if exists)
    DocumentSnapshot snapshot = await historyRef.get();
    if (snapshot.exists) {
      // Add new history entry to the existing list
      await historyRef.update({
        'history': FieldValue.arrayUnion([
          {
            'prediction': predictionResult,
            'riskLabel': riskLabel,
            'recoveryStrategy': recoveryStrategy,
            'timestamp': FieldValue.serverTimestamp(),
          }
        ]),
      });
    } else {
      // If no document, create one with the first entry
      await historyRef.set({
        'history': [
          {
            'prediction': predictionResult,
            'riskLabel': riskLabel,
            'recoveryStrategy': recoveryStrategy,
            'timestamp': FieldValue.serverTimestamp(),
          }
        ],
      });
    }
  }

  // Load user's history
  Future<List<Map<String, dynamic>>> loadHistory() async {
    User? user = _auth.currentUser;
    if (user == null) {
      print("No user logged in");
      return [];
    }

    // Reference to the user's history document
    DocumentSnapshot snapshot = await _db.collection('history').doc(user.uid).get();
    if (snapshot.exists) {
      List<dynamic> historyList = snapshot['history'];
      return historyList.map((history) => history as Map<String, dynamic>).toList();
    } else {
      return [];
    }
  }
}
