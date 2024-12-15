import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail'),
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
                              Text(
                                'Rp ${product.price}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              /*
                              ElevatedButton(
                                onPressed: () {
                                  // aksi tambah ke keranjang
                                },
                                child: Text('Add to Cart'),
                              ),
                              */
                              ElevatedButton(
                                onPressed: () {
                                  //
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
