import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../provider/order.dart';

class TransactionDetailScreen extends StatefulWidget {
  final String transactionId;

  const TransactionDetailScreen({
    super.key,
    required this.transactionId,
  });

  @override
  State<TransactionDetailScreen> createState() =>
      TransactionDetailScreenState();
}

class TransactionDetailScreenState extends State<TransactionDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderProvider>(context, listen: false)
          .getOrderByBarcode(widget.transactionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Detail'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              transactionProvider.getOrderByBarcode(widget.transactionId);
            },
          ),
        ],
      ),
      body: transactionProvider.isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : transactionProvider.errorMessage.isNotEmpty
              ? Center(
                  child: Text(transactionProvider.errorMessage),
                )
              : transactionProvider.order.barcode.isEmpty
                  ? Center(
                      child: Text('No order found'),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'DATE      ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(text: ' '),
                                    TextSpan(
                                        text: transactionProvider.order.date),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'ORDER   ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(text: ' '),
                                        TextSpan(
                                            text: transactionProvider
                                                .order.barcode),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.copy),
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(
                                          text: transactionProvider
                                              .order.barcode));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text('Barcode copied!'),
                                      ));
                                    },
                                  ),
                                ],
                              ),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'TOTAL    ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(text: ' '),
                                    TextSpan(
                                      text:
                                          'Rp ${transactionProvider.order.total.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} (${transactionProvider.order.status})',
                                    ),
                                  ],
                                ),
                              ),
                              if (transactionProvider.order.notes != null)
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'NOTE     ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(text: ':'),
                                      TextSpan(
                                          text:
                                              transactionProvider.order.notes),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: transactionProvider.order.items.length,
                            itemBuilder: (context, index) {
                              final item =
                                  transactionProvider.order.items[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2.0),
                                child: Container(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? (index % 2 == 0
                                          ? Colors.grey[800]
                                          : Colors.grey[700])
                                      : (index % 2 == 0
                                          ? Colors.grey[300]
                                          : Colors.grey[400]),
                                  child: ListTile(
                                    leading: const Icon(Icons.shopping_cart),
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(item.productName),
                                        Text('x${item.quantity}'),
                                      ],
                                    ),
                                    subtitle: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Rp ${item.productPrice}/pcs'),
                                        Text(
                                            'Rp ${item.productPrice * item.quantity}'),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
    );
  }
}
