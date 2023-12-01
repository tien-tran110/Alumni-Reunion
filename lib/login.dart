import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gtk_flutter/services/auth_service.dart';
import 'package:gtk_flutter/signup.dart';
import 'package:gtk_flutter/src/widgets.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void SignUserIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid email or password. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(height: 50),
              //logo
              Icon(
                Icons.lock,
                size: 100,
              ),
              SizedBox(height: 50),

              //welcome text
              Text('Welcome to Reunion',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.grey,
                  )),

              SizedBox(height: 25),
              //username textfield
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),
              SizedBox(height: 10),
              //password textfield
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              //forgot password
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Forgot Password?',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        )),
                  ],
                ),
              ),
              SizedBox(height: 10),
              //sign in button
              MyButton(
                onTap: SignUserIn,
                buttonText: 'Login',
              ),
              // or continue with google
              SizedBox(height: 25),

              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                      indent: 25,
                      endIndent: 25,
                    ),
                  ),
                  Text('or continue with Google',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      )),
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                      indent: 25,
                      endIndent: 25,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              //google sign in button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => AuthService().signInWithGoogle(),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white),
                        color: Colors.grey[200],
                      ),
                      child: Image.asset(
                        'assets/images/google.png',
                        height: 60,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),
              // not a member, register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Not a member? ',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      )),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()));
                    },
                    child: Text('Register Now',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        )),
                  ),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
