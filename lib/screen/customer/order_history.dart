import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './order_detail.dart';
import '../../provider/order.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      if (!orderProvider.isLoading && orderProvider.orders.isEmpty) {
        orderProvider.getAllOrders();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              orderProvider.getAllOrders();
            },
          ),
        ],
      ),
      body: orderProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : orderProvider.orders.isEmpty
              ? const Center(
                  child: Text('No orders yet!'),
                )
              : ListView.builder(
                  itemCount: orderProvider.orders.length,
                  itemBuilder: (context, index) {
                    final order = orderProvider.orders[index];
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
                                builder: (context) => OrderDetailScreen(
                                  orderId: order.barcode,
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
                                    order.barcode,
                                    style: TextStyle(color: textColor),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    order.status,
                                    style: TextStyle(color: textColor),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              'Rp ${order.totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                              style: TextStyle(color: textColor),
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
