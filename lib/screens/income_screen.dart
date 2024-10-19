import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kemanauangku/models/transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  List<TransactionModel> transactionList = [];
  int totalIncome = 0;
  int totalExpense = 0;

  @override
  void initState() {
    super.initState();
    _loadTransactions(); // Call it here to load transactions when the widget initializes
  }

  Future<void> _loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? transactionsJson = prefs.getStringList('transactions');

    if (transactionsJson != null) {
      // Decode the first five items and convert to TransactionModel objects
      transactionList = transactionsJson
          .map((transactionJson) {
            return TransactionModel.fromJson(jsonDecode(transactionJson));
          })
          .where((tr) => tr.type == TransactionType.income)
          .toList();

      for (var transactionJson in transactionsJson) {
        final transaction =
            TransactionModel.fromJson(jsonDecode(transactionJson));
        if (transaction.type == TransactionType.income) {
          totalIncome += transaction.amount;
        }
      }
    }

    setState(() {}); // Rebuild the UI to reflect the loaded transactions
  }

  Future<void> _deleteTransaction(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? transactionsJson = prefs.getStringList('transactions');

    if (transactionsJson != null && index < transactionsJson.length) {
      transactionsJson.removeAt(index); // Remove transaction at the given index
      await prefs.setStringList(
          'transactions', transactionsJson); // Save the updated list

      totalExpense = 0;
      totalIncome = 0;
      await _loadTransactions(); // Reload transactions after deletion
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Pemasukan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Column(
              children: [
                Card(
                  elevation: 0, // Adds shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4), // Rounded corners
                  ),
                  child: Container(
                    width: screenWidth * 1,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 0, 184, 70),
                        borderRadius: BorderRadius.circular(4)),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Total Pemasukan",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              )),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                              NumberFormat.currency(
                                      locale: 'id_ID',
                                      symbol: 'Rp',
                                      decimalDigits: 0)
                                  .format((totalIncome)),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (transactionList.isEmpty)
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Tidak ada transaksi.",
                        textAlign: TextAlign.center,
                      )
                    ],
                  )
                else
                  Column(
                    children: transactionList.asMap().entries.map((entry) {
                      int index = entry.key; // Get the index
                      final transaction =
                          entry.value; // Get the transaction object

                      return Column(
                        children: [
                          ListTile(
                            tileColor: const Color.fromARGB(255, 255, 255, 255),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            title: Text(
                              "${transaction.name} (${DateFormat("dd/MM/yyyy").format(transaction.date)})",
                              style: const TextStyle(fontSize: 12),
                            ),
                            subtitle: Text(
                              transaction.type == TransactionType.income
                                  ? "+${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(transaction.amount)}"
                                  : "-${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(transaction.amount)}",
                              style: TextStyle(
                                fontSize: 14,
                                color:
                                    transaction.type == TransactionType.income
                                        ? Colors.green
                                        : Colors.red,
                              ),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                // Implement delete functionality here
                                _deleteTransaction(index);
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ),
                          const SizedBox(height: 6),
                        ],
                      );
                    }).toList(),
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}
