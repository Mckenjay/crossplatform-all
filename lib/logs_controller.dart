import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cross_platform/log_model.dart';

class LogController {
  final CollectionReference logsCollection = FirebaseFirestore.instance.collection('logs');

  Future<List<LogsModel>> getLogs() async {
    QuerySnapshot querySnapshot = await logsCollection.get();
    return querySnapshot.docs.map((doc) => LogsModel.fromDocument(doc)).toList();
  }

  Future<void> deleteLog(LogsModel log) async {
    await FirebaseFirestore.instance.collection('logs').doc(log.id).delete();
  }

  Future<void> addLog(String platform, String message) async {
    try {
      await logsCollection.add({
        'platform': platform,
        'message': "$message on $platform",
        'timestamp': FieldValue.serverTimestamp(),
      }).then((value) => print("Log Added"))
        .catchError((error) => print("Failed to add user: $error"));
    } catch(e) {
      print(e);
    }
  }
}