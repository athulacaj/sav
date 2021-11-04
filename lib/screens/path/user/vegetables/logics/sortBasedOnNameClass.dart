class SortNameClass {
  List? itemDetails = [];
  late List<String> lettersList = [];
  SortNameClass(List? itemDetails) {
    this.itemDetails = itemDetails;
  }
  void sort() {
    lettersList = [];
    itemDetails!.sort((a, b) {
      addLetter(a['en']);
      addLetter(b['en']);
      return (delSpace(a['en'])).compareTo(delSpace(b['en']));
    });
    lettersList.sort();
  }

  List filterBaseOnLetter(String l) {
    List filterList = itemDetails!
        .where((data) => data['en'].toLowerCase().startsWith(l.toLowerCase()))
        .toList();
    print(filterList);
    return filterList;
  }

  List? clear() {
    return itemDetails;
  }

  void addLetter(String veg) {
    String l = veg[0].toUpperCase();
    if (!lettersList.contains(l)) lettersList.add(l);
  }

  String delSpace(String s) {
    String toReturn = s.replaceAll(RegExp(r' '), "");
    return toReturn.toLowerCase();
  }
  // int Function(Map<dynamic, dynamic>, Map<dynamic, dynamic>) sortF =
  //     (Map<dynamic, dynamic> a, Map<dynamic, dynamic> b) {
  //   return 1;
  // };
}
