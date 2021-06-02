import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './/models/User.dart';
import './/models/Users.dart';

class EditProfile extends StatefulWidget {
  static const routeName = "/edit-profile";

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  List<bool> isSelected = [true, false];
  String gender = "MALE";
  final _fName = FocusNode();
  final _lName = FocusNode();
  final _email = FocusNode();
  final _relegion = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedUser = User(
    dob: DateTime.now(),
    gender: "",
    name: "",
    userId: "",
    email: "",
    religion: "",
    fName: "",
    lName: "",
  );
  var _initValues = {
    'fName': '',
    'lName': '',
    'name': '',
    'dob': DateTime.now(),
    'gender': '',
    'email': '',
    'religion': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final userId = ModalRoute.of(context)!.settings.arguments;
      if (userId != null) {
        _editedUser =
            Provider.of<Users>(context, listen: false).personalProfile;
        _initValues = {
          'fName': _editedUser.name!.split(" ")[0],
          'lName': _editedUser.name!.split(" ")[1],
          'email': _editedUser.email as String,
          'religion': _editedUser.religion == null
              ? ""
              : _editedUser.religion as String,
          'dob': _editedUser.dob as DateTime,
          'gender': _editedUser.gender,
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: _editedUser.dob as DateTime,
        firstDate: DateTime(2001),
        lastDate: DateTime(2050));
    if (_editedUser.dob != null && pickedDate != _editedUser.dob)
      setState(() {
        _editedUser = User(
          fName: _editedUser.fName,
          lName: _editedUser.lName,
          email: _editedUser.email,
          religion: _editedUser.religion,
          dob: pickedDate == null ? _editedUser.dob : pickedDate,
          gender: _editedUser.gender,
          userId: _editedUser.userId,
        );
      });
  }

  Future<void> _update() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) return;
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedUser.userId != null) {
      await Provider.of<Users>(context, listen: false)
          .updateProfile(_editedUser);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        actions: [
          IconButton(
            onPressed: _update,
            icon: Icon(
              Icons.done_outline_rounded,
              size: 28,
            ),
            tooltip: "Done",
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues["fName"] as String,
                      decoration: InputDecoration(labelText: 'First Name'),
                      textInputAction: TextInputAction.next,
                      focusNode: _fName,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_lName);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (newValue) => _editedUser = User(
                        fName: newValue,
                        lName: _editedUser.lName,
                        email: _editedUser.email,
                        religion: _editedUser.religion,
                        dob: _editedUser.dob,
                        gender: _editedUser.gender,
                        userId: _editedUser.userId,
                      ),
                    ),
                    TextFormField(
                      initialValue: _initValues["lName"] as String,
                      decoration: InputDecoration(labelText: 'Last Name'),
                      textInputAction: TextInputAction.next,
                      focusNode: _lName,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_email);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (newValue) => _editedUser = User(
                        fName: _editedUser.fName,
                        lName: newValue,
                        email: _editedUser.email,
                        religion: _editedUser.religion,
                        dob: _editedUser.dob,
                        gender: _editedUser.gender,
                        userId: _editedUser.userId,
                      ),
                    ),
                    TextFormField(
                      initialValue: _initValues["email"] as String,
                      decoration: InputDecoration(labelText: 'Email ID'),
                      textInputAction: TextInputAction.next,
                      focusNode: _email,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_relegion);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value.';
                        }
                        if (!EmailValidator.validate(value)) {
                          return "Enter Valid Email";
                        }
                        return null;
                      },
                      onSaved: (newValue) => _editedUser = User(
                        fName: _editedUser.fName,
                        lName: _editedUser.lName,
                        email: newValue,
                        religion: _editedUser.religion,
                        dob: _editedUser.dob,
                        gender: _editedUser.gender,
                        userId: _editedUser.userId,
                      ),
                    ),
                    TextFormField(
                      initialValue: _initValues["relegion"] == null
                          ? ""
                          : _initValues["relegion"] as String,
                      decoration: InputDecoration(labelText: 'Relegion'),
                      textInputAction: TextInputAction.next,
                      focusNode: _relegion,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (newValue) => _editedUser = User(
                        fName: _editedUser.fName,
                        lName: _editedUser.lName,
                        email: _editedUser.email,
                        religion: newValue,
                        dob: _editedUser.dob,
                        gender: _editedUser.gender,
                        userId: _editedUser.userId,
                      ),
                    ),
                    // TextFormField(
                    //   initialValue: _initValues["dob"],
                    //   decoration: InputDecoration(labelText: 'Date of Birth'),
                    //   textInputAction: TextInputAction.next,
                    //   keyboardType: TextInputType.datetime,
                    //   focusNode: _dob,
                    //   onFieldSubmitted: (_) {
                    //     FocusScope.of(context).requestFocus(_gender);
                    //   },
                    //   validator: (value) {
                    //     if (value!.isEmpty) {
                    //       return 'Please provide a value.';
                    //     }

                    //     return null;
                    //   },
                    //   onSaved: (newValue) => _editedUser = User(
                    //     fName: _editedUser.fName,
                    //     lName: _editedUser.lName,
                    //     email: _editedUser.email,
                    //     religion: _editedUser.religion,
                    //     dob: newValue as String,
                    //     gender: _editedUser.gender,
                    //     userId: _editedUser.userId,
                    //   ),
                    // ),
                    ElevatedButton(
                      onPressed: () {
                        _selectDate(context);
                      },
                      child: Text("Select New Date"),
                    ),
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
                  ],
                ),
              ),
            ),
    );
  }
}
