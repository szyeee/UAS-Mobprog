import 'package:flutter/material.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});
  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  DateTime? _date;
  TimeOfDay? _time;
  final _nameController = TextEditingController();
  final _peopleController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _peopleController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
    if (d != null) setState(() => _date = d);
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (t != null) setState(() => _time = t);
  }

  void _submit() {
    if (_nameController.text.isEmpty || _peopleController.text.isEmpty || _date == null || _time == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lengkapi semua field')));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reservasi berhasil')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reservasi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nama')),
          const SizedBox(height: 8),
          TextField(controller: _peopleController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Jumlah orang')),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: OutlinedButton(onPressed: _pickDate, child: Text(_date == null ? 'Pilih tanggal' : _date!.toLocal().toString().split(' ')[0]))),
            const SizedBox(width: 8),
            Expanded(child: OutlinedButton(onPressed: _pickTime, child: Text(_time == null ? 'Pilih waktu' : _time!.format(context)))),
          ]),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _submit, child: const Text('Buat Reservasi'))
        ]),
      ),
    );
  }
}
