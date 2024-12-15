import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:kopi_verse/screen/auth/login.dart';
import 'package:kopi_verse/screen/customer/order_history.dart';
import 'package:kopi_verse/screen/customer/cart.dart';
import 'package:kopi_verse/screen/customer/catalog.dart';
import 'package:kopi_verse/screen/admin/product.dart';
import 'package:kopi_verse/screen/admin/customer.dart';
import 'package:kopi_verse/screen/admin/cashier.dart';
import 'package:kopi_verse/screen/admin/report.dart';
import 'package:kopi_verse/screen/cashier/transaction.dart';
import 'package:kopi_verse/screen/cashier/transaction_history.dart';
import 'package:kopi_verse/screen/profile.dart';
import 'package:kopi_verse/service/storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
    ProfileScreen(),
  ];

  final List<Widget> _adminPages = [
    ProductScreen(),
    CashierScreen(),
    ReportScreen(),
    CustomerScreen(),
    ProfileScreen(),
  ];

  final List<Widget> _cashierPages = [
    TransactionHistoryScreen(),
    TransactionScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _userRoleFuture = _loadUserRole();
  }

  Future<String?> _loadUserRole() async {
    try {
      return await Storage.take('auth_role');
    } catch (e) {
      return null;
    }
  }

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
                        setState(() {});
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
                    icon = [Icons.history, Icons.attach_money, Icons.person][index];
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
              buttonBackgroundColor: Theme.of(context).brightness == Brightness.dark
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
