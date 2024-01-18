import "package:mysql1/mysql1.dart";

class Mysql{
  static String
  host = 'aws.connect.psdb.cloud',
  user = 'ucz9fh9rcudbryeiw8o4',
  db = 'transapp',
  password = 'pscale_pw_L6Nt72Bcx3NY8JtR1wLSHnyEoYYVUDdGvobprYbrkYb';

  static int port = 3306;

  Mysql();

  Future<MySqlConnection> getConnection() async{
    var settings = ConnectionSettings(
      host: host,
      port: port,
      user: user,
      db: db,
      password: password,
      useSSL: true,

    );

    return await MySqlConnection.connect(settings);
  }

}

