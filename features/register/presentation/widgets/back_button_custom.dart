import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BackButtonCustom extends StatelessWidget {
  const BackButtonCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => context.pop(),
      icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onBackground),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }
}