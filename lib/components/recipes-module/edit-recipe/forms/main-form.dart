import 'package:flutter/material.dart';

class MainRecipeForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Nazwa',
            icon: null
          ),
        )
      ],
    );
  }
}