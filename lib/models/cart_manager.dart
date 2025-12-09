import 'cart_item.dart';

class CartManager {
  static final List<CartItem> _cartItems = [];

  static List<CartItem> get cartItems => _cartItems;

  static void addToCart(CartItem newItem) {
    // Cek apakah item sudah ada, kalau iya tambahkan quantity
    final existing = _cartItems.where(
      (i) => i.menuItem.name == newItem.menuItem.name,
    );
    if (existing.isNotEmpty) {
      existing.first.quantity += newItem.quantity;
    } else {
      _cartItems.add(newItem);
    }
  }

  static void clearCart() {
    _cartItems.clear();
  }
}
