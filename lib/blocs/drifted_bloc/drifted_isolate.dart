import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:drift/isolate.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:task_manager/blocs/drifted_bloc/drifted_database.dart';

abstract class DriftedIsolate{

  static Future<DriftIsolate> _createDriftIsolate() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = p.join(directory.path, 'db.sqlite');

    final executor = NativeDatabase(File(path));
    final driftIsolate = DriftIsolate.inCurrent(
      () => DatabaseConnection.fromExecutor(executor),
    );

    return driftIsolate;
  }

  static Future<DriftedDatabase> createOrGetDatabase() async{
    final databasePort = IsolateNameServer.lookupPortByName(
      DriftedDatabase.databasePortName
    );

    SendPort sendPort;
    DriftedDatabase database = DriftedDatabase.connect(
      await DriftIsolate.fromConnectPort(
        sendPort = databasePort ?? (await _createDriftIsolate()).connectPort
      ).connect()
    );

    await (database.executor.ensureOpen(database.attachedDatabase))
      .timeout(const Duration(seconds: 1), onTimeout: () async{

        IsolateNameServer.removePortNameMapping(DriftedDatabase.databasePortName);
        await database.close();

        database = DriftedDatabase.connect(await DriftIsolate.fromConnectPort(
          sendPort = (await _createDriftIsolate()).connectPort
        ).connect());

        return false;
      }
    );

    IsolateNameServer.registerPortWithName(
      sendPort, DriftedDatabase.databasePortName
    );
    return database;
  }
}