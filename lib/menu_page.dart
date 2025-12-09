import 'package:flutter/material.dart';
import 'menu_detail_page.dart';
import 'models/menu_item.dart';
import 'models/cart_item.dart';
import 'models/cart_manager.dart';
import 'cart_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MenuPage extends StatefulWidget {
  final String orderType;

  const MenuPage({super.key, required this.orderType});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  void _updateCart() {
    setState(() {});
  }

  int get cartCount {
    return CartManager.cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Menu (${widget.orderType})',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.black,
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartPage(
                        cartItems: CartManager.cartItems,
                        orderType: widget.orderType,
                      ),
                    ),
                  );
                  _updateCart();
                },
              ),
              if (cartCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$cartCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),

      // 🔹 BAGIAN UTAMA: Menampilkan menu dari Firestore
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('menu').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
  print('🔥 Error Firestore: ${snapshot.error}');
  return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
}

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // Convert snapshot Firestore ke List<MenuItem>
          final menuItems = snapshot.data!.docs.map((doc) {
            return MenuItem.fromFirestore(
              doc.id,
              doc.data() as Map<String, dynamic>,
            );
          }).toList();

          // 🔹 Tampilan daftar menu
          return ListView.builder(
            itemCount: menuItems.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final item = menuItems[index];
              final existingCartItem = CartManager.cartItems.firstWhere(
                (cartItem) => cartItem.menuItem.id == item.id,
                orElse: () => CartItem(menuItem: item, quantity: 0),
              );

              return Card(
                color: Colors.white,
                elevation: 0.3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.black12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  leading: Image.asset(item.image, width: 50, height: 50),
                  title: Text(
                    item.name,
                    style: const TextStyle(color: Colors.black),
                  ),
                  subtitle: Text(
                    'Rp ${item.price}',
                    style: const TextStyle(color: Colors.black54),
                  ),
                  trailing: SizedBox(
                    width: 110,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              if (existingCartItem.quantity > 1) {
                                existingCartItem.quantity--;
                              } else if (existingCartItem.quantity == 1) {
                                CartManager.cartItems.removeWhere(
                                  (cartItem) => cartItem.menuItem.id == item.id,
                                );
                              }
                            });
                          },
                        ),
                        Text(
                          '${existingCartItem.quantity}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.add_circle_outline,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              if (existingCartItem.quantity == 0) {
                                CartManager.cartItems.add(
                                  CartItem(menuItem: item, quantity: 1),
                                );
                              } else {
                                existingCartItem.quantity++;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MenuDetailPage(
                          item: item,
                          orderType: widget.orderType,
                        ),
                      ),
                    ).then((_) => _updateCart());
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
