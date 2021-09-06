import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:arbor/hive_constants.dart';
import 'package:arbor/models/models.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:flutter/services.dart';
import 'package:arbor/views/screens/transactions_screen.dart';
import 'package:arbor/views/screens/password_qr_share_screen.dart';

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
  _deleteInfo(int index) {
    walletBox.deleteAt(index);

    print('Item deleted from box at index: $index');
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
              Expanded(child: ElevatedButton(onPressed: () {},child: Text('Receive'))),
              SizedBox(width: 10),
              Expanded(child: ElevatedButton(onPressed: () {},child: Text('Send'))),
            ],
          ),
        )
      ]
    );
  }
}
