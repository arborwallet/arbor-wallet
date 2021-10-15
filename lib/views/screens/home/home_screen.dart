import 'package:arbor/api/services.dart';
import 'package:arbor/core/constants/arbor_constants.dart';
import 'package:arbor/core/constants/hive_constants.dart';
import 'package:arbor/core/providers/send_crypto_provider.dart';
import 'package:arbor/models/models.dart';
import 'package:arbor/core/constants/arbor_colors.dart';
import 'package:arbor/views/screens/add_wallet/add_wallet_screen.dart';
import 'package:arbor/views/screens/send/value_screen.dart';
import 'package:arbor/views/screens/home/wallet_receive_screen.dart';
import 'package:arbor/views/widgets/arbor_button.dart';
import 'package:arbor/views/widgets/dialog/arbor_alert_dialog.dart';
import 'package:arbor/views/widgets/responsiveness/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'expanded_home_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box walletBox;

  // Pull to refresh wallet data
  Future<void> _reloadWalletBalances() async {
    WalletService walletService = WalletService();

    for (int index = 0; index < walletBox.length; index++) {
      Wallet existingWallet = walletBox.getAt(index);
      int newBalance =
          await walletService.fetchWalletBalance(existingWallet.address);

      Wallet newWallet = Wallet(
        name: existingWallet.name,
        phrase: existingWallet.phrase,
        privateKey: existingWallet.privateKey,
        publicKey: existingWallet.publicKey,
        address: existingWallet.address,
        balance: newBalance,
        blockchain: existingWallet.blockchain,
      );

      walletBox.putAt(index, newWallet);
    }
  }

  void _showReceiveView({required int walletIndex}) {
    Wallet walletData = walletBox.getAt(walletIndex) as Wallet;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WalletReceiveScreen(
          index: walletIndex,
          wallet: walletData,
        ),
      ),
    );
  }

  void _setNotFirstTimeUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(ArborConstants.IS_FIRST_TIME_USER_KEY, false);
  }

  void _popupMenuItemSelected(String value, int walletBoxIndex) {
    switch (value) {
      case 'delete':
        {
          deleteWallet(walletBoxIndex);
          break;
        }
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    // Get reference to an already opened box
    walletBox = Hive.box(HiveConstants.walletBox);

    // Since the user has seen this screen we assume they don't
    // need to see the Splash/On-Boarding views
    _setNotFirstTimeUser();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SendCryptoProvider>(builder: (_, model, __) {
      return Container(
        height: MediaQuery.of(context).size.height,
        color: ArborColors.green,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
            border: Border.all(
              color: ArborColors.black,
            ),
          ),
          child: RefreshIndicator(
            onRefresh: _reloadWalletBalances,
            child: ValueListenableBuilder(
              valueListenable: walletBox.listenable(),
              builder: (context, Box box, widget) {
                if (box.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Tap + to create a new wallet.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ArborColors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: FloatingActionButton(
                            tooltip: "Add a new wallet",
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AddWalletScreen(),
                              ),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            backgroundColor: ArborColors.deepGreen,
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: Responsive.isDesktop(context) ||
                                  Responsive.isTablet(context)
                              ? 600
                              : double.infinity),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: ArborButton(
                              backgroundColor: ArborColors.deepGreen,
                              title: '+ Add New Wallet',
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => AddWalletScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              //physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(
                                  bottom: kFloatingActionButtonMargin + 70),
                              itemCount: box.length,
                              itemBuilder: (context, index) {
                                var currentBox = box;
                                var walletData = currentBox.getAt(index)!;

                                return InkWell(
                                  onTap: () async {
                                    dynamic result =
                                        await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ExpandedHomeScreen(
                                          index: index,
                                          wallet: walletData,
                                        ),
                                      ),
                                    );

                                    if (result != null && result == true) {
                                      Future.delayed(
                                          Duration(
                                              seconds: model
                                                  .autoRefreshBalanceTimer),
                                          () async {
                                        walletBox = await model
                                            .refreshWalletBalances(walletBox);
                                      });
                                    }
                                  },
                                  child: Card(
                                    color: ArborColors.green,
                                    elevation: 8,
                                    shadowColor: Colors.lightGreen,
                                    margin: EdgeInsets.all(16),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: new DecorationImage(
                                                image: AssetImage(
                                                    "assets/images/chia-logo.png"),
                                                fit: BoxFit.fitHeight,
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            // '${walletData.blockchain.name} (${walletData.name})'
                                            '${walletData.blockchain.name}',
                                            style: TextStyle(
                                              color: ArborColors.white,
                                            ),
                                          ),
                                          subtitle: Text(
                                            walletData.blockchain.ticker
                                                .toUpperCase(),
                                            style: TextStyle(
                                              color: ArborColors.white70,
                                            ),
                                          ),
                                          trailing: Container(
                                            width: 70,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                (model.currentUserAddress ==
                                                            walletData
                                                                .address) &&
                                                        model
                                                            .transactionInProgress
                                                    ? Container(
                                                        height: 16,
                                                        width: 16,
                                                        decoration: BoxDecoration(
                                                            color: ArborColors
                                                                .yellow,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8)),
                                                      )
                                                    : Container(),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                PopupMenuButton(
                                                  itemBuilder: (context) {
                                                    return [
                                                      PopupMenuItem(
                                                          value: 'delete',
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons.delete,
                                                                color: ArborColors
                                                                    .errorRed,
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text('Delete'),
                                                            ],
                                                          ))
                                                    ];
                                                  },
                                                  onSelected: (String value) {
                                                    _popupMenuItemSelected(
                                                        value, index);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          // title: Text(walletData.balance.toStringAsFixed(walletData.blockchain.precision)),
                                          title: FittedBox(
                                              fit: BoxFit.contain,
                                              child: Text(
                                                (model.currentUserAddress ==
                                                            walletData
                                                                .address) &&
                                                        model
                                                            .transactionInProgress
                                                    ? model
                                                        .displayTemporaryBalance()
                                                    : walletData
                                                        .balanceForDisplay(),
                                                style: TextStyle(
                                                  color: ArborColors.white,
                                                ),
                                              )),
                                          subtitle: Text(
                                            walletData.address.toString(),
                                            style: TextStyle(
                                              color: ArborColors.white70,
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          contentPadding: EdgeInsets.all(
                                              10.0), //change for side padding
                                          title: Row(
                                            children: <Widget>[
                                              Expanded(
                                                  child: ArborButton(
                                                onPressed: () {
                                                  _showReceiveView(
                                                      walletIndex: index);
                                                },
                                                title: 'Receive',
                                                backgroundColor:
                                                    ArborColors.deepGreen,
                                              )),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: ArborButton(
                                                  onPressed: () async {
                                                    dynamic result =
                                                        await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ValueScreen(
                                                          wallet: walletData,
                                                        ),
                                                      ),
                                                    );

                                                    if (result != null &&
                                                        result == true) {
                                                      Future.delayed(
                                                          Duration(
                                                              seconds: model
                                                                  .autoRefreshBalanceTimer),
                                                          () async {
                                                        walletBox = await model
                                                            .refreshWalletBalances(
                                                                walletBox);
                                                      });
                                                    }
                                                  },
                                                  title: 'Send',
                                                  backgroundColor:
                                                      ArborColors.deepGreen,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      );
    });
  }

  // Delete info from wallet box
  deleteWallet(int index) async {
    bool result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ArborAlertDialog(
          title: "Delete Wallet",
          subTitle:
              "You cannot undo this action. Do you want to proceed to delete wallet?",
          onCancelPressed: () => Navigator.pop(context, false),
          onYesPressed: () => Navigator.pop(context, true),
        );
      },
    );
    if (result == true) {
      walletBox.deleteAt(index);
    }
  }
}
