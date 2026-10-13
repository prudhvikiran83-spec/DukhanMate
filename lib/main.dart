
import 'package:flutter/material.dart';

void main() => runApp(const DukhanMateApp());

const green = Color(0xFF16845B);

class DukhanMateApp extends StatelessWidget {
  const DukhanMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DukhanMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: green),
        scaffoldBackgroundColor: const Color(0xFFF5F8F6),
      ),
      home: const HomePage(),
    );
  }
}

class Product {
  String name;
  double price;
  int stock;

  Product(this.name, this.price, this.stock);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedTab = 0;
  final List<Product> products = [];

  void addProduct(String name, double price, int stock) {
    setState(() {
      products.add(Product(name, price, stock));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: green,
        foregroundColor: Colors.white,
        title: const Text(
          'DukhanMate',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: selectedTab == 1
          ? productsPage()
          : dashboardPage(),
      floatingActionButton: selectedTab == 1
          ? FloatingActionButton.extended(
              backgroundColor: green,
              foregroundColor: Colors.white,
              onPressed: showAddProduct,
              icon: const Icon(Icons.add),
              label: const Text('Add Product'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedTab,
        onDestinationSelected: (index) {
          setState(() => selectedTab = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Products',
          ),
        ],
      ),
    );
  }

  Widget dashboardPage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Welcome back! 👋',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text('Your shop at a glance'),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: green,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('TODAY’S SALES',
                  style: TextStyle(color: Colors.white70)),
              SizedBox(height: 8),
              Text(
                '₹0.00',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('Sales tracking will be added with billing.',
                  style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          color: Colors.white,
          child: ListTile(
            leading: const Icon(Icons.inventory_2, color: green),
            title: const Text('Products in your shop'),
            subtitle: Text('${products.length} products added'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => setState(() => selectedTab = 1),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          color: Colors.white,
          child: const ListTile(
            leading: Icon(Icons.receipt_long, color: green),
            title: Text('Billing'),
            subtitle: Text('Customer billing is our next feature.'),
          ),
        ),
      ],
    );
  }

  Widget productsPage() {
    if (products.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inventory_2_outlined,
                  size: 64, color: Colors.grey),
              SizedBox(height: 12),
              Text(
                'No products yet',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text('Tap Add Product to add your first item.'),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          color: Colors.white,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFE0F2E9),
              child: const Icon(Icons.inventory_2, color: green),
            ),
            title: Text(product.name),
            subtitle: Text(
              'Price: ₹${product.price.toStringAsFixed(2)}'
              '  •  Stock: ${product.stock}',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                setState(() => products.removeAt(index));
              },
            ),
          ),
        );
      },
    );
  }

  void showAddProduct() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add Product'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Product name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? 'Enter product name'
                          : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: priceController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Selling price (₹)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final price = double.tryParse(value ?? '');
                    if (price == null || price <= 0) {
                      return 'Enter a price above zero';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: stockController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Stock quantity',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final stock = int.tryParse(value ?? '');
                    if (stock == null || stock < 0) {
                      return 'Enter a valid quantity';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: green),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                addProduct(
                  nameController.text.trim(),
                  double.parse(priceController.text),
                  int.parse(stockController.text),
                );
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product added!')),
                );
              }
            },
            child: const Text('Save Product'),
          ),
        ],
      ),
    );
  }
}
