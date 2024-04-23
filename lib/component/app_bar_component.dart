import 'package:flutter/material.dart';

class AppBarCom extends StatelessWidget implements PreferredSizeWidget {
  final String? appBarTitle;
  final bool leading;
  final Widget? leftIcon;
  final String? routeName;
  final Color? backgroundColor;
  final Color? textColor;
  final List<Widget>? action;

  const AppBarCom({
    super.key,
    this.appBarTitle,
    required this.leading,
    this.leftIcon,
    this.backgroundColor,
    this.textColor,
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
                  icon: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.arrow_back_ios_outlined,
                      size: 16,
                    ),
                  ),
                )
            : null,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.outline),
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(appBarTitle ?? ""),
        titleTextStyle: Theme.of(context).textTheme.titleMedium,
        elevation: 4, //like z-index in css
        actions: action,
      ),
    );
  }
}
