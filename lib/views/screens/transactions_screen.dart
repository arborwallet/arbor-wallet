import 'package:arbor/core/constants/arbor_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:arbor/core/constants/hive_constants.dart';
import 'package:arbor/models/models.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:arbor/api/services.dart';


class TransactionsSheet extends StatefulWidget {
  const TransactionsSheet({
    required this.walletAddress,
  });

  final String walletAddress;

  @override
  _TransactionsSheetState createState() =>
      _TransactionsSheetState(walletAddress);
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
      Transactions tr =
      await walletService.fetchWalletTransactions(walletAddress);
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
            backgroundColor: ArborColors.green,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                'Transactions',
                style: TextStyle(
                  color: ArborColors.white,
                ),
              ),
              backgroundColor: ArborColors.green,
            ),
            floatingActionButton: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: FloatingActionButton(
                        heroTag: "refresh",
                        backgroundColor: ArborColors.deepGreen,
                        child: Icon(Icons.refresh, color: ArborColors.white),
                        onPressed: () {
                          _updateTransactions();
                        }),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                      heroTag: "btn2",
                      backgroundColor: ArborColors.deepGreen,
                      child: Icon(Icons.close, color: ArborColors.white),
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

                  for (int i = 0; i < box.length; i++) {
                    Transactions tr = box.getAt(i);
                    if (tr.walletAddress == walletAddress) {
                      transactionsModel = tr;
                      transactionsList = tr.list;
                      break;
                    }
                  }

                  // if (box.isEmpty) {
                  if (transactionsList == null ||
                      transactionsList.length == 0) {
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
                        ));
                  } else {
                    return Container(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(
                            bottom: kFloatingActionButtonMargin + 100),
                        shrinkWrap: false,
                        itemCount: transactionsList.length,
                        itemBuilder: (context, index) {
                          Transaction transaction =
                          transactionsList!.elementAt(index);

                          return Card(
                            color: ArborColors.green,
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
                                  title:
                                    Text(
                                      '${transaction.typeForDisplay()}',
                                      style: TextStyle(
                                        color: ArborColors.white,
                                      ),
                                    ),
                                  subtitle: Text(
                                      transaction.timeForDisplay(),
                                      style: TextStyle(
                                        color: ArborColors.white70,
                                      ),
                                  ),
                                  trailing: Text(
                                    transaction.amountForDisplay(
                                        transactionsModel!.fork.precision),
                                    style:
                                      TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: ArborColors.white,
                                      ),
                                  ),
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
        });
  }
}
