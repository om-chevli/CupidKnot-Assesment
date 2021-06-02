import 'package:cupid_knot/widgets/user_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/Users.dart';

class UsersList extends StatefulWidget {
  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  final List<String> imgList = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<Users>(context, listen: false).fetchUsers(),
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
              print(userData.usersCopy.length);
              return ListView.builder(
                itemBuilder: (ctx, i) => UserDetail(userData.users![i]),
                itemCount: userData.usersCopy.length,
              );
            });
          }
        }
      },
    );
  }
}
