import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens.dart';
import 'kelpico_store.dart';
import '../app/brand.dart';

class ProductApp extends StatelessWidget {
  const ProductApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => KelpicoStore()..init(),
      child: MaterialApp(
        title: 'Kelpico',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: cBg,
          appBarTheme: const AppBarTheme(backgroundColor: cSurface),
        ),
        home: const KelpicoMainScreen(),
      ),
    );
  }
}
