import 'package:supabase/supabase.dart';
import 'package:supabase_auth/Screens/Auth/loginPage.dart';
import 'package:supabase_auth/Services/authService.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  AuthService _service = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool registering = false;
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 100.0),
                child: Center(
                  child: Text(
                    'REGISTER',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 50,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: size.height / 6,
                  left: 40.0,
                  right: 40.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 20.0,
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: "Name",
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          validator: MultiValidator([
                            RequiredValidator(errorText: "Required"),
                          ]),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          validator: MultiValidator([
                            RequiredValidator(errorText: "Required"),
                            EmailValidator(
                                errorText:
                                    "Please enter a valid email address"),
                          ]),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          obscureText: true,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          validator: MultiValidator([
                            RequiredValidator(errorText: "Required"),
                            MinLengthValidator(6,
                                errorText:
                                    "Password must contain atleast 6 characters"),
                            MaxLengthValidator(20,
                                errorText:
                                    "Password must not be more than 20 characters"),
                          ]),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        registering == false
                            ? ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      registering = true;
                                    });
                                    register();
                                  }
                                },
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 50.0),
                                  child: Text(
                                    'Register',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                ),
                              )
                            : CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.black),
                              ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: TextStyle(color: Colors.white),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => LoginPage(),
                                  ),
                                );
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future register() async {
    GotrueSessionResponse result = await _service.signUpUser(
        _nameController.text, _emailController.text, _passwordController.text);
    if (result.data != null) {
      setState(() {
        registering = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        snackBar(content: "Registration Successful", type: "Success"),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(
            email: _emailController.text,
          ),
        ),
      );
    } else if (result.error.message != null) {
      setState(() {
        registering = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        snackBar(content: result.error.message, type: "Error"),
      );
    }
  }

  SnackBar snackBar({String content, String type}) => SnackBar(
        content: Text(
          content,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        backgroundColor: type == "Error" ? Colors.red : Colors.green,
      );
}
