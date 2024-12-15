import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kopi_verse/service/product.dart';
import 'package:provider/provider.dart';

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
      final service = Provider.of<ProductService>(context, listen: false);
      service.getProducts();
    });
  }

  void filterCategory(String category) {
    final productService = Provider.of<ProductService>(context, listen: false);
    if (category == 'all') {
      productService.getProducts();
    } else {
      productService.filterByCategory(category);
    }
  }

  int selectedSize = 0;

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Catalog'),
        actions: [],
      ),
      body: Column(
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
                        filterCategory(category);
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
                        filterCategory(category);
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
                        filterCategory(category);
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
            child: productService.isLoading
              ? const Center(child: CircularProgressIndicator())
              : productService.productList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Tidak ada data barang.'),
                          ElevatedButton(
                            onPressed: () {
                              productService.getProducts();
                            },
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      itemCount: productService.productList.length,
                      itemBuilder: (context, index) {
                        final barang = productService.productList[index];
                        return GestureDetector(
                          onTap: () {
                            // _showEditBarangDialog(context, barang);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              image: barang.image != 'no-image.jpg'
                                ? DecorationImage(
                                    image: AssetImage('assets/images/p1.png'),
                                    fit: BoxFit.cover,
                                  )
                                /*
                                DecorationImage(
                                  image: NetworkImage(
                                    '$server/images/${barang.image}',
                                  ),
                                  fit: BoxFit.cover,
                                  onError: (error, stackTrace) =>
                                    const Icon(Icons.broken_image, size: 50),
                                )
                                */
                                : null,
                              color: barang.image == 'no-image.jpg' ? Colors.grey : null,
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
                                      'Rp. ${barang.price}',
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
                                      barang.name,
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
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 4, // Add spacing between columns
                        mainAxisSpacing: 4.0, // Add spacing between rows
                      ),
                    ),
          ),
        ],
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
          color: selectedSize == index ? const Color(0xffC67C4E) : Colors.transparent,
          border: Border.all(color: const Color(0xffC67C4E)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          category.toUpperCase(),
          style: GoogleFonts.sora(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: selectedSize == index ? Colors.white : const Color(0xffC67C4E),
          ),
        ),
      ),
    );
  }
}
