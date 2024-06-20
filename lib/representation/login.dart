import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/component/shadow_container.dart';
import 'package:fptu_bike_parking_system/core/helper/asset_helper.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

import '../core/helper/google_signin.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static String routeName = '/login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Logger log = Logger();

  Future signIn() async {
    final currentUser = await GoogleSignInApi.currentUser();
    GoogleSignInAuthentication? authen = await currentUser?.authentication;
    log.i("currentUser: $currentUser" "\nidToken: ${authen?.idToken}");

    if (currentUser == null) {
      final googleUser = await GoogleSignInApi.login();
      log.i(googleUser);
    }

    GoogleSignInAuthentication? auth =
        await GoogleSignInApi().getGoogleSignInAuthentication();
    log.i(auth?.idToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.27,
                  ),
                  Image.asset(
                    AssetHelper.imgLogo,
                    width: 200,
                    height: 200,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),

                  //Welcome
                  Container(
                    alignment: Alignment.centerLeft,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      'Welcome!',
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontSize: 40,
                          ),
                      textAlign: TextAlign.left,
                    ),
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.005,
                  ),

                  //to Bai APP
                  Container(
                    alignment: Alignment.centerLeft,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Row(
                      children: [
                        Text(
                          'to',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.outline,
                                fontSize: 30,
                                fontWeight: FontWeight.normal,
                              ),
                        ),
                        Text(
                          ' Bai APP',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.outline,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),

                  //Continue with Google
                  GestureDetector(
                    onTap: signIn,
                    child: ShadowContainer(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.08,
                      color: Theme.of(context).colorScheme.outline,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AssetHelper.googleLogo,
                            width: 30,
                            height: 30,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.03,
                          ),
                          Text(
                            'Continue with Google',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                alignment: Alignment.center,
                child: Text(
                  '© Powered by Bai Parking',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                        fontSize: 15,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void goToPageHelper({String? routeName}) {
    routeName == null
        ? Navigator.of(context).pop()
        : Navigator.of(context).pushNamed(routeName);
  }
}
