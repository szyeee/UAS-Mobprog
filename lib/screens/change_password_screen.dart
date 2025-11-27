import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final oldCtrl = TextEditingController();
  final newCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ubah Password")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: oldCtrl,
                decoration: const InputDecoration(labelText: "Password Lama"),
                obscureText: true,
                validator: (v) => v == null || v.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: newCtrl,
                decoration: const InputDecoration(labelText: "Password Baru"),
                obscureText: true,
                validator: (v) =>
                    (v ?? '').length < 6 ? "Min 6 karakter" : null,
              ),
              TextFormField(
                controller: confirmCtrl,
                decoration:
                    const InputDecoration(labelText: "Konfirmasi Password"),
                obscureText: true,
                validator: (v) => v != newCtrl.text ? "Tidak sama" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Password berhasil diubah ✅")),
                  );

                  Navigator.pop(context);
                },
                child: const Text("Simpan"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
