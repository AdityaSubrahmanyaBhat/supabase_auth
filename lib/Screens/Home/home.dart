import 'package:supabase_auth/Screens/Auth/loginPage.dart';
import 'package:supabase_auth/Services/authService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomePage> {
  AuthService _authservice = AuthService();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        centerTitle: true,
      ),
      body: Center(
        child: loading == false
            ? ElevatedButton(
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  await logout();
                },
                child: Text("Log Out"),
              )
            : CircularProgressIndicator(),
      ),
    );
  }

  Future logout() async {
    await _authservice.logOut();
    setState(() {
      loading = false;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}
