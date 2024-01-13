import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class Neubox extends StatelessWidget {
  const Neubox({super.key, this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.background,
            boxShadow: [
              BoxShadow(
                color:
                    isDarkMode ? Colors.black.withOpacity(0.5) : Colors.white,
                blurRadius: isDarkMode ? 5 : 15,
                offset: const Offset(-5, -5),
              ),
              BoxShadow(
                color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade500,
                blurRadius: isDarkMode ? 10 : 15,
                offset: const Offset(5, 5),
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: child,
        ));
  }
}
