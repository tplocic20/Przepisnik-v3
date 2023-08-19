import 'dart:async';
import 'package:flutter/material.dart';
import 'package:przepisnik_v3/components/recipes-module/single-recipe/single-recipe-container.dart';
import 'package:przepisnik_v3/components/shared/backdrop.dart';
import 'package:przepisnik_v3/components/shared/przepisnik-icon.dart';
import 'package:przepisnik_v3/globals/globals.dart' as globals;
import 'package:przepisnik_v3/models/recipe.dart';
import 'package:rxdart/rxdart.dart';
import 'package:styled_widget/styled_widget.dart';
import 'modals/portion-modal.dart';

class SingleRecipe extends StatefulWidget {
  final Recipe recipe;

  SingleRecipe(this.recipe);

  @override
  _SingleRecipeState createState() => _SingleRecipeState();
}

class _SingleRecipeState extends State<SingleRecipe> {
  double _portion = 1;
  bool _cookMode = false;
  double _currentTextSize = 20;
  StreamController<bool> controller = new BehaviorSubject<bool>();

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildPortionModal() {
      return PortionModal(
        portion: this._portion,
        callback: (value) {
          setState(() {
            _portion = value;
          });
        },
      );
    }

    void _handleCookMode() {
      setState(() {
        this._cookMode = !_cookMode;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Tryb szefa kuchni ${this._cookMode ? 'włączony' : 'wyłączony'}'),
      ));
    }

    Widget _cookModeButton = ElevatedButton.icon(
      icon: PrzepisnikIcon(icon: PrzepisnikIcons.cook, color: Colors.white),
      label: Text('Tryb szefa kuchni'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
      ),
      onPressed: () {
        globals.globalBackdropHandler!();
        controller.add(false);
        _handleCookMode();
      },
    )
        .height(50);

    Widget _cookModeButtonSingle = _cookModeButton
        .width(MediaQuery.of(context).size.width)
        .padding(bottom: 15, horizontal: 15);

    Widget _cookModeButtonDouble = Row(
      children: [
        Expanded(child: _cookModeButton),
        OutlinedButton.icon(
            onPressed: (){
              globals.globalBackdropHandler!();
              setState(() {
                controller.add(true);
              });
            },
            icon: PrzepisnikIcon(icon: PrzepisnikIcons.cook),
            style: OutlinedButton.styleFrom(
              elevation: 1,
              foregroundColor: Colors.white,
              backgroundColor: Color(0x50F46060),
              side: BorderSide(color: Color(0xFFF46060), width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15)))
            ),
            label: Text('Resetuj')).height(50).padding(left: 15),
      ],
    )
        .width(MediaQuery.of(context).size.width)
        .padding(bottom: 15, horizontal: 15);


    Widget _calculatorButton = ElevatedButton.icon(
      icon: PrzepisnikIcon(icon: PrzepisnikIcons.calculator),
      label: Text('Kalkulator składników'),
      style: ElevatedButton.styleFrom(
        elevation: this._cookMode ? 0 : 1.0,
        splashFactory: this._cookMode ? NoSplash.splashFactory : InkRipple.splashFactory,
        backgroundColor: this._cookMode ? Colors.grey : Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
      ),
      onPressed: () {
        if (this._cookMode) {
          return;
        }
        globals.globalBackdropHandler!();
        showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) {
              return _buildPortionModal();
            });
      },
    )
        .height(50)
        .padding(bottom: 14, horizontal: 15)
        .width(MediaQuery.of(context).size.width);

    Widget _fontSlider =         Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Chcionka przepisu',
          style:
          TextStyle(color: Theme.of(context).colorScheme.secondary))
          .padding(left: 25),
      Slider(
        value: _currentTextSize,
        min: 18,
        max: 36,
        divisions: 9,
        activeColor: Theme.of(context).colorScheme.secondary,
        inactiveColor: Theme.of(context).primaryColorDark,
        label: _currentTextSize.round().toString(),
        onChanged: (double value) {
          setState(() {
            _currentTextSize = value;
          });
        },
      )
    ]);

    return Backdrop(
      title: Hero(
        tag: widget.recipe.key,
        child: Text(widget.recipe.name,
            overflow: TextOverflow.fade,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                )),
      ),
      actionButtonLocation: FloatingActionButtonLocation.endFloat,
      backButtonOverride: true,
      frontLayer: SingleRecipeContainer(
        recipe: widget.recipe,
        portion: this._portion,
        cookMode: this._cookMode,
        cookModeReset: this.controller.stream,
        textSize: this._currentTextSize,
      ),
      backLayer: [
        this._cookMode ? _cookModeButtonDouble : _cookModeButtonSingle,
        _calculatorButton,
        _fontSlider
      ],
    );
  }
}
