import '../components/drug_colors.dart';
import '../components/drug_constants.dart';
import 'add_medicine/add_medicine_page.dart';
import 'history/history_page.dart';
import 'today/today_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pages = [const TodayPage(), const HistoryPage()];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: pagePadding,
        child: SafeArea(child: _pages[_currentIndex]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddMedicine,
        child: const Icon(CupertinoIcons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  BottomAppBar _buildBottomAppBar() {
    return BottomAppBar(
        child: SizedBox(
      height: kBottomNavigationBarHeight,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        CupertinoButton(
            onPressed: () => _onCurrentPage(0),
            child: Icon(
              CupertinoIcons.check_mark,
              color: _currentIndex == 0 ? DrugColors.primaryColor : Colors.grey,
            )),
        CupertinoButton(
            onPressed: () => _onCurrentPage(1),
            child: Icon(
              CupertinoIcons.text_badge_checkmark,
              color: _currentIndex == 1 ? DrugColors.primaryColor : Colors.grey,
            )),
      ]),
    ));
  }

  void _onCurrentPage(int pageIndex) {
    setState(() {
      _currentIndex = pageIndex;
    });
  }

  void _onAddMedicine() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AddMedicinePage(),
        ));
  }
}
