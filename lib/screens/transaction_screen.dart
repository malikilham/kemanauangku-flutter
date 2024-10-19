import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:kemanauangku/models/transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AddTransactionPage extends StatefulWidget {
  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  TransactionType _type = TransactionType.income;
  int _amount = 0;
  DateTime _date = DateTime.now();
  String _description = '';

  final _dateController = TextEditingController();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(_date);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _nameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Transaksi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Card(
              color: Colors.white,
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildInputField(
                      label: 'Nama',
                      controller: _nameController,
                      onTap: () {
                        print("Tapped Nama field");
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Mohon isi nama transaksi';
                        }
                        return null;
                      },
                      onSaved: (value) => _name = value!,
                    ),
                    SizedBox(height: 16),
                    _buildDropdownField(),
                    SizedBox(height: 16),
                    _buildInputNumberField(
                      label: 'Jumlah',
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      onTap: () {
                        print("Tapped Jumlah field");
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Mohon isi jumlah';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Mohon masukkan angka yang valid';
                        }
                        return null;
                      },
                      onSaved: (value) => _amount = int.parse(value!),
                    ),
                    SizedBox(height: 16),
                    _buildDatePicker(),
                    SizedBox(height: 16),
                    _buildInputField(
                      label: 'Deskripsi',
                      controller: _descriptionController,
                      maxLines: 3,
                      onTap: () {
                        print("Tapped Deskripsi field");
                      },
                      onSaved: (value) => _description = value!,
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      child: Text(
                        'Simpan',
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
    int? maxLines,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
      maxLines: maxLines ?? 1,
      onTap: onTap,
    );
  }

  Widget _buildInputNumberField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
    int? maxLines,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
      maxLines: maxLines ?? 1,
      onTap: onTap,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<TransactionType>(
      value: _type,
      decoration: InputDecoration(
        labelText: 'Tipe Transaksi',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      items: TransactionType.values.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(
              type == TransactionType.income ? 'Pemasukan' : 'Pengeluaran'),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _type = value!;
        });
      },
    );
  }

  Widget _buildDatePicker() {
    return TextFormField(
      controller: _dateController,
      decoration: InputDecoration(
        labelText: 'Tanggal',
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[50],
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: _date,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null && pickedDate != _date) {
          setState(() {
            _date = pickedDate;
            _dateController.text = DateFormat('yyyy-MM-dd').format(_date);
          });
        }
      },
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final transaction = TransactionModel(
        name: _name,
        type: _type,
        amount: _amount,
        date: _date,
        description: _description,
      );

      final prefs = await SharedPreferences.getInstance();
      List<String> transactions = prefs.getStringList('transactions') ?? [];
      transactions.add(jsonEncode(transaction.toJson()));
      await prefs.setStringList('transactions', transactions);

      Navigator.of(context).pushReplacementNamed('/');
    }
  }
}
