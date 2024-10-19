import 'package:flutter/material.dart';
import 'package:kemanauangku/screens/expense_screen.dart';
import 'package:kemanauangku/screens/home_screen.dart';
import 'package:kemanauangku/screens/income_screen.dart';
import 'package:kemanauangku/screens/transaction_screen.dart';
import 'package:kemanauangku/screens/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KemanaUangku',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: "/intro",
      routes: {
        "/": (context) => const HomeScreen(),
        "/intro": (context) => const WelcomeScreen(),
        "/tambah-transaksi": (context) => AddTransactionPage(),
        "/data-pemasukan": (context) => const IncomeScreen(),
        "/data-pengeluaran": (context) => const ExpenseScreen(),
        // "/incomes": (context) =>
      },
    );
  }
}
