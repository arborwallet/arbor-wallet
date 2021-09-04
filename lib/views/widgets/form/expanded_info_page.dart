import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery/core/constants/asset_paths.dart';
import 'package:gallery/core/constants/hive_constants.dart';
import 'package:gallery/core/models/models.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
              // ignore: avoid_types_on_closure_parameters
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
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(AssetPaths.chiaLogo),
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
                          trailing: const Icon(Icons.copy),
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: walletData.balance.toStringAsFixed(walletData.fork.precision)));
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: const Text('Address'),
                          subtitle: Text(walletData.address),
                          trailing: const Icon(Icons.copy),
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: walletData.address));
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: const Text('Public Key'),
                          subtitle: Text(walletData.publicKey),
                          trailing: const Icon(Icons.copy),
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: walletData.publicKey));
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: const Text('Private Key'),
                          subtitle: Text('*' * walletData.privateKey.toString().length),
                          trailing: const Icon(Icons.copy),
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: walletData.privateKey));
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: const Text('Mnemonic'),
                          subtitle: Text('*' * walletData.phrase.toString().length),
                          trailing: const Icon(Icons.copy),
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: walletData.phrase));
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: const Text('Wallet Password'),
                          subtitle: Text('*' * walletData.password.toString().length),
                          trailing: const Icon(Icons.copy),
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: walletData.password));
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
                minimumSize: const Size(double.infinity, 30), // double.infinity is the width and 30 is the height
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return TransactionsSheet();
                  },
                );
              },
              child: const Text('All Transactions')
          ),
          ListTile(
            contentPadding: const EdgeInsets.all(10.0),//change for side padding
            title: Row(
              children: <Widget>[
                Expanded(child: ElevatedButton(onPressed: () {},child: const Text('Receive'))),
                const SizedBox(width: 10),
                Expanded(child: ElevatedButton(onPressed: () {},child: const Text('Send'))),
              ],
            ),
          )
        ]
    );
  }
}

class TransactionsSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.86,
        minChildSize: 0.6,
        builder: (context, scrollController) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Container(
              child: const Center(
                child: Text('Transactions!'),
              ),
            ),
          );
        }
    );
  }
}