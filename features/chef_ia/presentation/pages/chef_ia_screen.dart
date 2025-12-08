import 'package:bienestar_integral_app/features/chef_ia/presentation/widgets/ingredients_input_card.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';

class ChefIaScreen extends StatelessWidget {
  const ChefIaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HomeAppBar(title: 'Chef IA', showBackButton: true),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: IngredientsInputCard(),
        ),
      ),
    );
  }
}