import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import './cart.dart';
import './product_detail.dart';
import '../../provider/product.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      if (!productProvider.isLoading && productProvider.products.isEmpty) {
        productProvider.getProducts();
      }
    });
  }

  int selectedSize = 0;

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Catalog'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              productProvider.getProducts();
            },
          ),
        ],
      ),
      body: productProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : productProvider.products.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Tidak ada data barang.'),
                      ElevatedButton(
                        onPressed: () {
                          productProvider.getProducts();
                        },
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CategoryButton(
                                category: 'all',
                                index: 0,
                                selectedSize: selectedSize,
                                onCategorySelected: (category) {
                                  setState(() {
                                    selectedSize = 0;
                                  });
                                },
                              ),
                              CategoryButton(
                                category: 'drink',
                                index: 1,
                                selectedSize: selectedSize,
                                onCategorySelected: (category) {
                                  setState(() {
                                    selectedSize = 1;
                                  });
                                },
                              ),
                              CategoryButton(
                                category: 'food',
                                index: 2,
                                selectedSize: selectedSize,
                                onCategorySelected: (category) {
                                  setState(() {
                                    selectedSize = 2;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        itemCount: productProvider.products
                            .where((product) =>
                                selectedSize == 0 ||
                                (selectedSize == 1 &&
                                    product.category == 'drink') ||
                                (selectedSize == 2 &&
                                    product.category == 'food'))
                            .length,
                        itemBuilder: (context, index) {
                          final filteredProducts = productProvider.products
                              .where((product) =>
                                  selectedSize == 0 ||
                                  (selectedSize == 1 &&
                                      product.category == 'drink') ||
                                  (selectedSize == 2 &&
                                      product.category == 'food'))
                              .toList();
                          final product = filteredProducts[index];
                          return GestureDetector(
                            onTap: () {
                              // product detail
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    productId: product.id,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                image: product.image != 'no-image.jpg'
                                    ? DecorationImage(
                                        image: NetworkImage(product.image),
                                        fit: BoxFit.cover,
                                        onError: (error, stackTrace) {
                                          const Icon(
                                            Icons.broken_image,
                                            size: 50,
                                          );
                                        },
                                      )
                                    : null,
                                color: product.image == 'no-image.jpg'
                                    ? Colors.grey
                                    : null,
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      color: Colors.black54,
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        'Rp. ${product.price}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.yellowAccent,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    left: 8,
                                    right: 8,
                                    child: Container(
                                      color: Colors.black54,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        product.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4.0,
                        ),
                      ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartScreen(),
              )).then((_) {
            if (mounted) {
              setState(() {});
            }
          });
        },
        backgroundColor: Color(0xFFA58E1E),
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String category;
  final int index;
  final int selectedSize;
  final Function(String) onCategorySelected;

  const CategoryButton({
    super.key,
    required this.category,
    required this.index,
    required this.selectedSize,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onCategorySelected(category);
      },
      child: Container(
        width: 96,
        height: 25,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selectedSize == index
              ? const Color(0xffC67C4E)
              : Colors.transparent,
          border: Border.all(color: const Color(0xffC67C4E)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          category.toUpperCase(),
          style: GoogleFonts.sora(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color:
                selectedSize == index ? Colors.white : const Color(0xffC67C4E),
          ),
        ),
      ),
    );
  }
}
