import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kopi_verse/screen/all/upload.dart';
import 'package:provider/provider.dart';

import '../../provider/product.dart';
import '../customer/catalog.dart';

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

  int selectedCategory = 0;
  int chooseCategory = 0;

/*
  Future<void> _showEditBarangDialog(BuildContext context, var barang) async {
    final kdBarangController = TextEditingController(text: barang.kdBarang);
    final namaController = TextEditingController(text: barang.nama);
    final merekController = TextEditingController(text: barang.merek);
    final hargaController =
        TextEditingController(text: barang.harga.toString());
    final stokController = TextEditingController(text: barang.stok.toString());

    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Edit Barang'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: kdBarangController,
                  decoration: const InputDecoration(labelText: 'Kode Barang'),
                ),
                TextField(
                  controller: namaController,
                  decoration: const InputDecoration(labelText: 'Nama Barang'),
                ),
                TextField(
                  controller: merekController,
                  decoration: const InputDecoration(labelText: 'Merek'),
                ),
                TextField(
                  controller: hargaController,
                  decoration: const InputDecoration(labelText: 'Harga'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: stokController,
                  decoration: const InputDecoration(labelText: 'Stok'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (mounted) {
                  Navigator.of(ctx).pop();
                }
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final success = await productProvider.editBarang(
                  id: barang.id,
                  kdBarang: kdBarangController.text,
                  nama: namaController.text,
                  merek: merekController.text,
                  harga: int.tryParse(hargaController.text) ?? 0,
                  stok: int.tryParse(stokController.text) ?? 0,
                );

                // Memastikan widget masih aktif sebelum menampilkan notifikasi
                if (mounted) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Barang berhasil diperbarui')),
                    );
                    productProvider.fetchBarang(); // Refresh list after editing
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Gagal memperbarui barang')),
                    );
                  }
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context, String id) async {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    final confirm = await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Apakah Anda yakin akan menghapus data ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop(true);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirm == true && mounted) {
      final success = await productProvider.deleteBarang(id);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Barang berhasil dihapus')),
        );
        productProvider.fetchBarang(); // Refresh list after deleting
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus barang')),
        );
      }
    }
  }
*/

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
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Tidak ada data barang.'),
                      ElevatedButton(
                        onPressed: () {
                          // productProvider.fetchBarang();
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
                            onTap: () {
                              // _showEditBarangDialog(context, product);
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: ListTile(
                                leading: product.image != 'no-image.jpg'
                                    ? Image.network(
                                        'http://127.0.0.1:8000/assets/fYsxYhcM9RNfexuruboFkDxhFZ8hisFQN4DCBtEL.png',
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(Icons.broken_image,
                                                    size: 50),
                                      )
                                    : const Icon(Icons.image_not_supported,
                                        size: 50),
                                title: Text(product.name),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    // _confirmDelete(context, product.id);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final TextEditingController nameController = TextEditingController();
          final TextEditingController detailController =
              TextEditingController();
          final TextEditingController priceController = TextEditingController();
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
                        decoration:
                            const InputDecoration(labelText: 'Product Name'),
                      ),
                      TextField(
                        controller: detailController,
                        decoration: const InputDecoration(labelText: 'Detail'),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                      ),
                      TextField(
                        controller: priceController,
                        decoration: const InputDecoration(labelText: 'Price'),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      StatefulBuilder(
                        builder: (context, setState) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          // uploading product image
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UploadScreen(
                                title: 'Upload Image For ${productProvider.productName}',
                                productId: productProvider.productId,
                              ),
                            ),
                          );
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
