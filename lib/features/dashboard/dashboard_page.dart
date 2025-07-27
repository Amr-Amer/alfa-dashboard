import 'package:alfa_dashboard/features/transaction/presentation/pages/transaction_page.dart';
import 'package:alfa_dashboard/features/user/presentation/pages/users_page.dart';
import 'package:alfa_dashboard/features/withdraw_requests/presentation/pages/withdraw_requests_screen.dart';
import 'package:flutter/material.dart';
import 'package:alfa_dashboard/responsive.dart';
import 'package:alfa_dashboard/features/main/presentation/pages/main_page.dart';
import 'package:alfa_dashboard/utils/constants.dart';
import 'package:alfa_dashboard/widgets/side_menu.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  int selectedIndex = 0;

  final List<Widget> pages = [
    MainPage(scaffoldKey: GlobalKey()),
    UsersPage(scaffoldKey: GlobalKey()),
    TransactionsPage(scaffoldKey: GlobalKey()),
    WithdrawRequestsScreen(),
  ];

  void _onMenuItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (_scaffoldKey.currentState!.isDrawerOpen) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenu(
        scaffoldKey: _scaffoldKey,
        selectedIndex: selectedIndex,
        onItemSelected: _onMenuItemSelected,
      ),
      backgroundColor: AppConstants.clrBackground,
      body: SafeArea(
        child: Row(
          children: [
            if (Responsive.isDesktop(context))
              SideMenu(
                scaffoldKey: _scaffoldKey,
                selectedIndex: selectedIndex,
                onItemSelected: _onMenuItemSelected,
              ),
            Expanded(
              flex: 10,
              child: pages[selectedIndex],
            ),
          ],
        ),
      ),
    );
  }
}
