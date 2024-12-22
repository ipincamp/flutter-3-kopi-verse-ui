import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './transaction_detail.dart';
import '../../provider/order.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final transactionProvider =
          Provider.of<OrderProvider>(context, listen: false);
      if (!transactionProvider.isLoading) {
        transactionProvider.getAllOrders();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              transactionProvider.getAllOrders();
            },
          ),
        ],
      ),
      body: transactionProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : transactionProvider.orders.isEmpty
              ? const Center(
                  child: Text('No transactions yet!'),
                )
              : ListView.builder(
                  itemCount: transactionProvider.orders.length,
                  itemBuilder: (context, index) {
                    final transaction = transactionProvider.orders[index];
                    final textColor =
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Container(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? (index % 2 == 0
                                ? Colors.grey[800]
                                : Colors.grey[700])
                            : (index % 2 == 0
                                ? Colors.grey[300]
                                : Colors.grey[400]),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TransactionDetailScreen(
                                  transactionId: transaction.barcode,
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            leading: Icon(Icons.history, color: textColor),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    transaction.barcode,
                                    style: TextStyle(color: textColor),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    transaction.status,
                                    style: TextStyle(color: textColor),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Rp ${transaction.totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                                  style: TextStyle(color: textColor),
                                ),
                                Text(
                                  transaction.date,
                                  style: TextStyle(color: textColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
