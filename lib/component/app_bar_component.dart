import 'package:flutter/material.dart';

class AppBarCom extends StatelessWidget implements PreferredSizeWidget {
  final String? appBarText;
  final bool leading;
  final Widget? leftIcon;
  final String? routeName;
  final Color? backgroundColor;
  final TextStyle? titleTextStyle;
  final List<Widget>? action;

  const AppBarCom({
    super.key,
    this.appBarText,
    required this.leading,
    this.leftIcon,
    this.backgroundColor,
    this.titleTextStyle,
    this.action,
    this.routeName,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppBar(
        automaticallyImplyLeading: leading,
        leading: leading
            ? leftIcon ??
                IconButton(
                  onPressed: () {
                    routeName == null
                        ? Navigator.of(context).pop()
                        : Navigator.of(context)
                            .pushReplacementNamed(routeName!);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16,
                  ),
                )
            : null,
        backgroundColor:
            backgroundColor ?? Theme.of(context).appBarTheme.backgroundColor,
        title: Text(appBarText ?? ""),
        titleTextStyle: titleTextStyle ??
            Theme.of(context).textTheme.displayMedium!.copyWith(
                  fontWeight: FontWeight.normal,
                ),
        actions: action,
      ),
    );
  }
}
