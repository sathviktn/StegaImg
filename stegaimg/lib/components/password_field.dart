import 'package:flutter/material.dart';

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
          // Row(
            //children: <Widget>[
              Theme(data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.white),
                  child: CheckboxListTile(
                      title: const Text("Show password",
                          style: TextStyle(
                            fontSize: 23,
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'JosefinSans',
                          )),
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
          //  ],
          //),
          TextField(
            key: Key(widget.keyVal!),
            controller: widget.ctrl,
            obscureText: !visible!,
            decoration: const InputDecoration(
                hintText: 'Enter the Password',
                hintStyle: TextStyle(
                    fontSize: 27,
                    fontFamily: 'JosefinSans',
                    color: Colors.white
                )
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 27,
                color: Colors.white
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}

