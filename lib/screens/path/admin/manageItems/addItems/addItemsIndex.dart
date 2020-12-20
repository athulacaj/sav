import 'package:flutter/material.dart';

import 'addItems.dart';

class AddItemsIndex extends StatefulWidget {
  @override
  _AddItemsIndexState createState() => _AddItemsIndexState();
}

class _AddItemsIndexState extends State<AddItemsIndex>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(
                  text: 'Vegetables',
                ),
                Tab(
                  text: 'Dry Fish',
                ),
              ],
            ),
            Expanded(
                child: TabBarView(
              controller: _tabController,
              children: [
                AddItems('vegetables'),
                AddItems('driedFish'),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
