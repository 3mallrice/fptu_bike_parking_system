import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  static const String serverClientID =
      "602350701185-o7eo5nohpanetqev16aia11s84htg8v6.apps.googleusercontent.com";

  static const List<String> scope = [
    'email',
    'profile',
    'https://www.googleapis.com/auth/contacts.readonly',
  ];

  static final _googleSignIn = GoogleSignIn(
    scopes: scope,
    serverClientId: serverClientID,
  );

  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();

  static Future<bool> isSignedIn() async {
    return _googleSignIn.isSignedIn();
  }

  static Future<GoogleSignInAccount?> currentUser() async {
    return _googleSignIn.currentUser;
  }

  static Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  // get google token
  Future<GoogleSignInAuthentication?> getGoogleSignInAuthentication() async {
    final user = _googleSignIn.currentUser;
    final auth = await user?.authentication;
    return auth;
  }
}
