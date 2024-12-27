import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../service/config.dart';
import './order.dart';
import '../../common/text_util.dart';
import '../../provider/cart.dart';
import '../../provider/order.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      if (!cartProvider.isLoading && cartProvider.carts.isEmpty) {
        cartProvider.getCartItems();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              cartProvider.getCartItems();
            },
          ),
        ],
      ),
      body: cartProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : cartProvider.carts.isEmpty
              ? const Center(
                  child: Text('No item in cart'),
                )
              : ListView.builder(
                  itemCount: cartProvider.carts.length,
                  itemBuilder: (context, index) {
                    final cart = cartProvider.carts[index];
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
                            showDialog(
                              context: context,
                              builder: (context) {
                                int newQuantity = cart.itemQuantity;
                                TextEditingController quantityController =
                                    TextEditingController(
                                        text: newQuantity.toString());
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      title: Text(cart.productName),
                                      content: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.remove),
                                            onPressed: () {
                                              if (newQuantity > 1) {
                                                setState(() {
                                                  newQuantity--;
                                                  quantityController.text =
                                                      newQuantity.toString();
                                                });
                                              }
                                            },
                                          ),
                                          ConstrainedBox(
                                            constraints: BoxConstraints(
                                              minWidth: 50,
                                              maxWidth: 100,
                                            ),
                                            child: TextField(
                                              controller: quantityController,
                                              keyboardType:
                                                  TextInputType.number,
                                              onChanged: (value) {
                                                newQuantity =
                                                    int.tryParse(value) ??
                                                        newQuantity;
                                                setState(() {});
                                              },
                                              decoration: const InputDecoration(
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 8),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.add),
                                            onPressed: () {
                                              setState(() {
                                                newQuantity++;
                                                quantityController.text =
                                                    newQuantity.toString();
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            final changed = await cartProvider
                                                .updateCartItem(
                                              cart.itemId,
                                              newQuantity,
                                            );
                                            if (changed) {
                                              Navigator.of(context).pop();
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Failed to update cart'),
                                                ),
                                              );
                                            }
                                          },
                                          child: const Text('Save'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                          child: ListTile(
                            leading: Image.network(
                              '${Config.baseUrl}/assets/${cart.productImage}',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(cart.productName),
                                Text('x${cart.itemQuantity}'),
                              ],
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Rp ${cart.productPrice}/pcs'),
                                Text(
                                    'Rp ${cart.productPrice * cart.itemQuantity}'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
      bottomNavigationBar: cartProvider.isLoading
          ? null
          : cartProvider.carts.isEmpty
              ? null
              : BottomAppBar(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rp ${cartProvider.carts.fold(0, (sum, cart) => sum + (cart.productPrice * cart.itemQuantity)).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        orderProvider.isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () async {
                                  final success =
                                      await orderProvider.createOrder();
                                  final barcode = orderProvider.barcode;
                                  final total = orderProvider.total;

                                  if (success) {
                                    cartProvider.getCartItems();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OrderScreen(
                                          barcode: barcode,
                                          total: total,
                                        ),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text(orderProvider.errorMessage),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.grey[800]
                                          : const Color(0xffC67C4E),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: TextUtil(
                                  text: "Order",
                                  color: Colors.white,
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
