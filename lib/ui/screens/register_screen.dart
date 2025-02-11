import 'package:evently_c13/auth/firebase_auth_services.dart';
import 'package:evently_c13/core/app_assets.dart';
import 'package:evently_c13/core/app_colors.dart';
import 'package:evently_c13/core/validation_utils.dart';
import 'package:evently_c13/providers/AuthProvider.dart';
import 'package:evently_c13/ui/screens/HomeScreen.dart';
import 'package:evently_c13/ui/screens/login_screen.dart';
import 'package:evently_c13/ui/widgets/language_switcher.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:evently_c13/core/dialog_utils.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = "RegisterScreen";

  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var formKey = GlobalKey<FormState>();

  var nameController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var rePasswordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Register",
          style: TextStyle(color: AppColors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              Image.asset(
                AppAssets.appVerticalLogoImage,
                height: MediaQuery.sizeOf(context).height * .22,
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: nameController,
                style: Theme.of(context).textTheme.bodyLarge,
                cursorColor: Theme.of(context).primaryColor,
                validator: (text) {
                  if (text == null || text.trim().isEmpty) {
                    return "Please enter your Name"; // error not valid
                  }
                  return null; // this field is valid
                },
                decoration: const InputDecoration(
                    prefixIcon: Icon(EvaIcons.person), hintText: "Name"),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: emailController,
                style: Theme.of(context).textTheme.bodyLarge,
                cursorColor: Theme.of(context).primaryColor,
                validator: (text) {
                  if (text == null || text.trim().isEmpty) {
                    return "Please enter your Email"; // error not valid
                  }
                  if (!ValidationUtils.isValidEmail(text)) {
                    return "Please enter a valid email";
                  }
                },
                decoration: const InputDecoration(
                    prefixIcon: Icon(EvaIcons.email), hintText: "Email"),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: passwordController,
                style: Theme.of(context).textTheme.bodyLarge,
                cursorColor: Theme.of(context).primaryColor,
                validator: (text) {
                  if (text == null || text.trim().isEmpty) {
                    return "please enter passowrd";
                  }
                  if (text.length < 6) {
                    return "password should at least 6 chars";
                  }
                  return null;
                },
                obscureText: true,
                decoration: const InputDecoration(
                    prefixIcon: Icon(EvaIcons.lock), hintText: "Password"),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: rePasswordController,
                style: Theme.of(context).textTheme.bodyLarge,
                cursorColor: Theme.of(context).primaryColor,
                obscureText: true,
                validator: (text) {
                  // must be equals to password
                  if (text == null || text.trim().isEmpty) {
                    return "please enter password confirmation";
                  }
                  if (text.length < 6) {
                    return "password should at least 6 chars";
                  }
                  if (passwordController.text != text) {
                    return "password doesn't match";
                  }
                },
                decoration: const InputDecoration(
                    prefixIcon: Icon(EvaIcons.lock), hintText: "Re Password"),
              ),
              const SizedBox(
                height: 15,
              ),
              FilledButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          createAccount();
                        },
                  child: !isLoading
                      ? const Text("Create Account")
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(
                              width: 12,
                            ),
                            Text("Loading...")
                          ],
                        )),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Already Have Account ? ",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const Text(
                    "Login",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LanguageSwitcher(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void createAccount() async {
    if (formKey.currentState?.validate() == false) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    // show Loading
    // register with firebase auth service
    var response = await FirebaseAuthServices.createAccount(
        emailController.text, passwordController.text, nameController.text);
    setState(() {
      isLoading = false;
    });
    if (response.error != null) {
      // show error message
      showMessageDialog(
        response.error?.errorMessage ?? "",
        posActionTitle: "ok",
      );
    } else if (response.userCredential != null) {
      // show register success message
      var authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.saveUser(response.user);
      showMessageDialog("Successful registration", posActionTitle: "ok",
          posAction: () {
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      });
    }
  }
}
