import 'package:evently_c13/core/app_colors.dart';
import 'package:flutter/material.dart';

class SelectionWidget extends StatelessWidget {
  final Widget title;
  final IconData prefixIcon;
  final bool? isSuffixIcon;
  const SelectionWidget(
      {super.key,
      required this.title,
      required this.prefixIcon,
      this.isSuffixIcon = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.purple),
      ),
      child: Row(spacing: 8, children: [
        Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.purple,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              prefixIcon,
              color: AppColors.white,
            )),
        title,
        const Spacer(),
        if (isSuffixIcon == true)
          const Icon(
            Icons.arrow_forward_ios,
            color: AppColors.purple,
          )
      ]),
    );
  }
}
