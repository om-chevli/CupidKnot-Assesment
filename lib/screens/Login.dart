import 'package:cupid_knot/models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';
import '../widgets/FormTextInput.dart';
import '../models/auth.dart';

class Login extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _form = GlobalKey<FormState>();
  var _isLoading = false;
  String status = "";

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginUser() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) return;
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false).logingUser(_authData);
    } on HttpException catch (e) {
      status = e.toString();
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: SafeArea(
                child: Image.asset(
                  "lib/assets/images/RegistrationLogo.png",
                  fit: BoxFit.contain,
                  alignment: Alignment.topCenter,
                  height: 220,
                  width: 220,
                ),
              ),
            ),
            Text(
              "Login",
              style: TextStyle(
                fontSize: 40,
              ),
            ),
            Container(
              margin: EdgeInsets.all(30),
              child: Form(
                key: _form,
                child: Column(
                  children: [
                    FormTextInput(
                      label: "Email-ID",
                      kType: TextInputType.emailAddress,
                      textController: emailController,
                      validate: (text) {
                        if (!EmailValidator.validate(text!)) {
                          return "Enter Valid Email";
                        }
                        return null;
                      },
                      save: (value) {
                        _authData["email"] = value!;
                      },
                    ),
                    SizedBox(height: 20),
                    FormTextInput(
                      label: "Password",
                      value: true,
                      textController: passwordController,
                      validate: (text) {
                        if (text!.isEmpty) {
                          return "Enter Password!";
                        }
                        return null;
                      },
                      save: (value) {
                        _authData["password"] = value!;
                      },
                    ),
                    SizedBox(height: 15),
                    Text(
                      status,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    if (_isLoading)
                      CircularProgressIndicator()
                    else
                      ElevatedButton(
                        onPressed: () => _loginUser(),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onLongPress: () {
                          return;
                        },
                      ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () =>
                          Navigator.popAndPushNamed(context, "/register"),
                      child: Text(
                        "Create A Account",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
