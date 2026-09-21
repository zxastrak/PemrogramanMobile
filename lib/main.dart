import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// Model data produk sederhana
class Product {
  final String title;
  final String subtitle;
  final int rawPrice; // harga angka untuk perhitungan
  final String description;

  const Product({
    required this.title,
    required this.subtitle,
    required this.rawPrice,
    required this.description,
  });

  String get price =>
      'Rp ${rawPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
}

/// Model data item keranjang
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resino - Katalog Produk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

// Global keranjang belanja dan Notifier untuk reaktivitas real-time
final ValueNotifier<List<CartItem>> cartNotifier =
    ValueNotifier<List<CartItem>>([]);

// =============================================================================
// MAIN NAVIGATION (Bottom Navigation Bar - Katalog & Keranjang)
// =============================================================================
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    KatalogScreen(),
    const CartScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<CartItem>>(
      valueListenable: cartNotifier,
      builder: (context, cartList, child) {
        final totalQuantity =
            cartList.fold<int>(0, (sum, item) => sum + item.quantity);
        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.store_outlined),
                selectedIcon: Icon(Icons.store),
                label: 'Katalog',
              ),
              NavigationDestination(
                icon: Badge(
                  label: Text('$totalQuantity'),
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
                selectedIcon: Badge(
                  label: Text('$totalQuantity'),
                  child: const Icon(Icons.shopping_cart),
                ),
                label: 'Keranjang',
              ),
            ],
          ),
        );
      },
    );
  }
}

// =============================================================================
// SCREEN 1 - BERANDA / KATALOG (StatelessWidget)
// =============================================================================
class KatalogScreen extends StatelessWidget {
  KatalogScreen({super.key});

  final List<Product> products = const [
    Product(
      title: 'Sabun Mandi Antiseptik',
      subtitle: 'Perlindungan kuman & kulit tetap lembut',
      rawPrice: 4500,
      description:
          'Sabun mandi cair antiseptik yang efektif membersihkan kulit dari kuman dan bakteri sekaligus menjaga kelembapan alami kulit sepanjang hari.',
    ),
    Product(
      title: 'Shampo Anti Ketombe',
      subtitle: 'Rambut segar & bebas ketombe seharian',
      rawPrice: 22000,
      description:
          'Shampo khusus dengan formula menthol dan ZPTO yang efektif menghilangkan ketombe, mengurangi rasa gatal, serta memberikan sensasi dingin menyegarkan di kulit kepala.',
    ),
    Product(
      title: 'Detergen Pakaian Konsentrat',
      subtitle: 'Bersih maksimal & wangi tahan lama',
      rawPrice: 18500,
      description:
          'Detergen bubuk konsentrat dengan teknologi anti-noda membandel dan aroma kesegaran bunga yang tahan lama hingga 14 hari.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resino - Katalog Produk'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text(
                product.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  '${product.subtitle}\n${product.price}',
                  style: TextStyle(color: Colors.grey[800]),
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailKatalogScreen(product: product),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// =============================================================================
// SCREEN 2 - DETAIL KATALOG (StatefulWidget)
// =============================================================================
class DetailKatalogScreen extends StatefulWidget {
  final Product product;

  const DetailKatalogScreen({super.key, required this.product});

  @override
  State<DetailKatalogScreen> createState() => _DetailKatalogScreenState();
}

class _DetailKatalogScreenState extends State<DetailKatalogScreen> {
  int _itemCount = 1;

  void _incrementCount() {
    setState(() {
      _itemCount++;
    });
  }

  void _decrementCount() {
    if (_itemCount > 1) {
      setState(() {
        _itemCount--;
      });
    }
  }

  void _addToCart() {
    final currentList = List<CartItem>.from(cartNotifier.value);
    final existingIndex = currentList
        .indexWhere((item) => item.product.title == widget.product.title);

    if (existingIndex >= 0) {
      currentList[existingIndex].quantity += _itemCount;
    } else {
      currentList.add(CartItem(product: widget.product, quantity: _itemCount));
    }

    cartNotifier.value = currentList;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${widget.product.title} ($_itemCount item) berhasil ditambahkan ke keranjang!',
        ),
        backgroundColor: Colors.green[700],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.product.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.product.price,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Deskripsi Singkat',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Jumlah:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton.filledTonal(
                      onPressed: _decrementCount,
                      icon: const Icon(Icons.remove),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        '$_itemCount',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed: _incrementCount,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _addToCart,
                icon: const Icon(Icons.shopping_cart),
                label: const Text(
                  'Tambah ke Keranjang',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// SCREEN 3 - KERANJANG & PEMBAYARAN (StatefulWidget)
// =============================================================================
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String formatCurrency(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  void _processPayment(int totalAmount) {
    if (cartNotifier.value.isEmpty) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.check_circle, size: 60, color: Colors.green),
          title: const Text('Pembayaran Berhasil!'),
          content: Text(
            'Pembayaran sebesar ${formatCurrency(totalAmount)} telah berhasil.\n\nTerima kasih telah berbelanja!',
            textAlign: TextAlign.center,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                cartNotifier.value = [];
                Navigator.pop(context);
              },
              child: const Text('Selesai'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: ValueListenableBuilder<List<CartItem>>(
        valueListenable: cartNotifier,
        builder: (context, cartList, child) {
          if (cartList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Keranjang Anda Masih Kosong',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Silakan pilih produk pada menu Katalog.',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          final totalAmount = cartList.fold(
            0,
            (sum, item) => sum + (item.product.rawPrice * item.quantity),
          );

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12.0),
                  itemCount: cartList.length,
                  itemBuilder: (context, index) {
                    final item = cartList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      child: ListTile(
                        title: Text(
                          item.product.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${item.product.price} x ${item.quantity} = ${formatCurrency(item.product.rawPrice * item.quantity)}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () {
                                final currentList =
                                    List<CartItem>.from(cartNotifier.value);
                                if (currentList[index].quantity > 1) {
                                  currentList[index].quantity--;
                                } else {
                                  currentList.removeAt(index);
                                }
                                cartNotifier.value = currentList;
                              },
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () {
                                final currentList =
                                    List<CartItem>.from(cartNotifier.value);
                                currentList[index].quantity++;
                                cartNotifier.value = currentList;
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Pembayaran:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          formatCurrency(totalAmount),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => _processPayment(totalAmount),
                        icon: const Icon(Icons.payment),
                        label: const Text(
                          'Bayar Sekarang',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
