import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gtk_flutter/home_page.dart';
import 'package:gtk_flutter/login.dart';
import 'package:gtk_flutter/src/widgets.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void SignUserUp() async {
    try {
      //check if passwords match
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Passwords do not match. Please try again.'),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      print(e);
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
              SizedBox(height: 40),
              //logo
              Icon(
                Icons.lock,
                size: 100,
              ),
              SizedBox(height: 40),

              //welcome text
              Text('Get Started with Reunion',
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
              const SizedBox(height: 10),

              MyTextField(
                controller: confirmPasswordController,
                hintText: 'Confirm Password',
                obscureText: true,
              ),
              const SizedBox(height: 10),

              //forgot password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
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
                onTap: SignUserUp,
                buttonText: 'SignUp',
              ),
              // or continue with google
              SizedBox(height: 10),

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
              SizedBox(height: 15),
              //google sign in button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
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
                ],
              ),

              const SizedBox(height: 15),
              // not a member, register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already a member? ',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      )),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: Text('Login here',
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
