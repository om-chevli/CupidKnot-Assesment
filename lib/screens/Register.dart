import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:cupid_knot/models/RegisterUser.dart';
import 'package:cupid_knot/widgets/FormTextInput.dart';

class Register extends StatefulWidget {
  static const routeName = '/register';
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  List<bool> isSelected = [true, false];
  var _isLoading = false;
  String gender = "MALE";
  String url = 'cupidknot.kuldip.dev';
  final _form = GlobalKey<FormState>();

  final fnController = TextEditingController();
  final lnController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final genderController = TextEditingController();
  final emailFocusNode = FocusNode();

  @override
  void dispose() {
    fnController.dispose();
    lnController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    genderController.dispose();
    super.dispose();
  }

  Future<RegisterUser?> registeringUser() async {
    // ignore: unused_local_variable
    final response = await http
        .post(Uri.https(url, 'api/register'),
            body: RegisterUser(
              firstName: fnController.text,
              lastName: lnController.text,
              email: emailController.text,
              password: passwordController.text,
              passwordConfirmation: confirmPasswordController.text,
              gender: gender,
            ).toJson())
        .then((value) {
      int statusCode = value.statusCode;
      if (statusCode == 302) {
        showDialog(
          context: context,
          builder: (BuildContext bContext) {
            return ConfirmationDialog(
              context: context,
              displayIcon: Icons.cancel_rounded,
              displayText: "An account with same email already exists!",
              onPress: () {
                emailController.clear();
                emailFocusNode.requestFocus();
              },
            );
          },
        );
      } else if (statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext bContext) {
            return ConfirmationDialog(
              context: context,
              displayIcon: Icons.check_box_rounded,
              displayText: "Account Created Successfully!",
              onPress: () {
                Navigator.of(context).popAndPushNamed('/');
              },
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext bContext) {
            return ConfirmationDialog(
              context: context,
              displayIcon: Icons.check_box_rounded,
              displayText: "Some Technical Error!",
              onPress: null,
            );
          },
        );
      }
    });
  }

  void _registerUser() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) return;
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    await registeringUser();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Form(
              key: _form,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "Registration",
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                  SizedBox(height: 10),
                  FormTextInput(
                    label: "First Name",
                    kType: TextInputType.name,
                    textController: fnController,
                    validate: (text) {
                      if (text!.isEmpty) {
                        return 'Please enter your First Name!';
                      } else if (!(text.length >= 3) && text.isNotEmpty) {
                        return "Name should be 3 or more letters long!";
                      }
                      return null;
                    },
                  ),
                  FormTextInput(
                    label: "Last Name",
                    kType: TextInputType.name,
                    textController: lnController,
                    validate: (text) {
                      if (text!.isEmpty) {
                        return 'Please enter your Last Name!';
                      } else if (!(text.length >= 3) && text.isNotEmpty) {
                        return "Name should be 3 or more letters long!";
                      }
                      return null;
                    },
                  ),
                  FormTextInput(
                    label: "Email-ID",
                    kType: TextInputType.emailAddress,
                    textController: emailController,
                    focus: emailFocusNode,
                    validate: (text) {
                      if (!EmailValidator.validate(text!)) {
                        return "Enter Valid Email";
                      }
                      return null;
                    },
                  ),
                  FormTextInput(
                    label: "Password",
                    value: true,
                    textController: passwordController,
                    validate: (text) {
                      if (text!.isEmpty) {
                        return 'Please Create a password!';
                      } else if ((text.length < 8) && text.isNotEmpty) {
                        return "Password should be of 8 digits!";
                      }
                      return null;
                    },
                  ),
                  FormTextInput(
                    label: "Confirm Password",
                    value: true,
                    textController: confirmPasswordController,
                    validate: (text) {
                      if (text!.isEmpty) {
                        return 'Please confirm your password!';
                      } else if (text != passwordController.text &&
                          text.isNotEmpty) {
                        return "Password didn't matched!";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  ToggleButtons(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [Icon(Icons.male), Text("Male")],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [Icon(Icons.female), Text("Female")],
                        ),
                      ),
                    ],
                    onPressed: (int index) {
                      setState(() {
                        for (int buttonIndex = 0;
                            buttonIndex < isSelected.length;
                            buttonIndex++) {
                          if (buttonIndex == index) {
                            isSelected[buttonIndex] = true;
                          } else {
                            isSelected[buttonIndex] = false;
                          }
                        }
                        if (index > 0) {
                          gender = "FEMALE";
                        } else {
                          gender = "MALE";
                        }
                      });
                    },
                    isSelected: isSelected,
                  ),
                  SizedBox(height: 20),
                  _isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () => _registerUser,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "REGISTER",
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
                          onLongPress: () {
                            return;
                          },
                        ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Navigator.popAndPushNamed(context, "/"),
                    child: Text(
                      "Back to Login!",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    Key? key,
    required this.context,
    this.onPress,
    required this.displayText,
    required this.displayIcon,
  }) : super(key: key);

  final BuildContext context;
  final Function? onPress;
  final String displayText;
  final IconData displayIcon;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 20,
      child: Container(
        padding: EdgeInsets.all(15),
        height: MediaQuery.of(context).size.height / 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(displayIcon),
              onPressed: null,
              iconSize: 40,
            ),
            Text(
              displayText,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onPress!();
              },
              child: Text("Okay"),
            )
          ],
        ),
      ),
    );
  }
}
