import 'package:flutter/material.dart';
import 'package:stegaimg/utilities/configs.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController? ctrl;
  final bool? enable;
  final String? keyVal;

  const PasswordField(this.enable, this.ctrl, {this.keyVal});

  @override
  State<StatefulWidget> createState() {
    return _PasswordField();
  }
}

class _PasswordField extends State<PasswordField> {
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
                      style: StegaTextStyle(fSize: 25, fStyle: FontStyle.italic)),
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
            decoration: StegaInputDec(hint: 'Enter the password', hFontSize: 30),
            textAlign: TextAlign.center,
            style: const StegaTextStyle(fSize: 30)
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}

