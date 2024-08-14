import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/api/service/bai_be/auth_service.dart';
import 'package:fptu_bike_parking_system/component/shadow_container.dart';
import 'package:fptu_bike_parking_system/core/helper/asset_helper.dart';
import 'package:fptu_bike_parking_system/representation/navigation_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

import '../api/model/bai_model/login_model.dart';
import '../component/snackbar.dart';
import '../core/const/frondend/message.dart';
import '../core/helper/google_auth.dart';
import '../core/helper/loading_overlay_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static String routeName = '/login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static final log = Logger();
  final _authApi = CallAuthApi();

  Future<bool> signIn() async {
    // show loading
    LoadingOverlayHelper.show(context);

    // logout before login
    GoogleAuthApi.signOut();

    var currentUser = await GoogleAuthApi.login();
    GoogleSignInAuthentication? auth = await currentUser?.authentication;

    log.i("currentUser: $currentUser" "\nidToken: ${auth?.idToken}");

    if (currentUser != null && auth != null && auth.idToken != null) {
      UserData? userData = await _authApi.loginWithGoogle(auth.idToken!);
      if (userData != null) {
        // hide loading
        LoadingOverlayHelper.hide();

        goToPageHelper(routeName: MyNavigationBar.routeName);
        return true;
      }
      GoogleAuthApi.signOut();
    }

    // hide loading
    LoadingOverlayHelper.hide();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).colorScheme.surface;
    Color onSuccessful = Theme.of(context).colorScheme.onError;
    Color onUnsuccessful = Theme.of(context).colorScheme.error;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.27),
                    Image.asset(
                      AssetHelper.imgLogo,
                      width: 200,
                      height: 200,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                    //Welcome
                    Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        'Welcome!',
                        style:
                            Theme.of(context).textTheme.displayLarge!.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 40,
                                ),
                        textAlign: TextAlign.left,
                      ),
                    ),

                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.005),

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

                    SizedBox(height: MediaQuery.of(context).size.height * 0.06),

                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                        'By signing in, you agree to our Terms of Service and Privacy Policy.',
                        style: Theme.of(context).textTheme.labelSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                    //Continue with Google
                    GestureDetector(
                      onTap: () async {
                        bool isLogin = await signIn();
                        // check login successfully or not
                        isLogin
                            ? showCustomSnackBar(
                                // login successfully
                                MySnackBar(
                                  prefix: Icon(
                                    Icons.check_circle_rounded,
                                    color: backgroundColor,
                                  ),
                                  message: Message.loginSuccess,
                                  backgroundColor: onSuccessful,
                                ),
                              )
                            : showCustomSnackBar(
                                // login failed
                                MySnackBar(
                                  prefix: Icon(
                                    Icons.cancel_rounded,
                                    color: backgroundColor,
                                  ),
                                  message: ErrorMessage.loginFailed,
                                  backgroundColor: onUnsuccessful,
                                ),
                              );
                      },
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
                                width:
                                    MediaQuery.of(context).size.width * 0.03),
                            Text(
                              'Continue with Google',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.surface,
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
      ),
    );
  }

  // show custom snackbar
  void showCustomSnackBar(MySnackBar snackBar) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: snackBar,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: const EdgeInsets.all(10),
      ),
    );
  }

  void goToPageHelper({String? routeName}) {
    routeName == null
        ? Navigator.of(context).pop()
        : Navigator.of(context).pushNamed(routeName);
  }
}
