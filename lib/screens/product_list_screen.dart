import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';
import '../widgets/product_card.dart';
import 'add_product_screen.dart';
import 'login_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<ProductModel> _products = [];
  bool _isLoading = true;

  final _submitGithubCtrl = TextEditingController();

  static const Color darkBlue = Color(0xFF1D3267);
  static const Color lightGray = Color(0xFFE5E9F4);
  static const Color accentBlue = Color(0xFF346FF8);

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    final products = await ApiService.getProducts();
    if (mounted) {
      setState(() {
        _products = products;
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteProduct(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Hapus Produk',
          style: TextStyle(color: darkBlue, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Yakin ingin menghapus produk ini?',
          style: TextStyle(color: Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal', style: TextStyle(color: Colors.black45)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ApiService.deleteProduct(id);
      _loadProducts();
    }
  }

  // ── Helper: label form submit ──────────────────────────
  Widget _submitLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: darkBlue,
        fontWeight: FontWeight.w600,
        fontSize: 13,
      ),
    );
  }

  // ── Helper: dekorasi field submit ─────────────────────
  InputDecoration _submitFieldDecoration(String hint, IconData icon,
      {bool multiline = false}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: darkBlue.withOpacity(0.35), fontSize: 13),
      prefixIcon: multiline
          ? null
          : Icon(icon, color: accentBlue, size: 20),
      alignLabelWithHint: multiline,
      filled: true,
      fillColor: lightGray,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: accentBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }

  // ── Dialog Submit Tugas ───────────────────────────────
  void _showSubmitDialog() {
    _submitGithubCtrl.clear();
    final submitNameCtrl = TextEditingController();
    final submitPriceCtrl = TextEditingController();
    final submitDescCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Judul ──────────────────────────────
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: accentBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.upload_rounded,
                          color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Submit Tugas',
                      style: TextStyle(
                        color: darkBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ── Banner peringatan ──────────────────
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: accentBlue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: accentBlue.withOpacity(0.25), width: 1),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline,
                          color: accentBlue, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Pastikan semua data sudah benar!\nTidak bisa diubah setelah submit.',
                          style: TextStyle(
                            color: darkBlue.withOpacity(0.8),
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ── Nama Produk ────────────────────────
                _submitLabel('Nama Produk'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: submitNameCtrl,
                  style: const TextStyle(color: darkBlue, fontSize: 14),
                  decoration: _submitFieldDecoration(
                      'Masukkan nama produk', Icons.label_outline),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Nama wajib diisi' : null,
                ),
                const SizedBox(height: 16),

                // ── Harga ──────────────────────────────
                _submitLabel('Harga (Rp)'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: submitPriceCtrl,
                  style: const TextStyle(color: darkBlue, fontSize: 14),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: _submitFieldDecoration(
                      'Masukkan harga', Icons.attach_money),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Harga wajib diisi';
                    if (int.tryParse(v) == null) return 'Harga harus angka';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // ── Deskripsi ──────────────────────────
                _submitLabel('Deskripsi'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: submitDescCtrl,
                  style: const TextStyle(color: darkBlue, fontSize: 14),
                  maxLines: 3,
                  decoration: _submitFieldDecoration(
                    'Masukkan deskripsi produk',
                    Icons.description_outlined,
                    multiline: true,
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Deskripsi wajib diisi' : null,
                ),
                const SizedBox(height: 16),

                // ── GitHub URL ─────────────────────────
                _submitLabel('GitHub URL'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _submitGithubCtrl,
                  style: const TextStyle(color: darkBlue, fontSize: 14),
                  decoration: _submitFieldDecoration(
                      'https://github.com/username/repo', Icons.link),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'GitHub URL wajib diisi' : null,
                ),
                const SizedBox(height: 24),

                // ── Tombol Batal & Submit ──────────────
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: darkBlue,
                          side: BorderSide(
                              color: darkBlue.withOpacity(0.3), width: 1.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Batal',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) return;
                          Navigator.pop(ctx);
                          try {
                            final result = await ApiService.submitTugas(
                              name: submitNameCtrl.text.trim(),
                              price: int.parse(submitPriceCtrl.text.trim()),
                              description: submitDescCtrl.text.trim(),
                              githubUrl: _submitGithubCtrl.text.trim(),
                            );
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    result['success'] == true
                                        ? '✅ Tugas berhasil disubmit!'
                                        : '❌ ${result['message'] ?? 'Submit gagal'}',
                                  ),
                                  backgroundColor: result['success'] == true
                                      ? Colors.green
                                      : Colors.red,
                                  duration: const Duration(seconds: 4),
                                ),
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        child: const Text(
                          'Submit',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _logout() async {
    await ApiService.deleteToken();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _submitGithubCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGray,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header biru tua ─────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              decoration: const BoxDecoration(
                color: darkBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Katalog Produk',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_products.length} produk tersimpan',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Tombol Submit
                  GestureDetector(
                    onTap: _showSubmitDialog,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: accentBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.upload_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Tombol Logout
                  GestureDetector(
                    onTap: _logout,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.logout,
                          color: Colors.white.withOpacity(0.8), size: 20),
                    ),
                  ),
                ],
              ),
            ),

            // ── Body / List Produk ───────────────────────
            Expanded(
              child: _isLoading
                  ? const Center(
                      child:
                          CircularProgressIndicator(color: accentBlue),
                    )
                  : _products.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.inventory_2_outlined,
                                  size: 40,
                                  color: darkBlue.withOpacity(0.25),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Belum ada produk',
                                style: TextStyle(
                                  color: darkBlue.withOpacity(0.5),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Tambahkan produk dengan tombol +',
                                style: TextStyle(
                                  color: darkBlue.withOpacity(0.35),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadProducts,
                          color: accentBlue,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _products.length,
                            itemBuilder: (_, index) => ProductCard(
                              product: _products[index],
                              onDelete: () =>
                                  _deleteProduct(_products[index].id),
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProductScreen()),
          );
          if (result == true) _loadProducts();
        },
        backgroundColor: accentBlue,
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}