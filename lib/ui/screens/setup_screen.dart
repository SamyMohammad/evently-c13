import 'package:evently_c13/core/app_assets.dart';
import 'package:evently_c13/l10n/app_translations.dart';
import 'package:evently_c13/ui/screens/login_screen.dart';
import 'package:evently_c13/ui/widgets/language_switcher.dart';
import 'package:evently_c13/ui/widgets/theme_switcher.dart';
import 'package:flutter/material.dart';

class SetupScreen extends StatelessWidget {
  static const String routeName = "/setupScreenRoute";
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                AppAssets.appHorizontalLogoImage,
                height: MediaQuery.sizeOf(context).height * .07,
              ),
              const SizedBox(
                height: 10,
              ),
              Image.asset(
                AppAssets.beingCreativeImage,
                // height: MediaQuery.sizeOf(context).height * .07,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                getTranslations(context).setup_screen_title,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                getTranslations(context).setup_screen_descrption,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getTranslations(context).language,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const LanguageSwitcher(),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getTranslations(context).theme,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const ThemeSwitcher(),
                ],
              ),
              const Spacer(),
              FilledButton(onPressed: () {
                Navigator.pushNamed(context, LoginScreen.routeName);
              }, child: Text(getTranslations(context).lets_start))
            ],
          ),
        ),
      ),
    );
  }
}
