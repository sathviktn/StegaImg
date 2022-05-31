import 'package:flutter/material.dart';
import 'package:stegaimg/utilities/configs.dart';

/// StegaImg Password Field
///
/// Implements required fields for Password entry.
///
/// @category Components
class StegaImgPasswordField extends StatefulWidget {
  final TextEditingController? ctrl;
  final bool? enable;
  final String? keyVal;

  const StegaImgPasswordField(this.enable, this.ctrl, {this.keyVal});

  @override
  State<StatefulWidget> createState() {
    return _StegaImgPasswordField();
  }
}

class _StegaImgPasswordField extends State<StegaImgPasswordField> {
  bool? visible;

  @override
  void initState() {
    super.initState();
    visible = false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.enable!) {
      return Column(
        children: <Widget>[
          Theme(data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.white),
              child: CheckboxListTile(
                  title: const Text("Show password",
                      style: StegaImgTextStyle(fSize: 25, fStyle: FontStyle.italic)),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: visible,
                  activeColor: Colors.white,
                  checkColor: Colors.black,
                  onChanged: (bool? nextVal) {
                    setState(() {
                      visible = nextVal;
                    });
                  })
          ),
          TextField(
            key: Key(widget.keyVal!),
            controller: widget.ctrl,
            obscureText: !visible!,
            decoration: StegaImgInputDec(hint: 'Enter the password', hFontSize: 30),
            textAlign: TextAlign.center,
            style: const StegaImgTextStyle(fSize: 30)
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}

