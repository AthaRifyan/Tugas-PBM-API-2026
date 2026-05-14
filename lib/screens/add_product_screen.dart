import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  bool _isLoading = false;

  static const Color darkBlue = Color(0xFF1D3267);
  static const Color lightGray = Color(0xFFE5E9F4);
  static const Color accentBlue = Color(0xFF346FF8);

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final result = await ApiService.addProduct(
      name: _nameController.text.trim(),
      price: int.parse(_priceController.text.trim()),
      description: _descController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produk berhasil ditambahkan!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal: ${result['message']}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration(String label, IconData icon,
      {bool multiline = false}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: darkBlue.withOpacity(0.5), fontSize: 14),
      prefixIcon: multiline
          ? null
          : Icon(icon, color: accentBlue, size: 20),
      filled: true,
      fillColor: Colors.white,
      alignLabelWithHint: multiline,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: multiline ? 14 : 16,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: lightGray, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: accentBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGray,
      appBar: AppBar(
        backgroundColor: darkBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Tambah Produk',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              _label('Nama Produk'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: darkBlue),
                decoration: _fieldDecoration('Masukkan nama produk', Icons.label_outline),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 20),

              _label('Harga (Rp)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _priceController,
                style: const TextStyle(color: darkBlue),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: _fieldDecoration('Masukkan harga', Icons.attach_money),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Harga tidak boleh kosong';
                  if (int.tryParse(v) == null) return 'Harga harus angka';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              _label('Deskripsi'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descController,
                style: const TextStyle(color: darkBlue),
                maxLines: 4,
                decoration: _fieldDecoration(
                  'Masukkan deskripsi produk',
                  Icons.description_outlined,
                  multiline: true,
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Deskripsi tidak boleh kosong' : null,
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'Simpan Produk',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: darkBlue,
        fontWeight: FontWeight.w600,
        fontSize: 13,
      ),
    );
  }
}