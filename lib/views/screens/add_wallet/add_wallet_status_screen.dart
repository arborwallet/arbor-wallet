import 'package:arbor/core/constants/arbor_colors.dart';
import 'package:arbor/core/constants/asset_paths.dart';
import 'package:arbor/core/enums/status.dart';
import 'package:arbor/core/providers/create_wallet_provider.dart';
import 'package:arbor/views/widgets/arbor_button.dart';
import 'package:arbor/views/widgets/phrase_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class StatusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CreateWalletProvider>(builder: (_, model, __) {
      return Container(
        color: ArborColors.green,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: ArborColors.green,
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                '${model.appBarTitle}',
                style: TextStyle(color: ArborColors.white),
              ),
              elevation: 0,
              automaticallyImplyLeading: false,
              backgroundColor: ArborColors.green,
            ),
            body: Container(
              padding: EdgeInsets.all(40),
              child: Builder(
                builder: (_) {
                  if (model.createWalletStatus == Status.LOADING) {
                    return _processingView(model);
                  } else if (model.createWalletStatus == Status.SUCCESS) {
                    return _successView(context, model);
                  } else if (model.createWalletStatus == Status.ERROR) {
                    return _errorView(context, model);
                  } else {
                    return _processingView(model);
                  }
                },
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _processingView(CreateWalletProvider model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Container(),
        ),
        SvgPicture.asset(
          AssetPaths.transactionSend,
          fit: BoxFit.cover,
          height: 100,
        ),
        Expanded(
          flex: 2,
          child: Container(),
        ),
        Text(
          'New Wallet',
          style: TextStyle(
            color: ArborColors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        Text(
          'Generating new wallet...',
          style: TextStyle(
            color: ArborColors.white,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(),
        ),
      ],
    );
  }

  Widget _successView(BuildContext context, CreateWalletProvider model) {
    return Container(
      decoration: BoxDecoration(
        color: ArborColors.deepGreen,
        borderRadius: BorderRadius.all(Radius.circular(10,),),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Container(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'We will not save or store this secret phrase. Write it down. Keep it safe.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ArborColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'Write down your secret phrase in the correct order on paper.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ArborColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (_, i) => PhraseText(
                itemNumber: i,
                word: model.phrasesList[i],
                visible: model.revealPhrase,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(),
          ),
          ArborButton(
            backgroundColor: ArborColors.logoGreen,
            disabled: false,
            loading: false,
            title: 'Continue',
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _errorView(BuildContext context, CreateWalletProvider model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Container(),
        ),
        SvgPicture.asset(
          AssetPaths.walletSendError,
          fit: BoxFit.cover,
          height: 150,
        ),
        Expanded(
          flex: 5,
          child: Container(),
        ),
        Text(
          'Oops!',
          style: TextStyle(
            color: ArborColors.white,
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
        Text(
          '${model.errorMessage}',
          style: TextStyle(
            color: ArborColors.white,
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(),
        ),
        ArborButton(
          backgroundColor: ArborColors.logoGreen,
          disabled: false,
          loading: false,
          title: 'Go Back',
          onPressed: () {
            Navigator.pop(context, false);
            model.clearAll();
          },
        ),
      ],
    );
  }
}
