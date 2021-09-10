import 'package:arbor/core/constants/arbor_colors.dart';
import 'package:arbor/core/constants/asset_paths.dart';
import 'package:arbor/core/enums/status.dart';
import 'package:arbor/core/providers/send_crypto_provider.dart';
import 'package:arbor/models/models.dart';
import 'package:arbor/views/screens/send/address_scanner.dart';
import 'package:arbor/views/screens/send/status_screen.dart';
import 'package:arbor/views/widgets/arbor_button.dart';
import 'package:arbor/views/widgets/arbor_textfield.dart';
import 'package:arbor/views/widgets/layout/hide_keyboard_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:provider/provider.dart';

class ValueScreen extends StatelessWidget {
  final addressFocusNode = FocusNode();
  final addressController = TextEditingController();

  final Wallet wallet;
  ValueScreen({required this.wallet});

  @override
  Widget build(BuildContext context) {
    return Consumer<SendCryptoProvider>(builder: (_, model, __) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        if (model.walletBalanceStatus == Status.IDLE) {
          model.setWalletBalance(wallet.balance);
          model.privateKey = wallet.privateKey;
          model.currentUserAddress = wallet.address;
          //model.getBalance();
        }
      });
      return Container(
        color: ArborColors.green,
        child: HideKeyboardContainer(
          child: SafeArea(
            child: Scaffold(
              backgroundColor: ArborColors.green,
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  'Enter Amount',
                  style: TextStyle(
                    color: ArborColors.white,
                  ),
                ),
                elevation: 0,
                backgroundColor: ArborColors.green,
              ),
              body: Container(
                padding: EdgeInsets.fromLTRB(
                  20,
                  10,
                  20,
                  20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ArborColors.lightGreen.withOpacity(0.3),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            8,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: ArborColors.logoGreen,
                            backgroundImage: AssetImage(
                              AssetPaths.logo,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'XCH Wallet',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: ArborColors.white, fontSize: 14),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              model.walletBalanceStatus == Status.LOADING
                                  ? 'Loading...'
                                  : 'XCH ${model.convertedBalance}',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: ArborColors.white, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '${model.transactionValue} XCH',
                      style:
                          TextStyle(fontSize: 30, color: ArborColors.deepGreen),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    ArborTextField(
                      hintText: "Enter Recipient's Address",
                      focusNode: addressFocusNode,
                      controller: addressController
                        ..text = model.receiverAddress,
                      errorMessage: model.addressErrorMessage,
                      onChanged: (v) => model.setReceiverAddress(v),
                      onIconPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddressScanner(),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: NumericKeyboard(
                          onKeyboardTap: (_) => model.setTransactionValue(_),
                          textColor: ArborColors.white,
                          rightButtonFn: () =>model.deleteCharacter(),
                          rightIcon: Icon(
                            Icons.arrow_back,
                            color: ArborColors.white,
                          ),
                          leftButtonFn: () => model.setTransactionValue('.'),
                          leftIcon: Icon(
                            Icons.adjust_sharp,
                            color: ArborColors.white,
                          ),
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly),
                    ),
                    ArborButton(
                      backgroundColor: ArborColors.logoGreen,
                      disabled: !model.enableButton,
                      loading: false,
                      title: 'Continue',
                      onPressed: () async {
                        bool status = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StatusScreen(),
                          ),
                        );
                        if (status == true) model.getBalance();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
