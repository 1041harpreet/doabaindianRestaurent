import 'package:flutter/material.dart';
import 'package:restaurent_app/config/config.dart';
import 'package:scrollable_list_tabview/model/scrollable_list_tab.dart';
import 'package:scrollable_list_tabview/scrollable_list_tabview.dart';

class CategoryDetail extends StatelessWidget {
  const CategoryDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: AppConfig.secmainColor,
      body: Column(
        children: [
          Container(height: 100.0,),
          Expanded(
            child: ScrollableListTabView(
              tabHeight: 48,
              bodyAnimationDuration: const Duration(milliseconds: 150),
              tabAnimationCurve: Curves.easeOut,
              tabAnimationDuration: const Duration(milliseconds: 200),
              tabs: [
                ScrollableListTab(
                    tab: ListTab(
                        label: Text('Label 1'),
                        icon: Icon(Icons.group),
                        showIconOnList: false),
                    body: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (_, index) => ListTile(
                        leading: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.grey),
                          alignment: Alignment.center,
                          child: Text(index.toString()),
                        ),
                        title: Text('List element $index'),
                      ),
                    )),
                ScrollableListTab(
                    tab: ListTab(label: Text('Label 2'), icon: Icon(Icons.subject)),
                    body: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (_, index) => Card(
                        child: Center(child: Text('Card element $index')),
                      ),
                    )),
                ScrollableListTab(
                    tab: ListTab(
                        label: Text('Label 3'),
                        icon: Icon(Icons.subject),
                        showIconOnList: true),
                    body: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (_, index) => Card(
                        child: Center(child: Text('Card element $index')),
                      ),
                    )),
                ScrollableListTab(
                    tab: ListTab(label: Text('Label 4'), icon: Icon(Icons.add)),
                    body: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (_, index) => ListTile(
                        leading: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.grey),
                          alignment: Alignment.center,
                          child: Text(index.toString()),
                        ),
                        title: Text('List element $index'),
                      ),
                    )),
                ScrollableListTab(
                    tab: ListTab(label: Text('Label 5'), icon: Icon(Icons.group)),
                    body: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (_, index) => ListTile(
                        leading: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.grey),
                          alignment: Alignment.center,
                          child: Text(index.toString()),
                        ),
                        title: Text('List element $index'),
                      ),
                    )),
                ScrollableListTab(
                    tab: ListTab(label: Text('Label 6'), icon: Icon(Icons.subject)),
                    body: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (_, index) => Card(
                        child: Center(child: Text('Card element $index')),
                      ),
                    )),
                ScrollableListTab(
                    tab: ListTab(
                        label: Text('Label 7'),
                        icon: Icon(Icons.subject),
                        showIconOnList: true),
                    body: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (_, index) => Card(
                        child: Center(child: Text('Card element $index')),
                      ),
                    )),
                ScrollableListTab(
                    tab: ListTab(label: Text('Label 8'), icon: Icon(Icons.add)),
                    body: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (_, index) => ListTile(
                        leading: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.grey),
                          alignment: Alignment.center,
                          child: Text(index.toString()),
                        ),
                        title: Text('List element $index'),
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
    )

    );
  }
}
