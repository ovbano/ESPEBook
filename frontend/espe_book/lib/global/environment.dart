import 'dart:io';

class Environment {
  static String apiUrl = Platform.isAndroid
      ? 'http://10.141.0.106:4444/api'
      : 'http://localhost:4444/api';
  static String socketUrl = Platform.isAndroid
      ? 'http://10.141.0.106:4444'
      : 'http://localhost:4444';
}

/*class Environment {
  static String apiUrl = Platform.isAndroid
      ? 'http://192.188.58.82:3000/api'
      : 'http://localhost:3000/api';
  static String socketUrl = Platform.isAndroid
      ? 'http://192.188.58.82:3000'
      : 'http://localhost:3000';
}*/

/*class Environment {
  static String apiUrl = Platform.isAndroid
      ? 'http://10.3.1.203:3000/api'
      : 'http://localhost:3000/api';
  static String socketUrl = Platform.isAndroid
      ? 'http://10.3.1.203:3000'
      : 'http://localhost:3000';
}*/
