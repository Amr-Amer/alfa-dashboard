import 'package:alfa_dashboard/core/models/menu_model.dart';
import 'package:alfa_dashboard/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:alfa_dashboard/utils/constants.dart';
import 'package:alfa_dashboard/widgets/gradient_icon.dart';

class SideMenu extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final int selectedIndex;
  final void Function(int index) onItemSelected;

  const SideMenu({
    super.key,
    required this.scaffoldKey,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: 200,
      decoration: BoxDecoration(
        border: const Border(
          right: BorderSide(color: Color(0xFF202529), width: 1),
        ),
        color: AppConstants.clrBoxBackground,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Logo/Header
            const SizedBox(height: 40),
            Row(
              children: [
                GradientIcon(icon: Icons.circle, size: 50),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      AppStrings.appName,
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Text(
                      "Management",
                      style: TextStyle(fontSize: 10, color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Main Menu Items
            Expanded(
              child: Column(
                children: [
                  for (int i = 0; i < menu.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                      child: InkWell(
                        onTap: () {
                          onItemSelected(i);
                          scaffoldKey.currentState!.closeDrawer();
                        },
                        child: Row(
                          children: [
                            selectedIndex == i
                                ? GradientIcon(icon: menu[i].icon, size: 20)
                                : Icon(menu[i].icon, size: 20, color: AppConstants.clrSmallText),
                            const SizedBox(width: 10),
                            Text(
                              menu[i].title,
                              style: selectedIndex == i
                                  ? TextStyle(
                                fontSize: 14,
                                foreground: Paint()
                                  ..shader = LinearGradient(
                                    colors: [
                                      AppConstants.clrGradient1,
                                      AppConstants.clrGradient2,
                                    ],
                                  ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                              )
                                  : TextStyle(
                                fontSize: 14,
                                color: AppConstants.clrSmallText,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Bottom Menu Items
            for (int i = 0; i < bottomMenu.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                child: Row(
                  children: [
                    Icon(bottomMenu[i].icon, size: 20, color: AppConstants.clrSmallText),
                    const SizedBox(width: 10),
                    Text(
                      bottomMenu[i].title,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppConstants.clrSmallText,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
