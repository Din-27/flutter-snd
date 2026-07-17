import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_and_drive/components/auth/auth_form_card.dart';
import 'package:shop_and_drive/components/layout/app_page_scaffold.dart';
import 'package:shop_and_drive/components/loading/loading_button.dart';
import 'package:shop_and_drive/components/loading/loading_overlay.dart';
import 'package:shop_and_drive/features/auth/domain/models/auth_session.dart';
import 'package:shop_and_drive/features/auth/presentation/providers/auth_providers.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Konfirmasi password tidak sama.')),
      );
      return;
    }

    await ref.read(registerControllerProvider.notifier).register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<AuthSession?>>(registerControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (session) {
          if (session != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Register berhasil. Silakan login.')),
            );
            context.go('/login');
          }
        },
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        },
      );
    });

    final registerState = ref.watch(registerControllerProvider);
    final isLoading = registerState.isLoading;

    return AppPageScaffold(
      title: 'Register',
      currentIndex: null,
      body: LoadingOverlay(
        isLoading: isLoading,
        message: 'Membuat akun...',
        child: AuthFormCard(
          title: 'Buat akun baru',
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nama Lengkap')),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Konfirmasi Password'),
            ),
            const SizedBox(height: 14),
            LoadingButton(onPressed: _submit, label: 'Register', isLoading: isLoading),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.go('/login'),
              child: const Text('Sudah punya akun? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
