import 'package:bai_system/api/model/bai_model/api_response.dart';
import 'package:bai_system/api/service/bai_be/auth_service.dart';
import 'package:bai_system/component/dialog.dart';
import 'package:bai_system/component/response_handler.dart';
import 'package:bai_system/component/shadow_container.dart';
import 'package:bai_system/core/const/frontend/error_catcher.dart';
import 'package:bai_system/core/helper/asset_helper.dart';
import 'package:bai_system/core/helper/local_storage_helper.dart';
import 'package:bai_system/representation/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

import '../api/model/bai_model/login_model.dart';
import '../api/service/bai_be/firebase_api.dart';
import '../component/internet_connection_wrapper.dart';
import '../core/const/frontend/message.dart';
import '../core/helper/google_auth.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login_screen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with ApiResponseHandler {
  static final _log = Logger();
  final _authApi = CallAuthApi();
  bool _isLoading = false;
  Alignment _alignment = const Alignment(0.9, 0.4);

  // Sign in with Google
  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await GoogleAuthApi.signOut();

      final currentUser = await GoogleAuthApi.login();
      final auth = await currentUser?.authentication;

      _log.i("currentUser: $currentUser" "\nidToken: ${auth?.idToken}");

      if (currentUser != null && auth != null && auth.idToken != null) {
        final APIResponse<UserData> userData =
            await _authApi.loginWithGoogle(auth.idToken!);

        if (userData.data != null) {
          await _initializeAfterLogin();
          _navigateToHome();
        } else {
          throw Exception(userData.statusCode);
        }
      } else {
        throw Exception("Login failed: Google authentication failed");
      }
    } catch (e) {
      _log.e("Login error: $e");

      String userFriendlyMessage;
      if (e is Exception &&
          e.toString().contains("Google authentication failed")) {
        userFriendlyMessage = UserFriendErrMess.loginErrMessage(e);
      } else {
        userFriendlyMessage =
            HttpErrorMapper.getErrorMessage(int.parse(e.toString()));
      }

      _showErrorDialog(userFriendlyMessage);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  //send FCM token to server
  Future<void> _sendTokenToServer() async {
    final fcmToken = GetLocalHelper.getFCMToken();

    if (fcmToken != null) {
      final APIResponse<dynamic> response =
          await FirebaseApi().sendTokenToServer(fcmToken);

      if (!mounted) return;

      final bool isResponseValid = await handleApiResponse(
        context: context,
        response: response,
        showErrorDialog: _showErrorDialog,
      );

      if (!isResponseValid) return;

      log.i('FCM token sent to server');
      return;
    } else {
      log.e('FCM token is null');
      return;
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OKDialog(
          title: ErrorMessage.error,
          content: Text(
            message,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        );
      },
    );
  }

  Future<void> _initializeAfterLogin() async {
    await _checkLocationPermission();
    await _sendTokenToServer();
  }

  Future<void> _checkLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacementNamed(MyNavigationBar.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: InternetConnectionWrapper(
        goToPageRouteName: LoginScreen.routeName,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.27),
                    Image.asset(AssetHelper.imgLogo, width: 200, height: 200),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    _buildWelcomeText(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                    _buildTermsText(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    _buildGoogleSignInButton(),
                    _buildFooter(),
                  ],
                ),
              ),
            ),
            Align(
              alignment: _alignment,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _alignment += Alignment(
                      details.delta.dx /
                          (MediaQuery.of(context).size.width / 2),
                      details.delta.dy /
                          (MediaQuery.of(context).size.height / 2),
                    );
                    log.i('Alignment: $_alignment');
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  child: _buildSupportIcon(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportIcon() {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.outline,
      radius: 25,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.headset_mic_rounded,
            size: 28,
            color: Theme.of(context).colorScheme.surface,
          ),
          Text(
            'Support',
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  color: Theme.of(context).colorScheme.surface,
                  fontSize: 7,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeText() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome!',
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontSize: 40,
                ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.005),
          Row(
            children: [
              Text(
                'to',
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                      fontSize: 30,
                      fontWeight: FontWeight.normal,
                    ),
              ),
              Text(
                ' Bai APP',
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTermsText() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Text(
        'By signing in, you agree to our Terms of Service and Privacy Policy.',
        style: Theme.of(context).textTheme.labelSmall,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildGoogleSignInButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _signIn,
      child: ShadowContainer(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.08,
        color: _isLoading
            ? Theme.of(context).disabledColor
            : Theme.of(context).colorScheme.outline,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading)
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.surface),
                ),
              )
            else
              Image.asset(AssetHelper.googleLogo, width: 30, height: 30),
            SizedBox(width: MediaQuery.of(context).size.width * 0.03),
            Text(
              _isLoading ? 'Signing In...' : 'Continue with Google',
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: Theme.of(context).colorScheme.surface,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      alignment: Alignment.center,
      child: Text(
        '© Powered by Bai Parking',
        style: Theme.of(context).textTheme.displaySmall!.copyWith(
              color: Theme.of(context).colorScheme.outline,
              fontSize: 15,
            ),
      ),
    );
  }
}
