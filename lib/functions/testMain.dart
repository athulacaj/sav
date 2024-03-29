void main() async {
  List a = [18, 6, 5, 12, 19];
  mergeSort(a, 1, 4);
}

List divideC(List a, int len, int i, int j, List result) {
  if (i == j) {
    return [a[i]];
  } else if (i == j + 1) {
    if (a[i] > a[j]) {
      return [a[j], a[i]];
    } else {
      return [a[j], a[i]];
    }
  } else {
    List list1 = divideC(a, len, i, ((i + j) / 2).floor(), result);
    List list2 = divideC(a, len, ((i + j) / 2).floor() + 1, j, result);
  }
  return [];
}

void merge(List list, int leftIndex, int middleIndex, int rightIndex) {
  int leftSize = middleIndex - leftIndex + 1;
  int rightSize = rightIndex - middleIndex;

  List leftList = new List.filled(leftSize, null, growable: false);
  List rightList = new List.filled(rightSize, null, growable: false);

  for (int i = 0; i < leftSize; i++) leftList[i] = list[leftIndex + i];
  for (int j = 0; j < rightSize; j++) rightList[j] = list[middleIndex + j + 1];

  int i = 0, j = 0;
  int k = leftIndex;

  while (i < leftSize && j < rightSize) {
    if (leftList[i] <= rightList[j]) {
      list[k] = leftList[i];
      i++;
    } else {
      list[k] = rightList[j];
      j++;
    }
    k++;
  }

  while (i < leftSize) {
    list[k] = leftList[i];
    i++;
    k++;
  }

  while (j < rightSize) {
    list[k] = rightList[j];
    j++;
    k++;
  }
}

void mergeSort(List list, int leftIndex, int rightIndex) {
  if (leftIndex < rightIndex) {
    int middleIndex = (rightIndex + leftIndex) ~/ 2;

    mergeSort(list, leftIndex, middleIndex);
    mergeSort(list, middleIndex + 1, rightIndex);

    merge(list, leftIndex, middleIndex, rightIndex);
    print(list);
  }
}
