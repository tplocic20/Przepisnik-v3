import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:przepisnik_v3/components/recipes-module/single-recipe/single-recipe-container.dart';
import 'package:przepisnik_v3/components/shared/bottom-modal-wrapper.dart';
import 'package:przepisnik_v3/components/shared/backdrop.dart';
import 'package:przepisnik_v3/models/recipe.dart';
import 'modals/portion-modal.dart';
import 'package:styled_widget/styled_widget.dart';

class SingleRecipe extends StatefulWidget {
  final Recipe recipe;

  SingleRecipe(this.recipe);

  @override
  _SingleRecipeState createState() => _SingleRecipeState();
}

class _SingleRecipeState extends State<SingleRecipe> {
  double _portion = 1;
  double _currentSliderValue = 20;

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

    Widget _buildCookModeModal() {
      return BottomModalWrapper(
        child: Text('test')
      );
    }

    return Backdrop(
      title: Hero(
        tag: widget.recipe.key,
        child: Text(
            widget.recipe.name,
            overflow: TextOverflow.fade,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
            )
        ),
      ),
      actionButtonLocation: FloatingActionButtonLocation.endFloat,
      backButtonOverride: true,
      bottomMainBtn: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.menu),
        elevation: 1,
        backgroundColor: Theme.of(context).accentColor,
      ),
      frontLayer: SingleRecipeContainer(
        recipe: widget.recipe,
        portion: this._portion,
      ),
      backLayer: [
          ElevatedButton.icon(
            icon: Icon(Icons.room_service),
            label: Text('Tryb szefa kuchni'),
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).accentColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
            ),
            onPressed: () {
              showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) {
                    return _buildCookModeModal();
                  });
            },
          ).height(50).width(MediaQuery.of(context).size.width).padding(bottom: 15, horizontal: 15),
          ElevatedButton.icon(
            icon: Icon(Icons.pie_chart),
            label: Text('Kalkulator składników'),
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).accentColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
            ),
            onPressed: () {
              showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) {
                    return _buildPortionModal();
                  });
            },
          ).height(50).width(MediaQuery.of(context).size.width).padding(bottom: 15, horizontal: 15),
          Slider(
            value: _currentSliderValue,
            min: 12,
            max: 48,
            divisions: 9,
            activeColor: Theme.of(context).accentColor,
            inactiveColor: Theme.of(context).primaryColorDark,
            label: _currentSliderValue.round().toString(),
            onChanged: (double value) {
              setState(() {
                _currentSliderValue = value;
              });
            },
          )
        ],
    );
  }
}
