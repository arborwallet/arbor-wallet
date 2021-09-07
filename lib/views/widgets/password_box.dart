import 'package:arbor/core/arbor_colors.dart';
import 'package:flutter/material.dart';

class PasswordBox extends StatelessWidget {
  final int? index;
  final ValueChanged<String>? onChanged;
  final String errorMessage;
  PasswordBox({this.index, this.onChanged, this.errorMessage = ''});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              color: ArborColors.logoGreen,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 30,
                ),
                Text(
                  '$index.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: ArborColors.white,
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    maxLines: 1,
                    scrollPadding: EdgeInsets.zero,
                    onChanged: onChanged,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      isCollapsed: true,
                      contentPadding: EdgeInsets.all(16),
                      hintText: '...',
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Visibility(
              visible: errorMessage != '',
              child: Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  '$errorMessage',
                  style: TextStyle(
                    fontSize: 12,
                    color: ArborColors.errorRed,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class NewPasswordBox extends StatelessWidget {
  final TextInputType keyboardType;
  final int maxLines;
  final String? title;
  final String? errorMessage;
  final String placeholder;
  final String? leading;
  final bool enabled;
  final bool password;
  final ValueChanged<String>? onChanged;

  final eveBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
  );

  NewPasswordBox({
    Key? key,
    this.keyboardType: TextInputType.text,
    this.maxLines: 1,
    this.title = '',
    this.errorMessage = '',
    this.placeholder = '...',
    this.leading,
    this.enabled = false,
    this.password = false,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: ArborColors.logoGreen,
            ),
            child: TextFormField(
              keyboardType: keyboardType,
              maxLines: maxLines,
              obscureText: password,
              obscuringCharacter: '●',
              cursorColor: ArborColors.white,
              style: TextStyle(fontSize: 18, color: ArborColors.white),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                hintText: placeholder,
                filled: true,
                fillColor: ArborColors.logoGreen,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                prefixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 4,
                        left: 10,
                      ),
                      child: Text(
                        '$leading.',
                        style:
                            TextStyle(color: ArborColors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
                border: eveBorder.copyWith(
                  borderSide: BorderSide.none,
                ),
                disabledBorder: eveBorder.copyWith(
                  borderSide: BorderSide.none,
                ),
                enabledBorder: eveBorder.copyWith(
                  borderSide: BorderSide(
                      color: errorMessage != ''
                          ? Colors.red
                          : ArborColors.logoGreen),
                ),
                focusedBorder: eveBorder.copyWith(
                  borderSide: BorderSide(color: ArborColors.logoGreen),
                ),
              ),
              onChanged: onChanged,
              //onSubmitted: onFieldSubmitted,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Visibility(
              visible: errorMessage != '',
              child: Text(
                '$errorMessage',
                style: TextStyle(fontSize: 10, color: Colors.red),
              )),
        ],
      ),
    );
  }
}
