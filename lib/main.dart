// keytool -list -v -keystore "C:\Users\Aaditya\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'utils/routes/route.dart';
import 'utils/routes/route_names.dart';
import 'view-models/auth_view_model.dart';
import 'view-models/firebase_auth_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FirebaseAuthViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ],
      child: const MaterialApp(
        title: 'Texi Driver App',
        // theme: MyThemes.lightTheme(),
        // home: const LoginView(),
        debugShowCheckedModeBanner: false,
        initialRoute: RouteNames.splash,
        onGenerateRoute: Routes.onGenerateRoutes,
      ),
    );
  }
}
