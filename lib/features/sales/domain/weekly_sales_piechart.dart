import 'dart:developer';

import 'package:pos_system/features/sales/data/model/sales_model.dart';

/// Returns the top N sold items, and groups the rest into an "Others" category.
/// N is 5 by default. (This is 3 right now for easy testing).
List<Map<String, double>> weekly_sales_piechart({
  required List<SalesModel> sales,
  // int numberOfSalesToView = 10,
  int numberOfSalesToView = 3,
}) {
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
        productTotals[productName] =
            (productTotals[productName] ?? 0.0) + value;
      }
    }
  }

  // 3. Convert the Map to a List so we can sort it
  var sortedEntries = productTotals.entries.toList();

  // 4. Sort the list in descending order (highest value first)
  sortedEntries.sort((a, b) => b.value.compareTo(a.value));

  // 5. Process data for the Pie Chart
  List<Map<String, double>> chartData = [];

  // Check if we have more items than our limit
  if (sortedEntries.length <= numberOfSalesToView) {
    // If we have fewer or exactly 10 items, just return them all normally
    chartData = sortedEntries.map((e) => {e.key: e.value}).toList();
  } else {
    // Take the exact number of top items we want to view
    chartData = sortedEntries
        .take(numberOfSalesToView)
        .map((e) => {e.key: e.value})
        .toList();

    // Skip the top items, grab the rest, and calculate their total sum
    double othersTotal = sortedEntries
        .skip(numberOfSalesToView)
        .fold(0.0, (sum, entry) => sum + entry.value);

    // Append the combined "Others" slice to the end of the chart data
    chartData.add({"Others": othersTotal});
  }

  log("weeklySalesView returned a list of length: ${chartData.length}");
  return chartData;
}
