import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import './login.dart';
import '../admin/cashier.dart';
import '../admin/customer.dart';
import '../admin/product.dart';
import '../admin/report.dart';
import '../all/profile.dart';
import '../cashier/transaction.dart';
import '../cashier/transaction_history.dart';
import '../customer/cart.dart';
import '../customer/catalog.dart';
import '../customer/order_history.dart';

class HomeScreen extends StatefulWidget {
  final String role;

  const HomeScreen({
    super.key,
    required this.role,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  late Future<String?> _userRoleFuture;

  final List<Widget> _customerPages = [
    OrderHistoryScreen(),
    CatalogScreen(),
    ProfileScreen(role: 'customer'),
  ];

  final List<Widget> _adminPages = [
    ProductScreen(),
    CashierScreen(),
    ReportScreen(),
    CustomerScreen(),
    ProfileScreen(role: 'admin'),
  ];

  final List<Widget> _cashierPages = [
    TransactionHistoryScreen(),
    TransactionScreen(),
    ProfileScreen(role: 'cashier'),
  ];

  @override
  void initState() {
    super.initState();
    _userRoleFuture = Future.value(widget.role);
  }

  // getter role
  String get role => widget.role;

  List<Widget> _getPages(String role) {
    switch (role) {
      case 'admin':
        return _adminPages;
      case 'cashier':
        return _cashierPages;
      case 'customer':
      default:
        return _customerPages;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _userRoleFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // handle if user role is not found
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
          return const SizedBox.shrink();
        } else {
          final role = snapshot.data ?? 'customer';
          final pages = _getPages(role);

          return Scaffold(
            floatingActionButton: role == 'customer'
                ? FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CartScreen(),
                          )).then((_) {
                        if (mounted) {
                          setState(() {});
                        }
                      });
                    },
                    backgroundColor: Color(0xFFA58E1E),
                    child: Icon(Icons.shopping_cart),
                  )
                : null,
            bottomNavigationBar: CurvedNavigationBar(
              key: _bottomNavigationKey,
              index: 0,
              items: pages.map((page) {
                int index = pages.indexOf(page);
                IconData icon;
                switch (role) {
                  case 'admin':
                    icon = [
                      Icons.production_quantity_limits,
                      Icons.people_rounded,
                      Icons.report,
                      Icons.people,
                      Icons.person,
                    ][index];
                    break;
                  case 'cashier':
                    icon = [
                      Icons.history,
                      Icons.attach_money,
                      Icons.person
                    ][index];
                    break;
                  case 'customer':
                  default:
                    icon = [
                      Icons.history,
                      Icons.coffee_rounded,
                      Icons.person,
                    ][index];
                    break;
                }
                return Icon(icon, size: 30);
              }).toList(),
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : Colors.white,
              buttonBackgroundColor:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.white,
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? (Colors.grey[900] ?? Colors.black)
                  : Color(0xFF5B3D2E),
              animationCurve: Curves.easeInOut,
              animationDuration: Duration(milliseconds: 600),
              onTap: (index) {
                setState(() {
                  _page = index;
                });
              },
              letIndexChange: (index) => true,
            ),
            body: pages[_page],
          );
        }
      },
    );
  }
}
