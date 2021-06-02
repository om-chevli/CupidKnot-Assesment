import 'package:cupid_knot/models/User.dart';
import 'package:cupid_knot/models/Users.dart';
import 'package:cupid_knot/screens/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<Users>(context, listen: false).viewProfile(),
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (dataSnapshot.error != null) {
            return Center(
              child: Text('An error occurred!'),
            );
          } else {
            return Consumer<Users>(builder: (ctx, userData, child) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Name",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            userData.profileCopy.name as String,
                            style: TextStyle(
                              fontSize: 28,
                              fontStyle: FontStyle.italic,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Date of Birth",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${userData.profileCopy.dob!.day}/${userData.profileCopy.dob!.month}/${userData.profileCopy.dob!.year}",
                            softWrap: true,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                              fontSize: 28,
                              fontStyle: FontStyle.italic,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Gender",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            userData.profileCopy.gender == ""
                                ? "Not Specified"
                                : userData.profileCopy.gender,
                            style: TextStyle(
                              fontSize: 28,
                              fontStyle: FontStyle.italic,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Religion",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            userData.profileCopy.religion == null
                                ? "Not Specified"
                                : userData.profileCopy.religion.toString(),
                            style: TextStyle(
                              fontSize: 28,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Email",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            userData.profileCopy.email == null
                                ? ""
                                : userData.profileCopy.email.toString(),
                            style: TextStyle(
                              fontSize: 28,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                      ElevatedButton.icon(
                        icon: Icon(Icons.edit),
                        onPressed: () => Navigator.of(context).pushNamed(
                          EditProfile.routeName,
                          arguments: userData.profileCopy.userId,
                        ),
                        label: Text("Edit"),
                      ),
                    ],
                  ),
                ),
              );
            });
          }
        }
      },
    );
  }
}
