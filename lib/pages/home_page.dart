import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:demo/dao/home_dao.dart';
import 'package:demo/widget/grid_nav.dart';
import 'package:demo/widget/local_nav.dart';
import 'package:demo/model/common_model.dart';
import 'package:demo/model/grid_nav_model.dart';
import 'package:demo/widget/sub_nav.dart';
import 'package:demo/widget/sales_box.dart';
import 'package:demo/model/sales_box_model.dart';
import 'package:demo/widget/loading_container.dart';
import 'package:demo/widget/webview.dart';
import 'package:demo/widget/search_bar.dart';
import 'package:demo/pages/search_page.dart';

const APPBAR_SCROLL_OFFSET = 100;
const SEARCH_BAR_DEFAULT_TEXT = '网红打卡地 景点 酒店 美食';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double appBarAlpha = 0;
  List<CommonModel> bannerList = [];
  List<CommonModel> localNavList = [];
  List<CommonModel> subNavList = [];
  GridNavModel gridNav;
  SalesBoxModel salesBoxModel;
  bool _loading = true;

  _onScroll(offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
  }

  Future<dynamic> _handlerRefresh() {
    return HomeDao.fetch().then((result) {
      setState(() {
        bannerList = result.bannerList;
        localNavList = result.localNavList;
        gridNav = result.gridNav;
        subNavList = result.subNavList;
        salesBoxModel = result.salesBox;
        _loading = false;
      });
    }).catchError((error) {
      setState(() {
        _loading = false;
      });
    });
//    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _handlerRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        //用于设置浮层，层级后在前的上面
        body: LoadingContainer(
            child: Stack(
              children: <Widget>[
                MediaQuery.removePadding(
                    //用于去除四周的padding，让异形屏也可以顶边
                    removeTop: true,
                    context: context,
                    child: RefreshIndicator(
                        child: NotificationListener(
                            //监听列表的滚动
                            //找到最底层的滚动
                            //滚动而且是列表滚动的时候
                            onNotification: (scrollNotification) {
                              if (scrollNotification
                                      is ScrollUpdateNotification &&
                                  scrollNotification.depth == 0) {
                                _onScroll(scrollNotification.metrics.pixels);
                              }
                              return false;
                            },
                            child: _listView),
                        onRefresh: _handlerRefresh)),
                _appBar
              ],
            ),
            isLoading: _loading));
  }

  Widget get _appBar {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0x66000000), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            height: 80.0,
            decoration: BoxDecoration(
                color:
                    Color.fromARGB((appBarAlpha * 255).toInt(), 255, 255, 255)),
            child: SearchBar(
              searchBarType: appBarAlpha > 0.2
                  ? SearchBarType.homeLight
                  : SearchBarType.home,
              inputBoxClick: _jumpToSearch,
              speakClick: _jumpToSpeak,
              defaultText: SEARCH_BAR_DEFAULT_TEXT,
              leftButtonClick: () {},
            ),
          ),
        ),
        Container(
          height: appBarAlpha > 0.2 ? 0.5 : 0,
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 0.5)]),
        )
      ],
    );
  }

  Widget get _listView {
    return ListView(
      children: <Widget>[
        _banner,
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: LocalNav(
            localNavList: localNavList,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child: GridNav(gridNavModel: gridNav),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child: SubNav(subNavList: subNavList),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
            child: SalesBox(salesBox: salesBoxModel)),
      ],
    );
  }

  Widget get _banner {
    return Container(
      height: 180,
      child: Swiper(
        onTap: (index) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            CommonModel model = bannerList[index];
            return WebView(
              url: model.url,
              title: model.title,
              hideAppBar: model.hideAppBar,
            );
          }));
        },
        itemCount: bannerList.length,
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            bannerList[index].icon,
            fit: BoxFit.fill,
          );
        },
        pagination: SwiperPagination(),
      ),
    );
  }

  _jumpToSearch() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SearchPage()));
  }

  _jumpToSpeak() {}
}
