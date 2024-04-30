import 'package:mysql1/mysql1.dart';

class DatabaseHelper {
  late MySqlConnection _connection;

  Future<void> connectToDatabase() async {
    _connection = await MySqlConnection.connect(ConnectionSettings(
      host: 'aws endpoint',
      port: 3306, // Default MySQL port
      user: 'username',
      password: 'password',
      db: 'database name',
    ));
  }
  Future<void> closeConnection() async {
    await _connection.close();
  }
  MySqlConnection get connection => _connection;
}
