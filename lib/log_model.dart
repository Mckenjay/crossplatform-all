import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class LogsModel{
  final String id;
  final String platform;
  final String message;
  final String timestamp;

  LogsModel({
    required this.id,
    required this.platform,
    required this.message,
    required this.timestamp,
  });

  factory LogsModel.fromDocument(DocumentSnapshot doc){
    return LogsModel(
      id: doc.id,
      platform: doc.get('platform'),
      message: doc.get('message'),
      timestamp: DateFormat('yyyy-MM-dd HH:mm:ss').format(doc.get('timestamp').toDate()),
    );
  }
}