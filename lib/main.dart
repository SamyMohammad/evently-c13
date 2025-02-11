import 'package:evently_c13/core/app_theme.dart';
import 'package:evently_c13/firebase_options.dart';
import 'package:evently_c13/providers/AuthProvider.dart';
import 'package:evently_c13/providers/language_provider.dart';
import 'package:evently_c13/providers/theme_provider.dart';
import 'package:evently_c13/ui/screens/HomeScreen.dart';
import 'package:evently_c13/ui/screens/add_event_screen.dart';
import 'package:evently_c13/ui/screens/forget_password.dart';
import 'package:evently_c13/ui/screens/login_screen.dart';
import 'package:evently_c13/ui/screens/register_screen.dart';
import 'package:evently_c13/ui/screens/setup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await EasyLocalization.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (_) => ThemeProvider(
              sharedPreferences.getBool(ThemeProvider.isLightModeKey) ?? true)),
      ChangeNotifierProvider(create: (_) {
        return LanguageProvider(
            sharedPreferences.getString(LanguageProvider.localeKey));
      }),
      ChangeNotifierProvider(create: (_) => AuthProvider())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    LanguageProvider languageProvider = Provider.of<LanguageProvider>(context);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return MaterialApp(
      // localizationsDelegates: context.localizationDelegates,
      // supportedLocales: context.supportedLocales,
      // locale: context.locale,
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // themeMode: themeProvider.currentTheme,
      initialRoute: authProvider.isLoggedIn()
          ? HomeScreen.routeName
          : SetupScreen.routeName,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(languageProvider.currentLocale),
      routes: {
        AddEventScreen.routeName: (_) => const AddEventScreen(),
        HomeScreen.routeName: (_) => const HomeScreen(),
        SetupScreen.routeName: (_) => const SetupScreen(),
        LoginScreen.routeName: (_) => LoginScreen(),
        RegisterScreen.routeName: (_) => RegisterScreen(),
        ForgetPassword.routeName: (_) => const ForgetPassword()
      },
    );
  }
}
