quantityFormat(var quantity, String unit) {
  if (unit.toLowerCase() == 'g') {
    if (quantity < 1000) {
      return '$quantity g';
    }
    if (quantity >= 1000) {
      return '${quantity / 1000} kg';
    }
  }
  if (unit.toLowerCase() == 'kg') {
    return '$quantity kg';
  }
  if (unit.toLowerCase() == 'pkt') {
    return '$quantity Pkt';
  }

  return '$quantity';
}
