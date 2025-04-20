import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });
}

class ShopTab extends StatefulWidget {
  const ShopTab({super.key});

  @override
  State<ShopTab> createState() => _ShopTabState();
}

class _ShopTabState extends State<ShopTab> with SingleTickerProviderStateMixin {
  final List<Product> products = [
    Product(
      id: '1',
      name: 'Whey Protein',
      description: 'High-quality protein powder for muscle recovery',
      price: 49.99,
      imageUrl: 'https://example.com/whey.jpg',
      category: 'Protein',
    ),
    Product(
      id: '2',
      name: 'BCAA Complex',
      description: 'Essential amino acids for muscle preservation',
      price: 29.99,
      imageUrl: 'https://example.com/bcaa.jpg',
      category: 'Amino Acids',
    ),
    Product(
      id: '3',
      name: 'Pre-Workout',
      description: 'Energy boost for intense workouts',
      price: 39.99,
      imageUrl: 'https://example.com/preworkout.jpg',
      category: 'Energy',
    ),
    // Add more products as needed
  ];

  final List<String> categories = [
    'All',
    'Protein',
    'Amino Acids',
    'Energy',
    'Recovery',
    'Vitamins',
  ];

  String selectedCategory = 'All';
  List<CartItem> cartItems = [];

  // Add animation controller for cart actions
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Add this method for cart animation
  Future<void> _animateCartAdd() async {
    await _animationController.forward();
    await _animationController.reverse();
  }

  // Update addToCart method
  void addToCart(Product product) async {
    await _animateCartAdd();
    setState(() {
      final existingItem = cartItems.firstWhere(
        (item) => item.product.id == product.id,
        orElse: () => CartItem(product: product, quantity: 0),
      );

      if (existingItem.quantity == 0) {
        cartItems.add(CartItem(product: product));
      } else {
        existingItem.quantity++;
      }
    });

    // Enhanced feedback
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text('${product.name} added to cart'),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          action: SnackBarAction(
            label: 'View Cart',
            onPressed: () => _showCart(context),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shop'),
          actions: [
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    _showCart(context);
                  },
                ),
                if (cartItems.isNotEmpty)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        cartItems.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            // Categories
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(categories[index]),
                      selected: selectedCategory == categories[index],
                      onSelected: (selected) {
                        setState(() {
                          selectedCategory = categories[index];
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            // Products Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  if (selectedCategory == 'All' ||
                      product.category == selectedCategory) {
                    return _buildProductCard(product);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        Icons.fitness_center,
                        size: 50,
                        color: Colors.grey[400],
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          product.category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => addToCart(product),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add_shopping_cart, size: 16),
                            SizedBox(width: 4),
                            Text('Add'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCart(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            double total = cartItems.fold(
              0,
              (sum, item) => sum + (item.product.price * item.quantity),
            );

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Shopping Cart',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: cartItems.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.shopping_cart_outlined,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Your cart is empty',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: cartItems.length,
                            padding: const EdgeInsets.all(16),
                            itemBuilder: (context, index) {
                              final item = cartItems[index];
                              return Dismissible(
                                key: Key(item.product.id),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  color: Colors.red,
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                onDismissed: (direction) {
                                  setState(() {
                                    cartItems.removeAt(index);
                                  });
                                },
                                child: Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    title: Text(item.product.name),
                                    subtitle: Text(
                                      '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () {
                                            setState(() {
                                              if (item.quantity > 1) {
                                                item.quantity--;
                                              } else {
                                                cartItems.removeAt(index);
                                              }
                                            });
                                          },
                                        ),
                                        Text(
                                          item.quantity.toString(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () {
                                            setState(() {
                                              item.quantity++;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, -3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total:',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$${total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: cartItems.isEmpty
                                ? null
                                : () {
                                    // Handle checkout
                                  },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Proceed to Checkout',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
} 