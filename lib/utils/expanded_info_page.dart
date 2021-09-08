import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/api/services.dart';
import '/models/models.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


import 'package:flutter/services.dart';
import 'package:arbor/views/screens/transactions_screen.dart';
import 'package:arbor/views/screens/password_qr_share_screen.dart';
import 'package:arbor/views/screens/wallet_receive_screen.dart';

import '../core/constants/hive_constants.dart';

class ExpandedInfoPage extends StatefulWidget {
  const ExpandedInfoPage({
    required this.index,
    required this.wallet,
  });

  final int index;
  final Wallet wallet;

  @override
  _ExpandedInfoPageState createState() => _ExpandedInfoPageState();
}

class _ExpandedInfoPageState extends State<ExpandedInfoPage> {
  late final Box walletBox;

  int get index => widget.index;

  // Delete info from wallet box
  void _deleteInfo(int index) {
    walletBox.deleteAt(index);

    print('Item deleted from box at index: $index');
  }

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
    return Column(
      children: [
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: walletBox.listenable(),
            builder: (context, Box box, widget) {

              if (box.isEmpty) {
                return const Center(
                  child: Text('Hmm. We could not find a wallet to show. Please try again'),
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
                      title: Text('${walletData.fork.name} (${walletData.name})'),
                      subtitle: Text(walletData.fork.ticker.toUpperCase()),
                      trailing: IconButton(
                        onPressed: () => _deleteInfo(index),
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: FittedBox(fit: BoxFit.contain, child: Text('${walletData.fork.ticker.toUpperCase()}: ${walletData.balanceForDisplay()}')),
                        trailing: Icon(Icons.copy),
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: walletData.balanceForDisplay()));
                        },
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: Text('Address'),
                        subtitle: Text(walletData.address),
                        trailing: Icon(Icons.copy),
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: walletData.address));
                        },
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: Text('Public Key'),
                        subtitle: Text(walletData.publicKey),
                        trailing: Icon(Icons.copy),
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: walletData.publicKey));
                        },
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: Text('Private Key'),
                        subtitle: Text('*' * walletData.privateKey.toString().length),
                        trailing: Icon(Icons.copy),
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: walletData.privateKey));
                        },
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: Text('Password Phrase (mnemonic)'),
                        subtitle: Text('*' * walletData.phrase.toString().length),
                        trailing: Icon(Icons.qr_code),
                        onTap: () {
                          // Clipboard.setData(ClipboardData(text: walletData.phrase));
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return PasswordQRShareSheet(walletPhrase: (walletBox.getAt(index) as Wallet).phrase);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),

        OutlinedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 30), // double.infinity is the width and 30 is the height
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return TransactionsSheet(walletAddress: (walletBox.getAt(index) as Wallet).address);
                },
              );
            },
            child: Text('All Transactions')
        ),
        ListTile(
          contentPadding: EdgeInsets.all(10.0),//change for side padding
          title: Row(
            children: <Widget>[
              Expanded(child: ElevatedButton(onPressed: () {_showReceiveView();},child: Text('Receive'))),
              SizedBox(width: 10),
              Expanded(child: ElevatedButton(onPressed: () {},child: Text('Send'))),
            ],
          ),
        )
      ]
    );
  }


}

class TransactionsSheet extends StatefulWidget {
  const TransactionsSheet({
    required this.walletAddress,
  });

  final String walletAddress;

  @override
  _TransactionsSheetState createState() => _TransactionsSheetState(walletAddress);
}

class _TransactionsSheetState extends State<TransactionsSheet> {
  _TransactionsSheetState(this.walletAddress);

  late final Box transactionsBox;
  final String walletAddress;
  bool _fetchingTransactions = false;
  final walletService = WalletService();
  late Future<Transactions> fetchedTransactions;

  @override
  void initState() {
    super.initState();
    // Get reference to an already opened box
    transactionsBox = Hive.box(HiveConstants.transactionsBox);

    _updateTransactions(delayInSeconds: 1);
  }

  Future<void> _updateTransactions({int delayInSeconds = 0}) async {
    Future.delayed(Duration(seconds: delayInSeconds), () async {
      setState(() {
        _fetchingTransactions = true;
      });
      Transactions tr = await walletService.fetchWalletTransactions(walletAddress);
      if (transactionsBox.containsKey(walletAddress)) {
        transactionsBox.delete(walletAddress);
      }
      transactionsBox.put(walletAddress, tr);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.94,
        minChildSize: 0.84,
        maxChildSize: 1.0,
        builder: (context, scrollController) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text('Transactions'),
            ),
            floatingActionButton: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: FloatingActionButton(
                        heroTag: "refresh",
                        backgroundColor: Colors.lightGreen,
                        child: Icon(Icons.refresh),
                        onPressed: () {
                          _updateTransactions();
                        }),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                      heroTag: "btn2",
                      backgroundColor: Colors.lightGreen,
                      child: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ),
              ],
            ),
            body: Container(
              child: ValueListenableBuilder(
                valueListenable: transactionsBox.listenable(),
                builder: (context, Box box, widget) {

                  Transactions? transactionsModel;
                  List<Transaction>? transactionsList;

                  for (int i=0; i < box.length; i++) {
                    Transactions tr = box.getAt(i);
                    if (tr.walletAddress == walletAddress) {
                      transactionsModel = tr;
                      transactionsList = tr.list;
                      break;
                    }
                  }

                  // if (box.isEmpty) {
                  if (transactionsList == null || transactionsList.length == 0) {
                    return Container(
                      padding: EdgeInsets.all(50),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Image.asset('assets/images/transaction-light.png'),
                            SizedBox(height: 30),
                            Text(
                              'You have not sent or received anything yet. Go to a faucet and get some mojo.',
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        )
                      );
                  } else {
                    return Container(
                      child:
                          ListView.builder(
                            padding: const EdgeInsets.only(bottom: kFloatingActionButtonMargin+100),
                            shrinkWrap: false,
                            itemCount: transactionsList.length,
                            itemBuilder: (context, index) {
                            Transaction transaction = transactionsList!.elementAt(index);

                            return Card (
                              elevation: 1,
                              shadowColor: Colors.lightGreen,
                              margin: EdgeInsets.all(4),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                          image: transaction.assetImageForType(),
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ),
                                    title: Text('${transaction.typeForDisplay()}'),
                                    subtitle: Text(transaction.timeForDisplay()),
                                    trailing: Text(
                                        transaction.amountForDisplay(transactionsModel!.fork.precision),
                                        style: TextStyle(fontWeight: FontWeight.bold),),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                    );
                  }
                },
              ),
            ),
          );
        }
    );
  }
}
