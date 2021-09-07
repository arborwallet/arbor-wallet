import 'package:arbor/core/providers/restore_wallet_provider.dart';
import 'package:arbor/views/screens/input_password_final_screen.dart';
import 'package:arbor/views/widgets/layout/hide_keyboard_container.dart';
import 'package:arbor/views/widgets/password_box.dart';
import 'package:provider/provider.dart';
import '/views/widgets/arbor_button.dart';

import '/core/arbor_colors.dart';
import 'package:flutter/material.dart';

class InputPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RestoreWalletProvider>(
      builder: (_, model, __) {
        return Scaffold(
          backgroundColor: ArborColors.green,
          appBar: AppBar(
            backgroundColor: ArborColors.green,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                if (model.currentState == CrossFadeState.showFirst) {
                  Navigator.pop(context);
                } else {
                  model.back();
                }
              },
              icon: Icon(Icons.arrow_back),
            ),
            title: Text('Restore Wallet'),
          ),
          body: HideKeyboardContainer(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    child: Text(
                      'Type your 12-word password to restore your existing wallet',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: ArborColors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      children: [
                        AnimatedCrossFade(
                          firstChild: firstChild(context, model),
                          secondChild: secondChild(context, model),
                          crossFadeState: model.currentState,
                          duration: const Duration(milliseconds: 300),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget firstChild(BuildContext context, RestoreWalletProvider model) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '1 - 4',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: ArborColors.white,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          PasswordBox(
            index: 1,
            onChanged: (v) => model.setFirstPassword(v),
          ),
          PasswordBox(
            index: 2,
            onChanged: (v) => model.setSecondPassword(v),
          ),
          PasswordBox(
            index: 3,
            onChanged: (v) => model.setThirdPassword(v),
          ),
          PasswordBox(
            index: 4,
            onChanged: (v) => model.setFourthPassword(v),
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Expanded(
                child: ArborButton(
                  backgroundColor: ArborColors.logoGreen,
                  title: 'Next',
                  onPressed: () => model.nextScreen(),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget secondChild(BuildContext context, RestoreWalletProvider model) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '5 - 8',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: ArborColors.white,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          PasswordBox(
            index: 5,
            onChanged: (v) => model.setFifthPassword(v),
          ),
          PasswordBox(
            index: 6,
            onChanged: (v) => model.setSixthPassword(v),
          ),
          PasswordBox(
            index: 7,
            onChanged: (v) => model.setSeventhPassword(v),
          ),
          PasswordBox(
            index: 8,
            onChanged: (v) => model.setEighthPassword(v),
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Expanded(
                child: ArborButton(
                  backgroundColor: ArborColors.logoGreen,
                  title: 'Next',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InputPasswordFinalScreen(),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
