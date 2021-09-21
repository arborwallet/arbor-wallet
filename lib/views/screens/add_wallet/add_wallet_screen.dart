import 'package:arbor/core/constants/arbor_colors.dart';
import 'package:arbor/core/constants/asset_paths.dart';
import 'package:arbor/core/providers/create_wallet_provider.dart';
import 'package:arbor/views/screens/add_wallet/add_wallet_status_screen.dart';
import 'package:arbor/views/widgets/cards/option_card.dart';
import 'package:arbor/views/widgets/responsiveness/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../input_password_screen.dart';

class AddWalletScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CreateWalletProvider>(builder: (_, model, __) {
      return Container(
        color: ArborColors.green,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: ArborColors.green,
            appBar: AppBar(
                backgroundColor: ArborColors.green,
                centerTitle: true,
                title: Text(
                  'Add Wallet',
                  style: TextStyle(
                    color: ArborColors.white,
                  ),
                ),
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: ArborColors.white,
                  ),
                )),
            body: Responsive.isDesktop(context) || Responsive.isTablet(context)
                ? Center(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 500,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 20,
                      ),
                      child: buildOptionsList(context, model,
                          alignment: MainAxisAlignment.center),
                    ),
                  )
                : Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: buildOptionsList(context, model),
                  ),
          ),
        ),
      );
    });
  }

  Widget buildOptionsList(BuildContext context, CreateWalletProvider model,
      {MainAxisAlignment alignment: MainAxisAlignment.start}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: alignment,
      children: [
        const SizedBox(
          height: 10,
        ),
        OptionCard(
          iconPath: AssetPaths.restore,
          description: 'Type your 12-word secret backup phrase.',
          actionText: 'Type Secret Phrase',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InputPasswordScreen(),
              ),
            );
          },
        ),
        OptionCard(
          iconPath: AssetPaths.wallet,
          description: 'Create a new wallet to send/receive Chia (XCH).',
          actionText: 'Generate New Wallet',
          onPressed: () async {
            model.clearAll();
            model.createNewWallet();
            var result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddWalletStatusScreen(),
              ),
            );

            if (result == true) Navigator.pop(context);
          },
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
