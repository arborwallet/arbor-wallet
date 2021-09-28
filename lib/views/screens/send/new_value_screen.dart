import 'package:arbor/core/constants/arbor_colors.dart';
import 'package:arbor/core/constants/asset_paths.dart';
import 'package:arbor/core/enums/status.dart';
import 'package:arbor/core/providers/send_crypto_provider.dart';
import 'package:arbor/models/models.dart';
import 'package:arbor/views/screens/send/address_scanner.dart';
import 'package:arbor/views/screens/send/status_screen.dart';
import 'package:arbor/views/widgets/arbor_button.dart';
import 'package:arbor/views/widgets/keypad/arbor_keypad.dart';
import 'package:arbor/views/widgets/text_fields/arbor_textfield.dart';
import 'package:arbor/views/widgets/text_fields/editting_controller.dart';
import 'package:arbor/views/widgets/layout/hide_keyboard_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewValueScreen extends StatelessWidget {
  final addressFocusNode = FocusNode();
  final addressController = CustomTextEditingController();

  final Wallet wallet;
  NewValueScreen({required this.wallet});

  @override
  Widget build(BuildContext context) {
    return Consumer<SendCryptoProvider>(builder: (_, model, __) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        if (model.walletBalanceStatus == Status.IDLE) {
          model.privateKey = wallet.privateKey;
          model.currentUserAddress = wallet.address;
          model.forkPrecision = wallet.fork.precision;
          model.forkName = wallet.fork.name;
          model.forkTicker = wallet.fork.ticker;
          model.setWalletBalance(wallet.balance);
        }
      });
      return Container(
        color: ArborColors.green,
        child: HideKeyboardContainer(
          child: SafeArea(
            child: Scaffold(
              backgroundColor: ArborColors.green,
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                centerTitle: true,
                leading: IconButton(
                  onPressed: () {
                    model.clearInput();
                    Navigator.pop(context, false);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: ArborColors.white,
                  ),
                ),
                title: Text(
                  'Enter Amount',
                  style: TextStyle(
                    color: ArborColors.white,
                  ),
                ),
                backgroundColor: ArborColors.green,
              ),
              body: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 10),
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
                              '${wallet.fork.name}',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: ArborColors.white, fontSize: 14),
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              model.walletBalanceStatus == Status.LOADING
                                  ? 'Loading...'
                                  : '${model.readableBalance} ${wallet.fork.ticker.toUpperCase()}',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: ArborColors.white, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '${model.transactionValue} ${wallet.fork.ticker.toUpperCase()}',
                        style: TextStyle(
                            fontSize: 24.h, color: ArborColors.deepGreen),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ArborTextField(
                        hintText: "Tap to paste Recipient's Address",
                        focusNode: addressFocusNode,
                        controller: addressController
                          ..text = model.receiverAddress,
                        isDisabled: true,
                        onTextFieldTapped: () {
                          model.getClipBoardData();
                        },
                        errorMessage: model.addressErrorMessage,
                        onChanged: (v) => model.setReceiverAddress(v),
                        onIconPressed: () {
                          model.scannedData = false;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddressScanner(),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: ArborKeyPad(
                        size: ArborKeyPadSize.small,
                        onKeyPressed: (key) => model.setTransactionValue(key),
                        clearIcon: Icon(
                          Icons.arrow_back,
                          color: ArborColors.white,
                          size: 14,
                        ),
                        bottomLeftKey: ArborKeyPadBottomLeftKeyType.point,
                        onBottomLeftKeyPressed: () =>
                            model.setTransactionValue('.'),
                        onBackKeyPressed: () => model.deleteCharacter(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ArborButton(
                        backgroundColor: ArborColors.logoGreen,
                        disabled: false,
                        loading: false,
                        title: 'Use Max',
                        onPressed: () => model.useMax(),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ArborButton(
                        backgroundColor: ArborColors.logoGreen,
                        disabled: !model.enableButton,
                        loading: false,
                        title: 'Continue',
                        onPressed: () async {
                          var status = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StatusScreen(),
                            ),
                          );
                          if (status == true) {
                            //model.getBalance();
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 20,
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
