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
  bool? visibleSecret;

  @override
  void initState() {
    super.initState();
    visibleSecret = false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.enable!) {
      return Row(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: TextField(
                key: Key(widget.keyVal!),
                controller: widget.ctrl,
                obscureText: !visibleSecret!,
                textAlign: TextAlign.center,
                style: const StegaImgTextStyle(fSize: 30),
                decoration: InputDecoration(
                    hintText: 'Enter the password',
                    hintStyle: const StegaImgTextStyle(fSize: 30, fColor: Colors.lightBlueAccent),
                    suffixIcon: Container(
                        decoration: const BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.all(Radius.circular(30))
                        ),
                        child: IconButton(
                          icon: visibleSecret!
                          ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                          color: Colors.black,
                          onPressed: () => {
                            setState(() { visibleSecret = !visibleSecret!; })
                            },
                        )
                    )),
              )
          ),
          Container(
            decoration: const BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.all(Radius.circular(30))
            ),
            child: IconButton(
                icon: const Icon(Icons.clear, color: Colors.black,),
                onPressed: (){
                  widget.ctrl?.clear();
                }),
          )
        ]
      );
    } else {
      return Container();
    }
  }
}

