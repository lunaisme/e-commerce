import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app_with_flutter/src/presentation/screens/export_screens.dart';
import 'package:ecommerce_app_with_flutter/src/services/auth_provider.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWrapper(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => Home(),
        '/profile': (context) => ProfilePage(),
        '/personal-data': (context) => PersonalDataScreen(),
        '/about': (context) => AboutScreenPage(),
        '/time-converter': (context) => TimeConverterPage(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.isAuthenticated) {
          return const Home();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
