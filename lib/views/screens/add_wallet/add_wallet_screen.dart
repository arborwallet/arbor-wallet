import 'package:arbor/core/constants/arbor_colors.dart';
import 'package:arbor/core/constants/asset_paths.dart';
import 'package:arbor/core/providers/create_wallet_provider.dart';
import 'package:arbor/views/screens/add_wallet/add_wallet_status_screen.dart';
import 'package:arbor/views/widgets/cards/option_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../input_password_screen.dart';

class AddWalletScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CreateWalletProvider>(builder: (_,model,__){

      return Container(
        color: ArborColors.green,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: ArborColors.green,
            appBar: AppBar(
              backgroundColor: ArborColors.green,
              centerTitle: true,
              elevation: 0,
              title: Text('Add Wallet'),
            ),
            body: Container(
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                children: [
                  SizedBox(
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
                    description: 'Generate a new wallet.',
                    actionText: 'Generate New Wallet',
                    onPressed: ()async {
                      model.createNewWallet();
                     bool result=await  Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddWalletStatusScreen(),
                        ),
                      );

                     if(result==true)
                       Navigator.pop(context);

                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
