import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app_with_flutter/src/data/model/favorite/favorite_model.dart';
import 'package:ecommerce_app_with_flutter/src/presentation/screens/export_screens.dart';
import 'package:ecommerce_app_with_flutter/src/services/api_call_service.dart';
import 'package:ecommerce_app_with_flutter/src/services/cart_provider.dart';
import 'package:ecommerce_app_with_flutter/src/services/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  await APICallService.getProduct();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FavoriteModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
      ],
      child: const App(),
    ),
  );
}
