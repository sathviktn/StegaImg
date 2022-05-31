import 'package:flutter/material.dart';
import 'package:stegaimg/utilities/configs.dart';

class ButtonLogoWithLoadingAndError extends StatelessWidget {
  final LoadingState? loadingState;
  final IconData pendingIcon;

  const ButtonLogoWithLoadingAndError(this.loadingState, this.pendingIcon);

  @override
  Widget build(BuildContext context) {
    switch (loadingState) {
      case LoadingState.loading:
        return const SizedBox(
          height: 20.0,
          width: 20.0,
          child: CircularProgressIndicator(
            backgroundColor: Colors.black,
            strokeWidth: 2.0,
          ),
        );
      case LoadingState.error:
        return const Icon(Icons.close,);
      case LoadingState.pending:
        return Icon(pendingIcon);
      case LoadingState.success:
        return const Icon(Icons.done);
      default:
        return Icon(pendingIcon);
    }
  }
}
