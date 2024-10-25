import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'models/pdam.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PdamScreen(),
    );
  }
}

class PdamScreen extends StatefulWidget {
  @override
  _PdamScreenState createState() => _PdamScreenState();
}

class _PdamScreenState extends State<PdamScreen> {
  final _kodePembayaranController = TextEditingController();
  final _namaPelangganController = TextEditingController();
  final _meterBulanIniController = TextEditingController();
  final _meterBulanLaluController = TextEditingController();
  String _jenisPelanggan = 'GOLD';
  DateTime? _selectedDate;
  int? _totalBayar;

  void _calculate() {
    final pdam = Pdam(
      kodePembayaran: _kodePembayaranController.text,
      namaPelanggan: _namaPelangganController.text,
      jenisPelanggan: _jenisPelanggan,
      tanggal: _selectedDate ?? DateTime.now(),
      meterBulanIni: int.parse(_meterBulanIniController.text),
      meterBulanLalu: int.parse(_meterBulanLaluController.text),
    );
    pdam.calculateTotalBayar();
    setState(() {
      _totalBayar = pdam.totalBayar;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pembayaran PDAM'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _kodePembayaranController,
                decoration: InputDecoration(
                  labelText: 'Kode Pembayaran',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: _namaPelangganController,
                decoration: InputDecoration(
                  labelText: 'Nama Pelanggan',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _jenisPelanggan,
                onChanged: (String? newValue) {
                  setState(() {
                    _jenisPelanggan = newValue!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Jenis Pelanggan',
                  border: OutlineInputBorder(),
                ),
                items: <String>['GOLD', 'SILVER', 'UMUM']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Text(
                    _selectedDate == null
                        ? 'Tanggal: Not Selected'
                        : 'Tanggal: ${DateFormat('dd-MM-yyyy').format(_selectedDate!)}',
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Select Date'),
                  ),
                ],
              ),
              SizedBox(height: 15),
              TextField(
                controller: _meterBulanIniController,
                decoration: InputDecoration(
                  labelText: 'Meter Bulan Ini',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 15),
              TextField(
                controller: _meterBulanLaluController,
                decoration: InputDecoration(
                  labelText: 'Meter Bulan Lalu',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calculate,
                child: Text('Hitung Total Bayar'),
              ),
              SizedBox(height: 20),
              if (_totalBayar != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detail Pembayaran',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text('Kode Pembayaran: ${_kodePembayaranController.text}'),
                    Text('Nama Pelanggan: ${_namaPelangganController.text}'),
                    Text('Jenis Pelanggan: $_jenisPelanggan'),
                    Text(
                      'Tanggal: ${_selectedDate != null ? DateFormat('dd-MM-yyyy').format(_selectedDate!) : 'Not Selected'}',
                    ),
                    Text('Meter Bulan Ini: ${_meterBulanIniController.text}'),
                    Text('Meter Bulan Lalu: ${_meterBulanLaluController.text}'),
                    Text(
                      'Total Bayar: Rp $_totalBayar',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
