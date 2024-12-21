import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/order.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailScreen({
    super.key,
    required this.orderId,
  });

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderProvider>(context, listen: false)
          .getOrderByBarcode(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Detail'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              orderProvider.getOrderByBarcode(widget.orderId);
            },
          ),
        ],
      ),
      body: orderProvider.getIsLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : orderProvider.getErrorMessage.isNotEmpty
              ? Center(
                  child: Text(orderProvider.getErrorMessage),
                )
              : orderProvider.order.barcode.isEmpty
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
                                  style: TextStyle(color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text: 'DATE      ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(text: ' '),
                                    TextSpan(text: orderProvider.order.date),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text: 'ORDER   ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(text: ' '),
                                    TextSpan(text: orderProvider.order.barcode),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text: 'TOTAL    ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(text: ' '),
                                    TextSpan(
                                      text:
                                          'Rp ${orderProvider.order.total.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} (${orderProvider.order.status})',
                                    ),
                                  ],
                                ),
                              ),
                              if (orderProvider.order.notes != null)
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(color: Colors.black),
                                    children: [
                                      TextSpan(
                                        text: 'NOTE     ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(text: ':'),
                                      TextSpan(text: orderProvider.order.notes),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: orderProvider.order.items.length,
                            itemBuilder: (context, index) {
                              final item = orderProvider.order.items[index];
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
                                  child: GestureDetector(
                                    onTap: () {
                                      //
                                    },
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
