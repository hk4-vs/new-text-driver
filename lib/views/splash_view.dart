import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view-models/auth_view_model.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    // AuthViewModel().signOut();
    Future.delayed(const Duration(seconds: 3)).then((value) {
      Provider.of<AuthViewModel>(context, listen: false)
          .isAlreadyLoggedIn(context: context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Text(
          "Texi Driver App",
          style: Theme.of(context)
              .textTheme
              .headlineLarge!
              .copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
    );
  }
}
