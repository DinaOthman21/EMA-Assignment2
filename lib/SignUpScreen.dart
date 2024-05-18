import 'package:flutter/material.dart';
import 'package:assignment2/JSON/user.dart';
import 'package:assignment2/SQLite/database_helper.dart';
import 'package:assignment2/provider/store_provider.dart';
import 'package:assignment2/signin.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign Up Page',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        toolbarHeight: 85,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 3, right: 15),
          child: Column(
            children: [
              SignUpForm(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(color: Colors.black),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirm = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final db = DatabaseHelper.instance;

  String? gender;

  void updateGender(String? value) {
    setState(() {
      gender = value;
    });
  }

  bool showPasswordIcon = false;
  bool showConfirmPasswordIcon = false;

  void showPassword() {
    setState(() {
      showPasswordIcon = true;
    });
  }

  void showConfirmPassword() {
    setState(() {
      showConfirmPasswordIcon = true;
    });
  }

  signup() async {
    var res = await db.createUser(User(
      userName: name.text,
      userEmail: email.text,
      password: password.text,
      phoneNumber: phoneNumber.text

    ));
    if (res > 0) {
      final userId = res;
      await Provider.of<StoreProvider>(context, listen: false)
          .fetchFavoriteStores(userId);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      _showFailureDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: name,
            decoration: const InputDecoration(
              labelText: 'Name',
              labelStyle: TextStyle(
                color: Colors.black87,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please Enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: email,
            decoration: const InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(
                color: Colors.black87,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please Enter your email';
              } else if (!_isValidEmail(value)) {
                return 'Please Enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: phoneNumber,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              labelStyle: TextStyle(
                color: Colors.black87,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please Enter your phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              const Text('Gender: '),
              Radio<String>(
                value: 'Male',
                groupValue: gender,
                onChanged: updateGender,
              ),
              const Text('Male'),
              Radio<String>(
                value: 'Female',
                groupValue: gender,
                onChanged: updateGender,
              ),
              const Text('Female'),
            ],
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: password,
            obscureText: !showPasswordIcon,
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(
                color: Colors.black87,
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    showPasswordIcon = !showPasswordIcon;
                  });
                },
                child: Icon(
                  showPasswordIcon ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please Enter a password';
              } else if (value.length < 8) {
                return 'Password must be at least 8 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: confirm,
            obscureText: !showConfirmPasswordIcon,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              labelStyle: TextStyle(
                color: Colors.black87,
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    showConfirmPasswordIcon = !showConfirmPasswordIcon;
                  });
                },
                child: Icon(
                  showConfirmPasswordIcon ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              } else if (value.length < 8) {
                return 'Confirm Password must be at least 8 characters';
              } else if (value != password.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 15.0),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                signup();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: const Text(
              'Sign Up',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isValidEmail(String email) {
    RegExp emailPattern = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailPattern.hasMatch(email);
  }

  void _showFailureDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Failure"),
          content: const Text("Failed to sign up!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignUpScreen(),
    );
  }
}