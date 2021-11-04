class Format {
  late var i, qty, unit;
  late String veg;
  int total = 24;

  Format(this.i, this.veg, this.qty, this.unit);

  String format() {
    if (veg.length >= 11) {
      return towLineFormat();
    } else {
      return inLineFormat();
    }
  }

  String getSl() {
    String sl = '$i';
    if (sl.length == 1) {
      sl = " $i";
    } else if (sl.length == 2) {
      sl = "$i";
    }
    return sl;
  }

  String indication() => i % 2 == 0 ? "_" : "_";

  String inLineFormat() {
    String sl = getSl();
    String first = sl + " " + veg;
    String second = ' $qty' + " $unit";
    int count = (total - first.length - second.length);
    String space = indication() * count;
//   print();
    String toReturn = first + space + second;
    return toReturn;
  }

  String towLineFormat() {
    // total 24 letter in font size 2

    List vegSplittedList = veg.split(" ");
    print(vegSplittedList);
    if (vegSplittedList.length >= 2) {
      String sl = getSl();
      String first = sl + " ";
      String second = ' $qty' + " $unit";
      String third = first + vegSplittedList[0] + second;
      int count = total - third.length;
      String space = indication() * count;
      String toReturn = first +
          vegSplittedList[0] +
          space +
          second +
          "    " +
          lastNameVegtable(vegSplittedList);
      return toReturn;
    } else {
      veg = veg.toString().substring(0, 10);
      return inLineFormat();
    }
  }
}

String lastNameVegtable(List vegSplittedList) {
  List dup = List.from(vegSplittedList);
  dup.removeAt(0);
  String s = dup.join(" ");
  String toReturn = s.replaceAll(RegExp(r'  '), " ");

  // s.replaceAll("", replace)
  return toReturn;
}
