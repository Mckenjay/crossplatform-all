import 'package:flutter/material.dart';
import 'package:flutter_cross_platform/log_model.dart';
import 'package:flutter_cross_platform/logs_controller.dart';


class Logs extends StatefulWidget {
  const Logs({super.key});

  @override
  State<Logs> createState() => _LogsState();
}

class _LogsState extends State<Logs> {
  final LogController logController = LogController();
  late Future<List<LogsModel>> _futureLog;

  @override
  void initState() {
    super.initState();
    _futureLog = logController.getLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logs'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: _futureLog,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('${snapshot.error}'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      LogsModel log = snapshot.data![index];
                      return ListTile(
                        title: Text(log.message),
                        subtitle: Text(log.timestamp.toString()),
                        trailing: IconButton(
                          onPressed: () {
                            logController.deleteLog(log);

                            Navigator.pop(context);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Logs(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                        onTap: () {},
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
