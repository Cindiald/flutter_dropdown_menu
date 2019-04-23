import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_menu/_src/drapdown_common.dart';

typedef void DropdownMenuHeadTapCallback(int index);

typedef String GetItemLabel(dynamic data);

String defaultGetItemLabel(dynamic data) {
  if (data is String) return data;
  return data["title"];
}

class DropdownHeader extends DropdownWidget {
  final List<dynamic> titles;
  final int activeIndex;
  final DropdownMenuHeadTapCallback onTap;

  /// height of menu
  final double height;

  /// get label callback
  final GetItemLabel getItemLabel;

  DropdownHeader(
      {@required this.titles,
      this.activeIndex,
      DropdownMenuController controller,
      this.onTap,
      Key key,
      this.height: 46.0,
      GetItemLabel getItemLabel})
      : getItemLabel = getItemLabel ?? defaultGetItemLabel,
        assert(titles != null && titles.length > 0),
        super(key: key, controller: controller);

  @override
  DropdownState<DropdownWidget> createState() {
    return new _DropdownHeaderState();
  }
}

class _DropdownHeaderState extends DropdownState<DropdownHeader> {
  var _selected = [];
  int _activeIndex;
  List<dynamic> _titles;
  List<dynamic> _defaultTitles;

  Widget buildItem(
      BuildContext context, dynamic title, bool selected, int index) {
    final Color primaryColor = Color(0xFF3C7AFF);
    final Color unselectedColor = Colors.black;
    final GetItemLabel getItemLabel = widget.getItemLabel;// title 打开蓝色，未打开默认黑色，未打开有选中蓝色且显示缩略文字
    bool _isDefaultTitle = title == _defaultTitles[index];
    return new GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: new Padding(
          padding: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
          child: new DecoratedBox(
              decoration: new BoxDecoration(
//                  border: new Border(left: Divider.createBorderSide(context))
              ),
              child: new Container(
                child: _isDefaultTitle ? new Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: new Text(
                          getItemLabel(title),
                          style: new TextStyle(
                            color: selected ? primaryColor : unselectedColor,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis
                      ),
                    ),
                    _isDefaultTitle ? new Icon(
                      selected ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: selected ? primaryColor : unselectedColor,
                    ) : Container()
                ]): Container(
                  height: 46.0,
                  width: MediaQuery.of(context).size.width / 4 - 24,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  margin: EdgeInsets.symmetric(horizontal: 2.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xFFEFF4FF),
                    borderRadius: BorderRadius.all(Radius.circular(24.0))
                  ),
                  child: new Text(
                      getItemLabel(title),
                      style: new TextStyle(
                        color: primaryColor,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis
                  ),
                )
              ))),
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap(index);
          return;
        }
        if (controller != null) {
          if (_activeIndex == index) {
            controller.hide();
            setState(() {
              _activeIndex = null;
            });
          } else {
            controller.show(index);
          }
        }
        //widget.onTap(index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    final int activeIndex = _activeIndex;
    final List<dynamic> titles = _titles;
    final double height = widget.height;

    for (int i = 0, c = widget.titles.length; i < c; ++i) {
      list.add(buildItem(context, titles[i], i == activeIndex, i));
    }

    list = list.map((Widget widget) {
      return new Expanded(
        child: widget,
      );
    }).toList();

    final Decoration decoration = new BoxDecoration(
      border: new Border(
        bottom: Divider.createBorderSide(context),
      ),
    );

    return new DecoratedBox(
      decoration: decoration,
      child: new SizedBox(
          child: new Row(
            children: list,
          ),
          height: height),
    );
  }

  @override
  void initState() {
    _titles = widget.titles;
    _defaultTitles = json.decode(json.encode(widget.titles));
    super.initState();
  }

  @override
  void onEvent(DropdownEvent event) {
    switch (event) {
      case DropdownEvent.SELECT:
        {
          if (_activeIndex == null) return;
          String labelText = '';
          if(controller.data == null){
            labelText = _defaultTitles[controller.menuIndex];
          }else if(controller.data.length > 0){
            for(int i = 0; i < controller.data.length; i++){
              if(controller.data[i] != null && controller.data[i]["title"] != null){
                labelText += controller.data[i]["title"];
              }
              if(i < controller.data.length - 1){
                labelText += ',';
              }
            }
          }
//          print(labelText);
          setState(() {
            _activeIndex = null;
            String label = widget.getItemLabel(labelText);
            _titles[controller.menuIndex] = label;
          });
        }
        break;
      case DropdownEvent.HIDE:
        {
          if (_activeIndex == null) return;
          setState(() {
            _activeIndex = null;
          });
        }
        break;
      case DropdownEvent.ACTIVE:
        {
          if (_activeIndex == controller.menuIndex) return;
          setState(() {
            _activeIndex = controller.menuIndex;
          });
        }
        break;
      case DropdownEvent.RESET:
        {
          if (_activeIndex == null) return;
          setState(() {
            _activeIndex = null;
            String label = widget.getItemLabel(controller.data);
            _titles[controller.menuIndex] = label;
          });
        }
        break;
    }
  }
}
