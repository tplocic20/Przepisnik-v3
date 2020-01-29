import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:przepisnik_v3/components/shared/BottomModalWrapper.dart';

class PortionModal extends StatefulWidget {
  final callback;
  final portion;
  PortionModal({this.callback, this.portion});
  @override
  State<StatefulWidget> createState() => _PortionModalState(this.portion);
}

class _PortionModalState extends State<PortionModal> {
  double _portion;
  _PortionModalState(this._portion);

  updatePortion(value) {
    setState(() {
      _portion = value;
    });
    widget.callback(value);
  }

  @override
  Widget build(BuildContext context) {
    return BottomModalWrapper(
        child: Column(
          children: <Widget>[
            RadioListTile(
              value: 0.25,
              groupValue: _portion,
              onChanged: (value) {
                this.updatePortion(value);
              },
              title: Text('Cwierć'),
            ),
            RadioListTile(
              value: 0.5,
              groupValue: _portion,
              onChanged: (value) {
                this.updatePortion(value);
              },
              title: Text('Pół'),
            ),
            RadioListTile(
              value: 1.0,
              groupValue: _portion,
              onChanged: (value) {
                this.updatePortion(value);
              },
              title: Text('Jedna porcja'),
            ),
            RadioListTile(
              value: 2.0,
              groupValue: _portion,
              onChanged: (value) {
                this.updatePortion(value);
              },
              title: Text('Podwójna porcja'),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: SliderTheme(
                  data: SliderThemeData(
                    thumbColor: Theme.of(context).primaryColor,
                    activeTrackColor: Theme.of(context).primaryColor,
                    inactiveTrackColor: Theme.of(context).accentColor,
                    overlayColor: Theme.of(context).primaryColorLight,
                    valueIndicatorColor: Theme.of(context).primaryColor
                  ),
                  child: Slider(
                    value: _portion,
                    min: 0.25,
                    max: 2,
                    divisions: 7,
                    label: _portion.toString(),
                    onChanged: (value) {
                      this.updatePortion(value);
                    },
                  )),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[FlatButton(
                  child: Text('Ok'),
                  textColor: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),],
            )
          ],
        ));
  }

}