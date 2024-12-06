import 'package:ecommerce_app_with_flutter/src/data/model/cart/cart_model.dart';
import 'package:flutter/foundation.dart';
import 'package:ecommerce_app_with_flutter/src/data/helper/database/helper_db.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider extends ChangeNotifier {
  DatabaseHelper dbHlper = DatabaseHelper.instance;
  int _counter = 0;
  int _quantity = 0;

  int get counter => _counter;
  int get quantity => _quantity;

  double _totalPrice = 0.0;

  double get totalPrice => _totalPrice;

  List<Cart> cart = [];

  Future<List<Cart>> getCartData() async {
    cart = await dbHlper.getCartList();
    notifyListeners();
    return cart;
  }

  void _setPrefsItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cart_items', _counter);
    prefs.setInt('item_quantity', _quantity);
    prefs.setDouble('total_price', _totalPrice);
    notifyListeners();
  }

  void _getPrefsItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cart_items') ?? 0;
    _quantity = prefs.getInt('item_quantity') ?? 1;
    _totalPrice = prefs.getDouble('total_price') ?? 0;
  }

  void addToCounter() {
    _counter++;
    _setPrefsItems();
    notifyListeners();
  }

  void removeFromCounter() {
    _counter--;
    _setPrefsItems();
    notifyListeners();
  }

  int getCounter() {
    _getPrefsItems();
    return _counter;
  }

  void addQuantity(int id) {
    final index = cart.indexWhere((element) => element.id == id);
    cart[index].quantity!.value = cart[index].quantity!.value + 1;
    _setPrefsItems();
    notifyListeners();
  }

  void deleteQuantity(int id) {
    final index = cart.indexWhere((element) => element.id == id);
    final currentQuantity = cart[index].quantity!.value;
    if (currentQuantity <= 1) {
      currentQuantity == 1;
    } else {
      cart[index].quantity!.value = currentQuantity - 1;
    }
    _setPrefsItems();
    notifyListeners();
  }

  void removeItem(int id) {
    final index = cart.indexWhere((element) => element.id == id);
    cart.removeAt(index);
    _setPrefsItems();
    notifyListeners();
  }

  int getQuantity(int quantity) {
    _getPrefsItems();
    return _quantity;
  }

  void addTotalPrice(double productPrice) {
    _totalPrice += productPrice;
    notifyListeners();
    _setPrefsItems();
  }

  void removeTotalPrice(double productPrice) {
    _totalPrice -= productPrice;
    _setPrefsItems();
    notifyListeners();
  }

  double getTotalPrice() {
    _getPrefsItems();
    return _totalPrice;
  }

  String _selectedCurrency = 'USD';
  final Map<String, double> _exchangeRates = {
    'USD': 1.0,
    'EUR': 0.85,
    'GBP': 0.73,
    'JPY': 110.0,
    'IDR': 14500.0,
  };

  void setCurrency(String currency) {
    _selectedCurrency = currency;
    notifyListeners();
  }

  String getCurrencySymbol() {
    switch (_selectedCurrency) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'JPY':
        return '¥';
      case 'IDR':
        return 'Rp';
      default:
        return '\$';
    }
  }

  double getConvertedPrice() {
    return totalPrice * _exchangeRates[_selectedCurrency]!;
  }
}
