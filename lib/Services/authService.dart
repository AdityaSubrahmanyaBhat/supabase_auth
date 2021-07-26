import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase/supabase.dart';

class AuthService {
  final _authClient = Get.find<SupabaseClient>();
  //register user and create a custom user data in the database
 Future<GotrueSessionResponse> signUpUser(String name, String email, String password) async {
    final user = await _authClient.auth.signUp(email, password);
    final response = await _authClient.from('Users').insert([
      {"Id": user.user.id, "Name": name, "Email": email}
    ]).execute();
    if (response.error == null) {
      return user;
    }
    return user;
  }

//log in user
 Future<GotrueSessionResponse> signIn(String email, String password) async {
    final user =
        await _authClient.auth.signIn(email: email, password: password);
    
      return user;
    
  }

//get currently logged in user data
  User getCurrentUser() {
    return _authClient.auth.user();
  }

//logOut user
  Future logOut() async {
    Get.find<GetStorage>().remove('user');
    await _authClient.auth.signOut();
  }

//RecoverSession
  Future<GotrueSessionResponse> recoverSession(String session) async {
    return await _authClient.auth.recoverSession(session);
  }
}
