import 'package:flutter/material.dart';
import 'package:przepisnik_v3/main.dart';
import 'package:styled_widget/styled_widget.dart';

typedef void VoidCallback();

enum ConfirmBottomModalType { none, warning, danger, info }

class ConfirmBottomModal extends StatelessWidget {
  final String? title;
  final String? msg;
  final VoidCallback? action;
  final ConfirmBottomModalType? type;

  const ConfirmBottomModal(
      {@required this.title,
      this.msg,
      @required this.action,
      this.type = ConfirmBottomModalType.none});

  @override
  Widget build(BuildContext context) {
    Color actionColor = Colors.black;

    switch (this.type) {
      case ConfirmBottomModalType.warning:
        actionColor = PrzepisnikColors.WARNING;
        break;
      case ConfirmBottomModalType.danger:
        actionColor = PrzepisnikColors.ERROR;
        break;
      case ConfirmBottomModalType.info:
        actionColor = PrzepisnikColors.INFO;
        break;
      case ConfirmBottomModalType.none:
      default:
        actionColor = Theme.of(context).primaryColor;
        break;
    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(this.title!, style: TextStyle(fontWeight: FontWeight.bold))
              .padding(bottom: 15),
          this.msg != null ? Text(this.msg!).padding(bottom: 15) : Container(),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(MediaQuery.of(context).size.width * 0.4, 50)
                  ),
                  child: const Text('Anuluj')),
              TextButton(
                  onPressed: this.action,
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width * 0.4, 50)
                  ),
                  child: Text('OK',
                      style: TextStyle(color: actionColor))).border(left: .1)
            ],
          ).border(top: .1)
        ],
      ),
    );
  }
}
