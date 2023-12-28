import 'package:mysql1/mysql1.dart';

class Mysql {
  static String host = '***.***.**.**',
      user = 'lab',
      password = 'lab',
      db = 'lab';
  static int port = 0000;

  Mysql();

  Future<MySqlConnection> getConnection() async {
    var settings = new ConnectionSettings(
        host: host, port: port, user: user, password: password, db: db);
    return await MySqlConnection.connect(settings);
  }
}
