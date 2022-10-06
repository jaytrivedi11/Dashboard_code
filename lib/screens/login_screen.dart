import 'package:admin/screens/DefaultScreen.dart';
import 'package:admin/screens/dashboard_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../controllers/MenuController.dart';
import '../network/ApiService.dart';
import '../responsive.dart';
import 'dashboard/components/header.dart';
import 'dashboard/components/recent_files.dart';
import 'dashboard/components/storage_details.dart';
import 'dashboard/dashboard_screen.dart';
import 'main/components/side_menu.dart';
import 'main/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  var email ="";
  var pass = "";

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      key: context.read<MenuController>().scaffoldKey,
      drawer: SideMenu(),
      body:Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment:
          size.width > 600 ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
           Container()
                ,
            SizedBox(
              height: size.height * 0.03,
            ),
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Image.asset("assets/images/logo.png")
              ),
              width: size.width*0.3,
              height: size.height*0.3,

            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 20.0),
            //   child: Text(
            //     'Login',
            //     style: kLoginTitleStyle(size),
            //   ),
            // ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Gujarat Police',
              style: kLoginTitleStyle(size),
            ),

            SizedBox(
              height: size.height * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    /// username or Gmail
                    SizedBox(
                      child: TextFormField(
                        style: kTextFormFieldStyle(),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          hintText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                        onChanged: (value){
                          email=value;
                        },
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter username';
                          } else if (value.length < 4) {
                            return 'at least enter 4 characters';
                          } else if (!EmailValidator.validate(value)) {
                            return 'Enter valid email';
                          }
                          return null;
                        },
                      ),
                      width: size.width*0.5,
                    ),
                    // SizedBox(
                    //   height: size.height * 0.02,
                    // ),
                    // TextFormField(
                    //   controller: emailController,
                    //   decoration: const InputDecoration(
                    //     prefixIcon: Icon(Icons.email_rounded),
                    //     hintText: 'gmail',
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.all(Radius.circular(15)),
                    //     ),
                    //   ),
                    //   // The validator receives the text that the user has entered.
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return 'Please enter gmail';
                    //     } else if (!value.endsWith('@gmail.com')) {
                    //       return 'please enter valid gmail';
                    //     }
                    //     return null;
                    //   },
                    // ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),

                    /// password
                     SizedBox(
                       width: size.width*0.5,
                       child: TextFormField(
                          style: kTextFormFieldStyle(),
                          obscureText: _isObscure,
                          onChanged: (value){
                            pass=value;
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_open),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isObscure ? Icons.visibility : Icons.visibility_off,

                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                            ),
                            hintText: 'Password',
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                          ),
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            } else if (value.length < 5) {
                              return 'at least enter 6 characters';
                            } else if (value.length > 13) {
                              return 'maximum character is 13';
                            }
                            return null;
                          },
                        ),
                     ),

                    SizedBox(
                      height: size.height * 0.01,
                    ),

                    SizedBox(
                      height: size.height * 0.02,
                    ),

                    /// Login Button
                    loginButton(size),
                    SizedBox(
                      height: size.height * 0.03,
                    ),

                    /// Navigate To Login Screen
                    // GestureDetector(
                    //   onTap: () {
                    //     Navigator.pop(context);
                    //     _formKey.currentState?.reset();
                    //   },
                    //   child: RichText(
                    //     text: TextSpan(
                    //       text: 'Don\'t have an account?',
                    //       style: kHaveAnAccountStyle(size),
                    //       children: [
                    //         TextSpan(
                    //           text: " Sign up",
                    //           style: kLoginOrSignUpTextStyle(
                    //             size,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),

      )
    );
      }
  Widget loginButton(Size size) {
    return SizedBox(
      width: size.width*0.5,
      height: 55,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        onPressed: () async{
          // Validate returns true if the form is valid, or false otherwise.
          if (_formKey.currentState!.validate()) {
            // ... Navigate To your Home Page
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return Center(
                  child: Container(
                    height: 80,
                    width: 80,
                    child: const CircularProgressIndicator(
                      strokeWidth: 1,
                    ),
                  ),
                );
              },
            );
            SharedPreferences prefs = await SharedPreferences.getInstance();
            var result = await ApiService().login(email, pass);



            if (result) {
              prefs.setString("email", email);
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(
                      builder: (ctx) =>  MultiProvider(
                        providers: [
                          ChangeNotifierProvider(
                            create: (context) => MenuController(),
                          ),
                        ],
                        child:
                             DefaultScreen()

                      ),));
            } else {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(
                       content: Text("Failed please try again"),
              ));
            }

          }
        },
        child: const Text('Login'),
      ),
    );
  }
}
