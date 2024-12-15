import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:kopi_verse/screen/splash/splash.dart';
import 'package:kopi_verse/service/product.dart';
import 'package:provider/provider.dart';

void main() => runApp(
  DevicePreview(
    enabled: true,
    builder: (context) => MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductService()),
      ],
      child: const MyApp(),
    ),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kopi Verse',
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
