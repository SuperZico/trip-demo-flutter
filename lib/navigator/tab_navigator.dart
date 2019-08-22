import 'package:flutter/material.dart';
import 'package:demo/pages/home_page.dart';
import 'package:demo/pages/search_page.dart';
import 'package:demo/pages/travel_page.dart';
import 'package:demo/pages/my_page.dart';

class TabNavigator extends StatefulWidget {
  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  final _controller = PageController(initialPage: 0);
  final _defaultColor = Colors.grey;
  final _selectedColor = Colors.blue;
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        physics: new NeverScrollableScrollPhysics(), //禁止滚动
        children: <Widget>[
          HomePage(),
          SearchPage(
            hideLeft: true,
          ),
          TravelPage(),
          MyPage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            _controller.jumpToPage(index);
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: [
            bottomNavigationBarItem('首页', 0, Icons.home),
            bottomNavigationBarItem('搜索', 1, Icons.search),
            bottomNavigationBarItem('旅拍', 2, Icons.camera_alt),
            bottomNavigationBarItem('我的', 3, Icons.account_circle),
          ]),
    );
  }

  bottomNavigationBarItem(String title, int index, IconData icon) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: _defaultColor,
      ),
      activeIcon: Icon(
        icon,
        color: _selectedColor,
      ),
      title: Text(
        title,
        style: TextStyle(
            color: _currentIndex != index ? _defaultColor : _selectedColor),
      ),
    );
  }
}
