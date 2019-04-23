import 'package:flutter/material.dart';
import '../../../common/widgets/common_app_bar.dart';
import '../../../theme/waka.dart';
import 'package:dropdown_menu/dropdown_menu.dart';

class Demo extends StatefulWidget {
@override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DemoState();
  }
}

class DemoState extends State<Demo> {
  static const List<Map<String, dynamic>> BRANDS = [
    {"title": "品牌1"},
    {"title": "品牌11"},
    {"title": "品牌111"},
  ];
  static const List<Map<String, dynamic>> PLATFORMS = [
    {"title": "平台1"},
    {"title": "平台11"},
    {"title": "平台111"},
  ];
  static const List<Map<String, dynamic>> SERIES = [
    {"title": "品系1"},
    {"title": "品系11"},
    {"title": "品系111"},
  ];

  static const int BRAND_INDEX = 0;
  static const int PLATFORM_INDEX = 0;
  static const int SERIES_INDEX = 0;

  DropdownMenu buildDropdownMenu() {
    return new DropdownMenu(maxMenuHeight: kDropdownMenuItemHeight * 10, multi: true,
        menus: [
          new DropdownMenuBuilder(
              builder: (BuildContext context) {
                return new DropdownListMenu(
                  selectedIndex: BRAND_INDEX,
                  data: BRANDS,
                  itemBuilder: buildCheckItem,
                );
              },
              height: kDropdownMenuItemHeight * BRANDS.length),
          new DropdownMenuBuilder(
              builder: (BuildContext context) {
                return new DropdownListMenu(
                  selectedIndex: PLATFORM_INDEX,
                  data: PLATFORMS,
                  itemBuilder: buildCheckItem,
                );
              },
              height: kDropdownMenuItemHeight * PLATFORMS.length),
          new DropdownMenuBuilder(
              builder: (BuildContext context) {
                return new DropdownListMenu(
                  selectedIndex: SERIES_INDEX,
                  data: SERIES,
                  itemBuilder: buildCheckItem,
                );
              },
              height: kDropdownMenuItemHeight * SERIES.length),
        ]);
  }
  DropdownHeader buildDropdownHeader({DropdownMenuHeadTapCallback onTap}) {
    return new DropdownHeader(
      onTap: onTap,
      titles: ['品牌', '平台', '品系'],
    );
  }
  Widget buildFixHeaderDropdownMenu() {
    return new DefaultDropdownMenuController(
        child: new Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: buildDropdownHeader(),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                        border: new Border(
                          left: Divider.createBorderSide(context),
                        )
                    ),
//                    color: WakaColors.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
//                            key.currentState.openEndDrawer();
                          },
                          child: Text('筛选'),
                        ),
//                        ImgBtn(
//                            height: 44.0,
//                            onPressed: () {
//                              key.currentState.openEndDrawer();
//                            },
//                            img: Image.asset(
//                              'assets/images/icons/filter@2x.png',
//                              width: 24.0,
//                            ))
                      ],
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  ListView(
                    children: List.generate(15, (index){
                      return Container(
                        height: 48.0,
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.1)))
                        ),
                        child: Text(index.toString()),
                      );
                    }),
                  ),
                  buildDropdownMenu(),
                ],
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: buildCommonAppBar(context, title: 'dropdown test'),
      body: new Container(
        color: Colors.white,
        child: buildFixHeaderDropdownMenu()
      ),
    );
  }
}
