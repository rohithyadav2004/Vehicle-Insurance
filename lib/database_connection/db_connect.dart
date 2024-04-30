import 'package:mysql1/mysql1.dart';

class DatabaseHelper {
  late MySqlConnection _connection;

  Future<void> connectToDatabase() async {
    _connection = await MySqlConnection.connect(ConnectionSettings(
      host: 'test-insurance.cf2io4cwq71q.us-east-1.rds.amazonaws.com',
      port: 3306, // Default MySQL port
      user: 'admin',
      password: 'monkeydluffy',
      db: 'test_car_insurance',
    ));
  }
  Future<void> closeConnection() async {
    await _connection.close();
  }
  MySqlConnection get connection => _connection;
}
