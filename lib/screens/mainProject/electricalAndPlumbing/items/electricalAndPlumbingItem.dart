// ignore_for_file: file_names

import 'package:engineering/custom_icons_icons.dart';
import 'package:engineering/model/itemModel.dart';
import 'package:flutter/material.dart';

class ElectricalAndPlumbingItems {
  static const electricalWorks =
      DrawerItem(title: 'Electrical Works', icon: CustomIcons.electrical);
  static const plumbingWorks =
      DrawerItem(title: 'Plumbing Works', icon: CustomIcons.plumbing);

  static final List<DrawerItem> all = [
    electricalWorks,
    plumbingWorks,
  ];
  static const List<String> listElectricalWorks = ['Roughing Ins', 'Fixtures'];
  static const List<String> listPlumbingWorks = ['Works', 'Fixtures'];
}
