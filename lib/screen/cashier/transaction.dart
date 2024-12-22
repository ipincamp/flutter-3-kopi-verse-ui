import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../provider/order.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final TextEditingController _barcodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      orderProvider.resetOrder();
    });
  }

  void _checkBarcode() {
    if (_barcodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Barcode cannot be empty')),
      );
      return;
    }

    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.getOrderByBarcode(_barcodeController.text);
    setState(() {
      orderProvider.isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => setState(() {
              orderProvider.resetOrder();
            }),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            orderProvider.isLoading
                ? const CircularProgressIndicator()
                : Row(
                    children: orderProvider.order.items.isEmpty
                        ? [
                            Expanded(
                              child: TextField(
                                controller: _barcodeController,
                                decoration: const InputDecoration(
                                  labelText: 'Enter Barcode',
                                ),
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: _checkBarcode,
                              child: const Text('Check'),
                            ),
                          ]
                        : [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(orderProvider.order.barcode),
                                  SizedBox(height: 10),
                                  Text(
                                    'Rp ${orderProvider.order.total.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    List<String> statusOptions;
                                    switch (orderProvider.order.status) {
                                      case 'wait': // waiting for checking by cashier
                                        statusOptions = ['prep', 'cancel'];
                                        break;
                                      case 'prep': // waiting for payment
                                        statusOptions = ['ready', 'cancel'];
                                        break;
                                      case 'ready': // already paid, ready to craft
                                        statusOptions = ['done'];
                                        break;
                                      case 'done': // already crafted, ready to serve
                                        statusOptions = [];
                                        break;
                                      case 'cancel': // order is canceled
                                        statusOptions = [];
                                        break;
                                      default:
                                        statusOptions = [
                                          'wait',
                                          'prep',
                                          'ready',
                                          'done',
                                          'cancel'
                                        ];
                                    }

                                    return AlertDialog(
                                      title: const Text('Change Status'),
                                      content: statusOptions.isEmpty
                                          ? const Text(
                                              'No available status changes')
                                          : DropdownButton<String>(
                                              value: statusOptions.contains(
                                                      orderProvider
                                                          .order.status)
                                                  ? orderProvider.order.status
                                                  : null,
                                              items: statusOptions
                                                  .map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                if (newValue != null) {
                                                  orderProvider
                                                      .updateOrderByBarcode(
                                                          orderProvider
                                                              .order.barcode,
                                                          newValue,
                                                          '');
                                                  Navigator.pop(context);
                                                }
                                              },
                                            ),
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffC67C4E),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide.none,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                orderProvider.order.status,
                                style: GoogleFonts.nunito(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ]),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Consumer<OrderProvider>(
                  builder: (context, orderProvider, _) {
                    if (orderProvider.isLoading) {
                      return const SizedBox();
                    } else if (orderProvider.order.items.isEmpty) {
                      return const SizedBox();
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: orderProvider.order.items.length,
                        itemBuilder: (context, index) {
                          final item = orderProvider.order.items[index];

                          return ListTile(
                            title: Text(item.productName),
                            subtitle: Text('Rp ${item.productPrice}/pcs'),
                            trailing: Text(
                              'x${item.quantity}',
                              style: const TextStyle(fontSize: 20),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
