import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kopi_verse/service/config.dart';
import 'package:provider/provider.dart';

import '../customer/catalog.dart';
import '../../provider/product.dart';
import '../../screen/all/upload.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
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

  @override
  void dispose() {
    super.dispose();
  }

  int selectedCategory = 0;
  int chooseCategory = 0;

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Products'),
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
              ? Center(child: Text('Product is empty'))
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
                                selectedSize: selectedCategory,
                                onCategorySelected: (category) {
                                  setState(() {
                                    selectedCategory = 0;
                                  });
                                },
                              ),
                              CategoryButton(
                                category: 'drink',
                                index: 1,
                                selectedSize: selectedCategory,
                                onCategorySelected: (category) {
                                  setState(() {
                                    selectedCategory = 1;
                                  });
                                },
                              ),
                              CategoryButton(
                                category: 'food',
                                index: 2,
                                selectedSize: selectedCategory,
                                onCategorySelected: (category) {
                                  setState(() {
                                    selectedCategory = 2;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: productProvider.products
                            .where((product) =>
                                selectedCategory == 0 ||
                                (selectedCategory == 1 &&
                                    product.category == 'drink') ||
                                (selectedCategory == 2 &&
                                    product.category == 'food'))
                            .length,
                        itemBuilder: (context, index) {
                          final filteredProducts = productProvider.products
                              .where((product) =>
                                  selectedCategory == 0 ||
                                  (selectedCategory == 1 &&
                                      product.category == 'drink') ||
                                  (selectedCategory == 2 &&
                                      product.category == 'food'))
                              .toList();
                          final product = filteredProducts[index];
                          return GestureDetector(
                            onDoubleTap: () {
                              // edit
                              final TextEditingController nameController =
                                  TextEditingController(text: product.name);
                              final TextEditingController detailController =
                                  TextEditingController(text: product.detail);
                              final TextEditingController priceController =
                                  TextEditingController(
                                      text: product.price.toString());
                              final TextEditingController categoryController =
                                  TextEditingController(text: product.category);

                              showDialog(
                                context: context,
                                builder: (ctx) {
                                  return AlertDialog(
                                    title: const Text('Edit Product'),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          TextField(
                                            controller: nameController,
                                            decoration: const InputDecoration(
                                                labelText: 'Product Name'),
                                          ),
                                          TextField(
                                            controller: detailController,
                                            decoration: const InputDecoration(
                                                labelText: 'Detail'),
                                            maxLines: null,
                                            keyboardType:
                                                TextInputType.multiline,
                                          ),
                                          TextField(
                                            controller: priceController,
                                            decoration: const InputDecoration(
                                                labelText: 'Price'),
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                          ),
                                          StatefulBuilder(
                                            builder: (context, setState) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    CategoryButton(
                                                      category: 'drink',
                                                      index: 0,
                                                      selectedSize:
                                                          chooseCategory,
                                                      onCategorySelected:
                                                          (category) {
                                                        setState(() {
                                                          chooseCategory = 0;
                                                          categoryController
                                                              .text = 'drink';
                                                        });
                                                      },
                                                    ),
                                                    CategoryButton(
                                                      category: 'food',
                                                      index: 1,
                                                      selectedSize:
                                                          chooseCategory,
                                                      onCategorySelected:
                                                          (category) {
                                                        setState(() {
                                                          chooseCategory = 1;
                                                          categoryController
                                                              .text = 'food';
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          final success = await productProvider
                                              .updateProduct(
                                            product.id,
                                            nameController.text,
                                            detailController.text,
                                            int.tryParse(
                                                    priceController.text) ??
                                                0,
                                            categoryController.text,
                                          );
                                          final errorMessage =
                                              productProvider.errorMessage;

                                          if (mounted) {
                                            Navigator.of(ctx).pop();
                                            if (success) {
                                              productProvider.getProducts();
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content:
                                                        Text(errorMessage)),
                                              );
                                            }
                                          }
                                        },
                                        child: const Text('Save'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: ListTile(
                                leading: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UploadScreen(
                                          title:
                                              'Upload Image For ${product.name}',
                                          productId: product.id,
                                        ),
                                      ),
                                    );
                                  },
                                  child: product.image != 'no-image.jpg'
                                      ? Image.network(
                                          '${Config.baseUrl}/assets/${product.image}',
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(Icons.broken_image,
                                                      size: 50),
                                        )
                                      : Image.asset('assets/images/p1.png',
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover),
                                ),
                                title: Text(product.name),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () async {
                                    // delete
                                    final confirm = await showDialog(
                                      context: context,
                                      builder: (ctx) {
                                        return AlertDialog(
                                          title: const Text('Confirm Deletion'),
                                          content: const Text(
                                              'Are you sure you want to delete this item?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(ctx).pop(false);
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(ctx).pop(true);
                                              },
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (confirm == true && mounted) {
                                      final context = this.context;
                                      final success = await productProvider
                                          .deleteProduct(product.id);
                                      if (success && mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Item successfully deleted',
                                            ),
                                          ),
                                        );
                                        productProvider
                                            .getProducts(); // Refresh list after deleting
                                      } else if (mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Failed to delete item')),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
      floatingActionButton: productProvider.isLoading
          ? null
          : FloatingActionButton(
              onPressed: () {
                final TextEditingController nameController =
                    TextEditingController();
                final TextEditingController detailController =
                    TextEditingController();
                final TextEditingController priceController =
                    TextEditingController();
                final TextEditingController categoryController =
                    TextEditingController();

                final productProvider =
                    Provider.of<ProductProvider>(context, listen: false);
                showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      title: const Text('Add New Product'),
                      content: SingleChildScrollView(
                        child: Column(
                          children: [
                            TextField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                  labelText: 'Product Name'),
                            ),
                            TextField(
                              controller: detailController,
                              decoration:
                                  const InputDecoration(labelText: 'Detail'),
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                            ),
                            TextField(
                              controller: priceController,
                              decoration:
                                  const InputDecoration(labelText: 'Price'),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            ),
                            StatefulBuilder(
                              builder: (context, setState) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      CategoryButton(
                                        category: 'drink',
                                        index: 0,
                                        selectedSize: chooseCategory,
                                        onCategorySelected: (category) {
                                          setState(() {
                                            chooseCategory = 0;
                                            categoryController.text = 'drink';
                                          });
                                        },
                                      ),
                                      CategoryButton(
                                        category: 'food',
                                        index: 1,
                                        selectedSize: chooseCategory,
                                        onCategorySelected: (category) {
                                          setState(() {
                                            chooseCategory = 1;
                                            categoryController.text = 'food';
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final success = await productProvider.addProduct(
                              nameController.text,
                              detailController.text,
                              int.tryParse(priceController.text) ?? 0,
                              categoryController.text,
                            );
                            final errorMessage = productProvider.errorMessage;

                            if (mounted) {
                              Navigator.of(ctx).pop();
                              if (success) {
                                productProvider.getProducts();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(errorMessage)),
                                );
                              }
                            }
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Icon(Icons.add),
            ),
    );
  }
}
