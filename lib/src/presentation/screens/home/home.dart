import 'package:ecommerce_app_with_flutter/src/data/model/product_model.dart';
import 'package:ecommerce_app_with_flutter/src/presentation/screens/export_screens.dart';
import 'package:ecommerce_app_with_flutter/src/presentation/screens/product_details/product_details.dart';
import 'package:ecommerce_app_with_flutter/src/presentation/widgets/export_widgets.dart';
import 'package:ecommerce_app_with_flutter/src/services/api_call_service.dart';
import 'package:ecommerce_app_with_flutter/src/services/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';

import '../../../core/app_bar_colors.dart';
import '../../../data/model/favorite/favorite_model.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<ProductModel>? _products = [];
  int _selectedIndex = 0; // Menyimpan indeks menu yang dipilih

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    _products = (await APICallService.getProduct());
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update indeks saat item ditekan
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 252, 252),
      appBar: _selectedIndex == 0
          ? _buildAppBar()
          : null, // Tampilkan AppBar hanya di halaman Home
      body: IndexedStack(
        // Menggunakan IndexedStack untuk menjaga state
        index: _selectedIndex,
        children: [
          _buildHomePage(), // Halaman utama
          const FavoritePage(), // Halaman favorit
          const ProfilePage(), // Halaman profil
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(UniconsLine.estate),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(UniconsLine.heart),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(UniconsLine.user),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xff76bbaa),
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget _buildHomePage() {
    return _products == null || _products!.isEmpty
        ? const Center(
            child: CircularProgressIndicator(
              color: Color(0xff76bbaa),
            ),
          )
        : SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      alignment: Alignment.bottomCenter,
                      image: AssetImage('assets/promo_02.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: 180,
                  alignment: Alignment.bottomCenter,
                  child: const PromoContainer(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    children: [
                      const Categories(),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Best Sale Product',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const TextButton(
                              onPressed: null,
                              child: Text(
                                'See more',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  color: Color(0xff76bbaa),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Wrap(
                  children: List.generate(_products!.length, (index) {
                    return Consumer<FavoriteModel>(
                        builder: (_, favorie, child) {
                      return ProductCard(
                        addToFavorite: () {
                          Provider.of<FavoriteModel>(_, listen: false).add(
                            _products![index],
                          );
                        },
                        isFavorite: favorie.items.contains(_products![index])
                            ? false
                            : true,
                        onpress: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ProductDetails(
                                productInfo: _products![index],
                              ),
                            ),
                          );
                        },
                        producInfo: ProductModel(
                            id: _products![index].id,
                            title: _products![index].title,
                            price: _products![index].price,
                            description: _products![index].description,
                            category: _products![index].category,
                            image: _products![index].image,
                            rating: Rating(
                                rate: _products![index].rating.rate,
                                count: _products![index].rating.count)),
                      );
                    });
                  }),
                ),
              ],
            ),
          );
  }

  PreferredSizeWidget _buildAppBar() {
    // Mengembalikan PreferredSizeWidget
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
      systemOverlayStyle: AppBarColors.darkIcons,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: SearchBox(
              autoFocus: false,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) => const SearchPage())));
              },
            ),
          ),
          SizedBox(
            height: 40,
            child: Consumer<CartProvider>(
              builder: (_, cart, child) {
                return Row(children: [
                  AppBarButton(
                    icon: UniconsLine.shopping_bag,
                    itemSize: cart.getCounter(),
                    onPress: () {
                      _goToCartPage();
                    },
                  ),
                  AppBarButton(
                    icon: UniconsLine.bell,
                    itemSize: 0,
                    onPress: () {},
                  ),
                ]);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _goToCartPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const CartPage()));
  }
}
