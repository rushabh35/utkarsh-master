import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isNGO = false; // A boolean to determine if the user is an NGO.

  // Function to handle the registration process.
  void _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text);
        // After successful registration, you can add custom logic based on the user type.
        // Here, we'll assume you have an 'isNGO' field in the user profile.

        await userCredential.user!.updateProfile(displayName: _isNGO ? 'NGO' : 'User');

        // You can store additional user data in Firebase Firestore or Realtime Database.

        // Redirect to the dashboard or login page.
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
        // Handle other FirebaseAuthException errors.
      } catch (e) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an email.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a password.';
                  }
                  return null;
                },
              ),
              Row(
                children: <Widget>[
                  Text('Are you an NGO?'),
                  Checkbox(
                    value: _isNGO,
                    onChanged: (bool? value) { // Change the parameter type to bool?
                      setState(() {
                        _isNGO = value ?? false; // Use the value with a null check
                      });
                    },
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _register,
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
