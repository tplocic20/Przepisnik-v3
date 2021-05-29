import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class MainRecipeForm extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  Widget _iconWrapper(child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 25,
          width: 25,
          margin: EdgeInsets.all(5),
          child: child,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 50),
      child: FormBuilder(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FormBuilderTextField(
              name: 'title',
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormBuilderValidators.required(context,
                  errorText: 'Proszę podać nazwę'),
              decoration: InputDecoration(
                  labelText: 'Nazwa',
                  hintText: 'Podaj nazwę przepisu',
                  prefixIcon: this._iconWrapper(Icon(Icons.edit_outlined)),
                  suffixIcon: this._iconWrapper(CircularProgressIndicator(
                    strokeWidth: 2.0,
                  ))),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: FormBuilderTextField(
                  name: 'temperature',
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.numeric(context,
                        errorText: 'Temperatura musi buć liczbą'),
                    FormBuilderValidators.min(context, 0,
                        errorText: 'Temperatura nie może być mmniejsza niż 0'),
                    FormBuilderValidators.max(context, 350,
                        errorText: 'Temperatura nie może być większa niż 350'),
                  ]),
                  decoration: InputDecoration(
                    labelText: 'Temperatura',
                    prefixIcon: this._iconWrapper(Icon(Icons.ac_unit_rounded)),
                  )),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: FormBuilderTextField(
                  name: 'time',
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: FormBuilderValidators.numeric(context),
                  decoration: InputDecoration(
                    labelText: 'Czas gotowania',
                    prefixIcon: this._iconWrapper(Icon(Icons.timer_rounded)),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
