import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool automaticallyImplyLeading;
  final Widget? leftIcon;
  final String? routeName;
  final Color? backgroundColor;
  final TextStyle? titleTextStyle;
  final List<Widget>? action;

  const MyAppBar({
    super.key,
    this.title,
    required this.automaticallyImplyLeading,
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
        automaticallyImplyLeading: automaticallyImplyLeading,
        leading: automaticallyImplyLeading
            ? leftIcon ??
                IconButton(
                  onPressed: () {
                    routeName == null
                        ? Navigator.of(context).pop()
                        : Navigator.of(context)
                            .pushReplacementNamed(routeName!);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Theme.of(context).colorScheme.outline,
                    size: 16,
                  ),
                )
            : null,
        backgroundColor:
            backgroundColor ?? Theme.of(context).appBarTheme.backgroundColor,
        title: Text(title ?? ""),
        titleTextStyle: titleTextStyle ??
            Theme.of(context).textTheme.displayMedium!.copyWith(
                  fontWeight: FontWeight.normal,
                ),
        actions: action,
      ),
    );
  }
}
