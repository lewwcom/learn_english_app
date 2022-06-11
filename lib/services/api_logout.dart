import 'package:learn_english_app/api/api_client.dart' as api_client;

class APILogout {
  Future<void> logOut() async {
    await api_client.post(
        //"http://10.0.2.2:5001/auth/logout",
        "auth/logout",
        api_client.DiscardResponseContentSerializer());
    await api_client.removeCookie();
  }
}
