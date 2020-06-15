import 'package:http/http.dart' as http;
import 'package:ibina_Demo_App/util/const.dart';

class Repository {
  httpGet(String api) async {
    return await http.get(BASE_API + api);
  }
}
