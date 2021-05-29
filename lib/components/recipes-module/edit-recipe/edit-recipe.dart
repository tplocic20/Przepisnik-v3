import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:przepisnik_v3/components/recipes-module/edit-recipe/forms/main-form.dart';
import 'package:przepisnik_v3/components/shared/flat-bordered-card.dart';

import 'forms/categories-form.dart';

class EditRecipe extends StatefulWidget {

  @override
  _EditRecipeState createState() => _EditRecipeState();

}

class _EditRecipeState extends State<EditRecipe> {
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;

  tapped(int step){
    setState(() => _currentStep = step);
  }

  continued() {
    if (_currentStep < 2) {
      setState(() => _currentStep += 1);
    }
  }

  cancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Stepper(
                type: stepperType,
                physics: ScrollPhysics(),
                currentStep: _currentStep,
                onStepTapped: (step) => tapped(step),
                onStepContinue:  continued,
                onStepCancel: cancel,
                controlsBuilder: (BuildContext context,
                    {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      _currentStep > 0 ? TextButton(
                        onPressed: onStepCancel,
                        style: TextButton.styleFrom(
                            primary: Theme.of(context).accentColor
                        ),
                        child: const Text('Wstecz'),
                      ) : Container(),
                      ElevatedButton(
                        onPressed: onStepContinue,
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor
                        ),
                        child: const Text('Dalej'),
                      ),
                    ],
                  );
                },
                steps: <Step>[
                  Step(
                    title: const Text('Główne'),
                    content: MainRecipeForm(),
                    subtitle: const Text('Elo'),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 0 ?
                    StepState.complete : StepState.disabled,
                  ),
                  Step(
                    title: const Text('Kategorie'),
                    content: CategoriesForm(),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 1 ?
                    StepState.complete : StepState.disabled,
                  ),
                  Step(
                    title: new Text('Składniki'),
                    content: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Home Address'),
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Postcode'),
                        ),
                      ],
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 2 ?
                    StepState.complete : StepState.disabled,
                  ),
                  Step(
                    title: const Text('Przepis'),
                    content: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Mobile Number'),
                        ),
                      ],
                    ),
                    isActive:_currentStep >= 0,
                    state: _currentStep >= 3 ?
                    StepState.complete : StepState.disabled,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}