import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:subscription/screens/homepage.dart';

class SignInDemo extends StatefulWidget {
  @override
  State createState() => SignInDemoState();
}

class SignInDemoState extends State<SignInDemo> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final Logger _logger = Logger();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _handleSignInWithGoogle(BuildContext context) async {
    try {
      await _googleSignIn.signIn();

      if (_googleSignIn.currentUser != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        _logger.e('User is not signed in with Google.');
      }
    } catch (error) {
      _logger.e('Error during Google Sign In: $error');
    }
  }

  Future<void> _handleSignInWithEmailAndPassword(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100], // Set the background color here
      appBar: AppBar(
        title: const Text('Sign In'),
        backgroundColor:
            const Color.fromRGBO(135, 206, 250, 1.0), // Sky blue with value 110
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _handleSignInWithEmailAndPassword(context);
              },
              child: const Text('Sign in with Email/Password'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await _handleSignInWithGoogle(context);
              },
              child: const Text('Sign in with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
