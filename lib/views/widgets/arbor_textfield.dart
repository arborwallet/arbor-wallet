import 'package:arbor/core/constants/arbor_colors.dart';
import 'package:arbor/core/constants/asset_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ArborTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String errorMessage;
  final bool isDisabled;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onIconPressed;

  ArborTextField(
      {this.hintText = '',
      this.controller,
      this.focusNode,
      this.isDisabled = false,
      this.errorMessage = '',
      this.onChanged,
      this.onIconPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
      child: Row(
        children: [
          Expanded(
            flex: 10,
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.text,
              maxLines: 1,
              textCapitalization: TextCapitalization.none,
              focusNode: focusNode,
              obscureText: false,
              onChanged: onChanged,
              cursorColor: Theme.of(context).colorScheme.onPrimary,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: errorMessage != ''
                    ? ArborColors.errorRed
                    : ArborColors.white,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: ArborColors.white),
                fillColor: Theme.of(context).colorScheme.background,
                filled: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: ArborColors.logoGreen,)
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: ArborColors.logoGreen,)
                ),
                contentPadding:
                    EdgeInsets.fromLTRB(20,20,0,20),
                suffixIcon: IconButton(
                  onPressed: () => onIconPressed!(),
                  icon: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SvgPicture.asset(
                      AssetPaths.qr,
                      color: ArborColors.black,
                      width: 20,
                      height: 20,
                    ),
                  ),
                  alignment: Alignment(1.0, 0.0),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
