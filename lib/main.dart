import 'package:cupid_knot/screens/edit_profile.dart';
import 'package:cupid_knot/screens/tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/models/auth.dart';
import '/screens/Login.dart';
import '/screens/Register.dart';
import '/screens/splash_screen.dart';
import 'models/Users.dart';

void main() => runApp(MyApp());

Map<int, Color> color = {
  50: Color.fromRGBO(249, 202, 36, .1),
  100: Color.fromRGBO(249, 202, 36, .2),
  200: Color.fromRGBO(249, 202, 36, .3),
  300: Color.fromRGBO(249, 202, 36, .4),
  400: Color.fromRGBO(249, 202, 36, .5),
  500: Color.fromRGBO(249, 202, 36, .6),
  600: Color.fromRGBO(249, 202, 36, .7),
  700: Color.fromRGBO(249, 202, 36, .8),
  800: Color.fromRGBO(249, 202, 36, .9),
  900: Color.fromRGBO(249, 202, 36, 1),
};

MaterialColor colorCustom = MaterialColor(0xFFf9ca24, color);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Users>(
          create: (ctx) => Users(),
          update: (ctx, auth, previousUsers) => Users(
            authToken: auth.token,
            users: previousUsers == null ? [] : previousUsers.usersCopy,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'Cupid Knot',
          theme: ThemeData(
            primarySwatch: colorCustom,
            accentColor: Colors.deepOrangeAccent[200],
          ),
          home: auth.isAuth
              ? Home()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : Login(),
                ),
          routes: {
            Login.routeName: (ctx) => Login(),
            Register.routeName: (ctx) => Register(),
            EditProfile.routeName: (ctx) => EditProfile(),
          },
        ),
      ),
    );
  }
}
