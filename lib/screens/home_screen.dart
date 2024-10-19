import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kemanauangku/models/transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      transactionList = transactionsJson.take(5).map((transactionJson) {
        return TransactionModel.fromJson(jsonDecode(transactionJson));
      }).toList();

      for (var transactionJson in transactionsJson) {
        final transaction =
            TransactionModel.fromJson(jsonDecode(transactionJson));
        if (transaction.type == TransactionType.income) {
          totalIncome += transaction.amount;
        } else {
          totalExpense += transaction.amount;
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hi, Selamat Datang di",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    )),
                Text("KemanaUangku",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                      color: Colors.black,
                    )),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
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
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(4)),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Saldo",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.black87,
                              )),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                              NumberFormat.currency(
                                      locale: 'id_ID',
                                      symbol: 'Rp',
                                      decimalDigits: 0)
                                  .format((totalIncome - totalExpense)),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 0, // Adds shadow
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(4), // Rounded corners
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 0, 184, 70),
                              borderRadius: BorderRadius.circular(4)),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Pemasukan",
                                    style: TextStyle(
                                      fontSize: 18,
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
                                        .format(totalIncome),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        elevation: 0, // Adds shadow
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(4), // Rounded corners
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 184, 0, 70),
                              borderRadius: BorderRadius.circular(4)),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Pengeluaran",
                                    style: TextStyle(
                                      fontSize: 18,
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
                                        .format(totalExpense),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Transaksi Terbaru"),
                const SizedBox(
                  height: 16,
                ),
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
                            tileColor: Color.fromARGB(255, 255, 255, 255),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16),
                            title: Text(
                              "${transaction.name} (${DateFormat("dd/MM/yyyy").format(transaction.date)})",
                              style: TextStyle(fontSize: 12),
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
                              icon: Icon(Icons.delete),
                            ),
                          ),
                          SizedBox(height: 6),
                        ],
                      );
                    }).toList(),
                  )
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox),
            label: 'Pemasukan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_rounded),
            label: 'Tambah',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money_off_rounded),
            label: 'Pengeluaran',
          ),
        ],
        currentIndex: 1,
        selectedItemColor: Colors.teal,
        onTap: (value) {
          if (value == 0) {
            Navigator.of(context).pushNamed("/data-pemasukan");
          }
          if (value == 1) {
            Navigator.of(context).pushNamed("/tambah-transaksi");
          }
          if (value == 2) {
            Navigator.of(context).pushNamed("/data-pengeluaran");
          }
          print(value);
        },
      ),
    );
  }
}
