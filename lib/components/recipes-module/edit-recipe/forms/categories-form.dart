import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:przepisnik_v3/globals/globals.dart' as globals;
import 'package:przepisnik_v3/models/category.dart';

class CategoriesForm extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 50),
      child: FormBuilder(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FormBuilderCheckboxGroup(
                  name: 'categories',
                  orientation: OptionsOrientation.vertical,
                  decoration: InputDecoration(
                    filled: true,
                  ),
                  // validator: FormBuilderValidators.required(context, errorText: 'Proszę wybrać kategorię'),
                  options: globals.categories
                      ?.map((Category cat) =>
                      FormBuilderFieldOption<String>(
                          value: cat.key,
                          child: Text(cat.name)))
                      ?.toList()),
          ],
        ),
      ),
    );
  }
}
