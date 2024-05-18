import 'dart:async';
import 'package:flutter_cross_platform/logs_controller.dart';

class LoggingService {
  Timer? timer;
   final LogController logController = LogController();

  void startLogging(String platform, String message) {
    timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      await logController.addLog(
        platform, 
        message, 
      );
    });
  }

  void stopLogging() {
    timer?.cancel();
  }
}