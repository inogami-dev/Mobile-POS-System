import 'package:pos_system/features/sales/data/model/sales_model.dart';

List<Map<String, double>> weeklySalesView({required List<SalesModel> sales}) {
  // 1. Use a single Map to aggregate the total values per product
  Map<String, double> productTotals = {};

  // 2. Loop through and accumulate the totals
  for (var sale in sales) {
    for (var item in sale.particulars) {
      final parts = item.split(":");

      // Safety check to ensure the split actually found both parts
      if (parts.length >= 2) {
        String productName = parts[0].trim();
        // Safely parse the string to a double, defaulting to 0.0 if it fails
        double value = double.tryParse(parts[1].trim()) ?? 0.0;

        // Add the value to the existing total for this product
        if (productTotals.containsKey(productName)) {
          productTotals[productName] = productTotals[productName]! + value;
        } else {
          productTotals[productName] = value;
        }
      }
    }
  }

  // 3. Convert the Map to a List so we can sort it
  var sortedEntries = productTotals.entries.toList();

  // 4. Sort the list in descending order (highest value first)
  sortedEntries.sort((a, b) => b.value.compareTo(a.value));

  // 5. Take the top 10 and format them into your desired List of Maps
  List<Map<String, double>> top10Products = sortedEntries
      .take(10)
      .map((entry) => {entry.key: entry.value})
      .toList();

  return top10Products;
}
