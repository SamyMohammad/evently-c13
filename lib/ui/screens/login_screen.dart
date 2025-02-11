import 'package:evently_c13/auth/firebase_auth_services.dart';
import 'package:evently_c13/core/app_assets.dart';
import 'package:evently_c13/core/validation_utils.dart';
import 'package:evently_c13/providers/AuthProvider.dart';
import 'package:evently_c13/ui/screens/HomeScreen.dart';
import 'package:evently_c13/ui/screens/forget_password.dart';
import 'package:evently_c13/ui/screens/register_screen.dart';
import 'package:evently_c13/ui/widgets/language_switcher.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:evently_c13/l10n/app_translations.dart';
import 'package:evently_c13/core/dialog_utils.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "/LoginScreen";

  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formKey = GlobalKey<FormState>();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  AppAssets.appVerticalLogoImage,
                  height: MediaQuery.sizeOf(context).height * .22,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: emailController,
                  validator: (text) {
                    if (text == null || text.trim().isEmpty) {
                      return "Please enter your Email"; // error not valid
                    }
                    if (!ValidationUtils.isValidEmail(text)) {
                      return "Please enter a valid email";
                    }
                  },
                  style: Theme.of(context).textTheme.bodyLarge,
                  cursorColor: Theme.of(context).primaryColor,
                  decoration: InputDecoration(
                      prefixIcon: Icon(EvaIcons.email),
                      hintText: getTranslations(context).email),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  validator: (text) {
                    if (text == null || text.trim().isEmpty) {
                      return "please enter passowrd";
                    }
                    if (text.length < 6) {
                      return "password should at least 6 chars";
                    }
                    return null;
                  },
                  style: Theme.of(context).textTheme.bodyLarge,
                  cursorColor: Theme.of(context).primaryColor,
                  decoration: InputDecoration(
                      prefixIcon: Icon(EvaIcons.lock),
                      hintText: getTranslations(context).password),
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(ForgetPassword.routeName);
                        },
                        child: Text(getTranslations(context).forget_passwort))),
                const SizedBox(
                  height: 10,
                ),
                FilledButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            login();
                          },
                    child: !isLoading
                        ? Text(getTranslations(context).login)
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
                      getTranslations(context).dont_have_account,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(RegisterScreen.routeName);
                      },
                      child: Text(
                        getTranslations(context).create_account,
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(getTranslations(context).or),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                              color: Theme.of(context).primaryColor))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Brand(Brands.google),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(getTranslations(context).login_with_google)
                    ],
                  ),
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
      ),
    );
  }

  void login() async {
    if (formKey.currentState?.validate() == false) {
      print("not valid");
      return;
    }
    setState(() {
      isLoading = true;
    });

    var response = await FirebaseAuthServices.login(
        emailController.text, passwordController.text);
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.saveUser(response.user);
    setState(() {
      isLoading = false;
    });
    if (response.userCredential != null) {
      showMessageDialog("logged in successfully", posActionTitle: "ok",
          posAction: () {
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      });
    } else {
      showMessageDialog(response.error?.errorMessage ?? "",
          posActionTitle: "ok", posAction: () {
        // Navigator.pushNamed(context, HomeScreen.routeName);
      });
    }
  }
}
