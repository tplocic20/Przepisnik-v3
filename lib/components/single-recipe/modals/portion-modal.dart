import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:przepisnik_v3/components/shared/bottom-modal-wrapper.dart';
import 'package:przepisnik_v3/components/shared/portion-slider.dart';

class PortionModal extends StatefulWidget {
  final callback;
  final portion;

  PortionModal({this.callback, this.portion});

  @override
  State<StatefulWidget> createState() => _PortionModalState(this.portion);
}

class _PortionModalState extends State<PortionModal> {
  double _portion;
  double  _min = 0.1;
  double _max = 1.1;
  int _step = 10;
  _PortionModalState(this._portion);

  updatePortion(value) {
    setState(() {
      _portion = value;
    });
    widget.callback(value);
  }

  updateSlider(value) {
    setState(() {
      if (value < 1) {
        _min = 0.1;
        _max = 1.1;
        _step = 10;
      } else if (value == 1) {
        _min = 0.25;
        _max = 2;
        _step = 7;
      } else {
        _min = 1;
        _max = 4;
        _step = 6;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomModalWrapper(
        child: ListView(
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
                  valueIndicatorColor: Theme.of(context).primaryColor),
              child: Slider(
                value: _portion,
                min: _min,
                max: _max,
                divisions: _step,
                label: _portion.toString(),
                onChanged: (value) {
                  this.updatePortion(value);
                },
              )),
        ),
        PortionSlider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
              child: Text('Ok'),
              textColor: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        )
      ],
    ));
  }
}
