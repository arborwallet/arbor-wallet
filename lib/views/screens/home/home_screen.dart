import 'package:arbor/api/services.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/arbor_constants.dart';
import '../../../core/constants/hive_constants.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'expanded_home_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Box walletBox;

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
        fork: existingWallet.fork,
        balance: newBalance,
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
    return
       Scaffold(
        backgroundColor: ArborColors.green,
        appBar: AppBar(
          title: Text(
            'Arbor Wallet',
            style: TextStyle(
              color: ArborColors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: ArborColors.green,
        ),
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
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
                                          builder: (context) =>
                                              AddWalletScreen(),
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
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ExpandedHomeScreen(
                                        index: index,
                                        wallet: walletData,
                                      ),
                                    ),
                                  ),
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
                                            // '${walletData.fork.name} (${walletData.name})'
                                            '${walletData.fork.name}',
                                            style: TextStyle(
                                              color: ArborColors.white,
                                            ),
                                          ),
                                          subtitle: Text(
                                            walletData.fork.ticker
                                                .toUpperCase(),
                                            style: TextStyle(
                                              color: ArborColors.white70,
                                            ),
                                          ),
                                          trailing: PopupMenuButton(
                                            itemBuilder: (context) {
                                              return [
                                                PopupMenuItem(
                                                    value: 'delete',
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.delete,
                                                          color: Colors.red,
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
                                        ),
                                        ListTile(
                                          // title: Text(walletData.balance.toStringAsFixed(walletData.fork.precision)),
                                          title: FittedBox(
                                              fit: BoxFit.contain,
                                              child: Text(
                                                walletData.balanceForDisplay(),
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
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ValueScreen(
                                                          wallet: walletData,
                                                        ),
                                                      ),
                                                    );
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
