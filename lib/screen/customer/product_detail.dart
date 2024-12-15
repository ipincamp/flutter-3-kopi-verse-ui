import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kopi_verse/screen/customer/cart.dart';
import 'package:provider/provider.dart';

import '../../service/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final service = Provider.of<ProductService>(context, listen: false);
      service.getProductById(widget.productId);
    });
  }

  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(),
                  )).then((_) {
                setState(() {});
              });
            },
          ),
        ],
      ),
      body: Container(
        child: productService.isLoading
            ? const Center(child: CircularProgressIndicator())
            : productService.productDetail.id == ''
                ? const Center(child: Text('Product not found'))
                : Consumer<ProductService>(
                    builder: (context, productService, child) {
                    final product = productService.productDetail;

                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // gambar produk
                          Center(
                            child: Image(
                              image: AssetImage('assets/images/p1.png'),
                              alignment: Alignment.center,
                            ),
                          ),
                          /*
                          Image.network(
                            'https://example.com/product-image.jpg',
                            height: 200,
                          ),
                          */
                          SizedBox(height: 16),
                          // nama produk
                          Text(
                            product.name,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          /*
                          TODO: rating produk
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.yellow),
                              Icon(Icons.star, color: Colors.yellow),
                              Icon(Icons.star, color: Colors.yellow),
                              Icon(Icons.star, color: Colors.yellow),
                              Icon(Icons.star_border),
                              SizedBox(width: 8),
                              Text('4.0'),
                            ],
                          ),
                          */
                          SizedBox(height: 16),
                          // deskripsi produk
                          Text(
                            product.detail,
                            style: TextStyle(fontSize: 16),
                          ),
                          Spacer(),
                          // harga produk dan tombol add to cart
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: quantity > 1
                                        ? () {
                                            setState(() {
                                              quantity--;
                                            });
                                          }
                                        : null,
                                  ),
                                  SizedBox(
                                    width: 50,
                                    child: TextField(
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      controller: TextEditingController(
                                        text: '$quantity',
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          quantity = int.tryParse(value)!;
                                        });
                                      },
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        quantity++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              // add to cart
                              ElevatedButton(
                                onPressed: () async {
                                  final result = await productService.addToCart(
                                    product.id,
                                    quantity,
                                  );
                                  if (result) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Product added to cart successfully!'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Failed to add product to cart.'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).brightness ==
                                              Brightness.light
                                          ? const Color(0xffC67C4E)
                                          : Colors.transparent,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: const Color(0xffC67C4E),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  'Add to Cart',
                                  style: GoogleFonts.sora(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
      ),
    );
  }
}
