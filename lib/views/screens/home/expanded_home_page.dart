import 'package:arbor/models/models.dart';
import 'package:arbor/core/constants/arbor_colors.dart';
import 'package:arbor/views/screens/send/value_screen.dart';
import 'package:arbor/views/screens/home/transactions_screen.dart';
import 'package:arbor/views/widgets/arbor_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:flutter/services.dart';
import 'package:arbor/views/screens/wallet_receive_screen.dart';

import '../../../core/constants/hive_constants.dart';

class ExpandedHomePage extends StatefulWidget {
  const ExpandedHomePage({
    required this.index,
    required this.wallet,
  });

  final int index;
  final Wallet wallet;

  @override
  _ExpandedHomePageState createState() => _ExpandedHomePageState();
}

class _ExpandedHomePageState extends State<ExpandedHomePage> {
  late final Box walletBox;

  int get index => widget.index;

  void _showReceiveView() {
    Wallet walletData = walletBox.getAt(index) as Wallet;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WalletReceiveScreen(
          index: index,
          wallet: walletData,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Get reference to an already opened box
    walletBox = Hive.box(HiveConstants.walletBox);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ValueListenableBuilder(
        valueListenable: walletBox.listenable(),
        builder: (context, Box box, widget) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                  'Hmm. We could not find a wallet to show. Please try again'),
            );
          } else {
            var walletData = walletBox.getAt(index);
            return Column(
              children: [
                ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        image: AssetImage("assets/images/chia-logo.png"),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  // title: Text('${walletData.fork.name} (${walletData.name})'),
                  title: Text(
                    '${walletData.fork.name}',
                    style: TextStyle(
                      color: ArborColors.white,
                    ),
                  ),
                  subtitle: Text(
                    walletData.fork.ticker.toUpperCase(),
                    style: TextStyle(
                      color: ArborColors.white70,
                    ),
                  ),
                ),
                Card(
                  color: Colors.green,
                  child: ListTile(
                    title: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        '${walletData.fork.ticker.toUpperCase()}: ${walletData.balanceForDisplay()}',
                        style: TextStyle(
                          color: ArborColors.white,
                        ),
                      ),
                    ),
                    trailing: Icon(Icons.copy),
                    onTap: () {
                      Clipboard.setData(ClipboardData(
                          text: walletData.balanceForDisplay()));
                      showSnackBar(context, 'Balance copied');


                    },
                  ),
                ),
                Card(
                  color: Colors.green,
                  child: ListTile(
                    title: Text(
                      'Address',
                      style: TextStyle(
                        color: ArborColors.white,
                      ),
                    ),
                    subtitle: Text(
                      walletData.address,
                      style: TextStyle(
                        color: ArborColors.white70,
                      ),
                    ),
                    trailing: Icon(Icons.copy),
                    onTap: () {
                      Clipboard.setData(
                          ClipboardData(text: walletData.address));
                      showSnackBar(context, 'Wallet address copied');


                    },
                  ),
                ),
                Card(
                  color: Colors.green,
                  child: ListTile(
                    title: Text(
                      'Public Key',
                      style: TextStyle(
                        color: ArborColors.white,
                      ),
                    ),
                    subtitle: Text(
                      walletData.publicKey,
                      style: TextStyle(
                        color: ArborColors.white70,
                      ),
                    ),
                    trailing: Icon(Icons.copy),
                    onTap: () {
                      Clipboard.setData(
                          ClipboardData(text: walletData.publicKey));
                      showSnackBar(context, 'Public key copied');
                    },
                  ),
                ),
                Card(
                  color: Colors.green,
                  child: ListTile(
                    title: Text(
                      'Private Key',
                      style: TextStyle(
                        color: ArborColors.white,
                      ),
                    ),
                    subtitle:
                    Text(
                      '*' * walletData.privateKey.toString().length,
                      style: TextStyle(
                        color: ArborColors.white70,
                      ),
                    ),
                    trailing: Icon(Icons.copy),
                    onTap: () {
                      Clipboard.setData(
                          ClipboardData(text: walletData.privateKey));
                      showSnackBar(context, 'Private key copied');
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
      SizedBox(height: 40,),
      ArborButton(
        // style: ElevatedButton.styleFrom(
        //   minimumSize: Size(double.infinity,
        //       30), // double.infinity is the width and 30 is the height
        // ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return TransactionsSheet(
                  walletAddress: (walletBox.getAt(index) as Wallet).address);
            },
          );
        },
        title: 'All Transactions',
        backgroundColor: ArborColors.deepGreen,
      ),
      ListTile(
        contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        title: Row(
          children: <Widget>[
            Expanded(
                child: ArborButton(
                    backgroundColor: ArborColors.deepGreen,
                    onPressed: () {
                      _showReceiveView();
                    },
                    title: 'Receive')),
            SizedBox(width: 10),
            Expanded(
                child: ArborButton(
                    backgroundColor: ArborColors.deepGreen,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ValueScreen(wallet: widget.wallet,),
                        ),
                      );
                    },
                    title: 'Send')),
          ],
        ),
      )
    ]);
  }

  showSnackBar(BuildContext context,String message){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$message!"),
      duration: Duration(milliseconds: 1000),
      backgroundColor: ArborColors.deepGreen,
      elevation: 2,
      padding: EdgeInsets.all(
        10,
      ), // Inner padding for SnackBar content.
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),),);
  }
}

