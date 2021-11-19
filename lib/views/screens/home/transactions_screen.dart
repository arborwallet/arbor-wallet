import 'package:arbor/core/constants/arbor_colors.dart';
import 'package:arbor/core/constants/arbor_constants.dart';
import 'package:arbor/core/utils/app_utils.dart';
import 'package:arbor/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:arbor/core/constants/hive_constants.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:arbor/api/services.dart';
import 'package:url_launcher/url_launcher.dart';

class TransactionsSheet extends StatefulWidget {
  const TransactionsSheet(
      {required this.walletAddress, required this.precision});

  final String walletAddress;
  final int precision;

  @override
  _TransactionsSheetState createState() =>
      _TransactionsSheetState(walletAddress, precision);
}

class _TransactionsSheetState extends State<TransactionsSheet> {
  _TransactionsSheetState(this.walletAddress, this.precision);

  late final Box transactionsBox;
  final String walletAddress;
  final int precision;
  bool _fetchingTransactions = true;
  final walletService = WalletService();

  TransactionsGroup? transactionsGroupModel;

  @override
  void initState() {
    super.initState();
    // Get reference to an already opened box
    transactionsBox = Hive.box(HiveConstants.transactionsBox);

    _updateTransactions(delayInSeconds: 1);
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> _updateTransactions({int delayInSeconds = 0}) async {
    Future.delayed(Duration(seconds: delayInSeconds), () async {
      setState(() {
        _fetchingTransactions = true;
      });
      transactionsGroupModel =
          await walletService.fetchWalletTransactions(walletAddress);

      if (transactionsBox.containsKey(walletAddress)) {
        transactionsBox.delete(walletAddress);
      }
      transactionsBox.put(walletAddress, transactionsGroupModel);
      setState(() {
        _fetchingTransactions = false;
      });
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
                icon: Icon(
                  Icons.close,
                  color: ArborColors.white,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                'Transactions',
                style: TextStyle(
                  color: ArborColors.white,
                ),
              ),
              centerTitle: true,
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
                        splashColor: ArborColors.lightGreen,
                        backgroundColor: ArborColors.deepGreen,
                        child: Icon(Icons.refresh, color: ArborColors.white),
                        onPressed: () {
                          _updateTransactions();
                          debugPrint("Called refresh");
                        }),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                      heroTag: "btn2",
                      splashColor: ArborColors.lightGreen,
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
                  var transactionsList = [];

                  for (int i = 0; i < box.length; i++) {
                    try {
                      TransactionsGroup transactionsGroup = box.getAt(i);
                      if (transactionsGroup.address == walletAddress) {
                        transactionsList = transactionsGroup.transactionsList;
                      }
                    } on Exception catch (e) {
                      debugPrint(e.toString());
                    }
                  }

                  if ((transactionsList.length == 0 &&
                      _fetchingTransactions == true)) {
                    return Center(
                      child: Container(
                        height: 40,
                        width: 40,
                        child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              ArborColors.white),
                          strokeWidth: 3,
                        ),
                      ),
                    );
                  } else if (transactionsList.length == 0 &&
                      _fetchingTransactions == false) {
                    return Container(
                        padding: EdgeInsets.all(50),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Image.asset(
                                  'assets/images/transaction-light.png'),
                            ),
                            SizedBox(height: 30),
                            Flexible(
                              flex: 2,
                              child: Text(
                                'You have not sent or received anything yet. Go to a faucet and get some mojo.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: ArborColors.white,
                                ),
                              ),
                            ),
                          ],
                        ));
                  } else {
                    return Container(
                      child: GroupedListView<dynamic, dynamic>(
                        padding: const EdgeInsets.only(
                            bottom: kFloatingActionButtonMargin + 100),
                        elements: transactionsList,
                        groupBy: (element) => element.toUSDate(),
                        groupComparator: (value1, value2) =>
                            value2.compareTo(value1),
                        itemComparator: (item1, item2) =>
                            item1.timestamp.compareTo(item2.timestamp),
                        order: GroupedListOrder.DESC,
                        sort: true,
                        useStickyGroupSeparators: false,
                        groupHeaderBuilder: (dynamic value) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                value.toDateOnly(),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: ArborColors.white),
                              ),
                            ],
                          ),
                        ),
                        itemBuilder: (c, element) {
                          return Card(
                            color: ArborColors.green,
                            elevation: 1,
                            shadowColor: Colors.lightGreen,
                            margin: EdgeInsets.all(4),
                            child: ListTile(
                              //isThreeLine: true,
                              onTap: () => launchExplorer(
                                  url:
                                      "${ArborConstants.explorerBaseURL}/${element.address}"),
                              leading: Container(
                                width: 35,
                                height: 35,
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                    image: element.assetImageForType(),
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                              title: Text(
                                '${element.typeForDisplay()}',
                                style: TextStyle(
                                  color: ArborColors.white,
                                ),
                              ),
                              subtitle: Text(
                                //transaction.timeForDisplay(),
                                element.toTime(),
                                softWrap: false,
                                style: TextStyle(
                                  color: ArborColors.white70,
                                ),
                              ),
                              trailing: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    element.amountForDisplay(precision),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: ArborColors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(
                                      Icons.open_in_browser,
                                      color: ArborColors.white,
                                    ),
                                  ),
                                ],
                              ),
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

  launchExplorer({required String url}) async {
    try {
      await canLaunch(url)
          ? await launch(url)
          : AppUtils.showSnackBar(
              context, 'Unable to launch $url', ArborColors.errorRed);
    } on Exception catch (e) {
      AppUtils.showSnackBar(context, "${e.toString()}", ArborColors.errorRed);
    }
  }
}
