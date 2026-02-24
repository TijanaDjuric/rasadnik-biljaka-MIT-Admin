import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skriptarnica_admin/models/dashboard_btn_model.dart';
import 'package:skriptarnica_admin/providers/theme_provider.dart';
import 'package:skriptarnica_admin/widgets/dashboard_btns.dart';
import 'package:skriptarnica_admin/widgets/title_text.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = '/DashboardScreen';
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      // Ako je tamna tema, koristi tamnu sivu, ako nije, koristi pastelno zelenu
      backgroundColor: themeProvider.getIsDarkTheme
          ? Theme.of(context).scaffoldBackgroundColor
          : const Color(0xFFF1F8E9),
      appBar: AppBar(
        backgroundColor: themeProvider.getIsDarkTheme
            ? Theme.of(context).cardColor
            : const Color(0xFFC8E6C9),
        title: TitleTextWidget(
          label: "Zeleni Raj - Admin",
          // Boja teksta se menja u zavisnosti od teme
          color: themeProvider.getIsDarkTheme ? Colors.white : Colors.black87,
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              themeProvider.setDarkTheme(
                themeValue: !themeProvider.getIsDarkTheme,
              );
            },
            icon: Icon(
              themeProvider.getIsDarkTheme ? Icons.light_mode : Icons.dark_mode,
              color: themeProvider.getIsDarkTheme
                  ? Colors.yellow
                  : Colors.black87,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(20),
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              children: List.generate(
                DashboardButtonsModel.dashboardBtnList(context).length,
                (index) => DashboardButtonsWidget(
                  text: DashboardButtonsModel.dashboardBtnList(
                    context,
                  )[index].text,
                  imagePath: DashboardButtonsModel.dashboardBtnList(
                    context,
                  )[index].imagePath,
                  onPressed: DashboardButtonsModel.dashboardBtnList(
                    context,
                  )[index].onPressed,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
