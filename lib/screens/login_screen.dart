import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../theme/field_log_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _loading = false;
  String? _error;

  Future<void> _signInWithGoogle() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'http://localhost:8080',
        queryParams: {'prompt': 'select_account'},
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = 'Could not continue with Google.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FieldLog.bgPage,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
                decoration: BoxDecoration(
                  color: FieldLog.surfaceCard,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: FieldLog.border),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jova',
                      style: FieldLog.display(
                        size: 28,
                        weight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Keep your job search in one place.',
                      style: FieldLog.body(
                        size: 13,
                        color: FieldLog.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: _loading ? null : _signInWithGoogle,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: FieldLog.textPrimary,
                          backgroundColor: FieldLog.surfaceCard,
                          side: BorderSide(color: FieldLog.borderStrong),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _loading
                            ? SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: FieldLog.textPrimary,
                                ),
                              )
                            : Text(
                                'Continue with Google',
                                style: FieldLog.body(
                                  size: 13,
                                  color: FieldLog.textPrimary,
                                  weight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    if (_error != null) ...[
                      const SizedBox(height: 14),
                      Text(
                        _error!,
                        style: FieldLog.body(
                          size: 11,
                          color: FieldLog.stageRejected,
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    Text(
                      'Your applications and stage settings are private to your account.',
                      style: FieldLog.body(
                        size: 11,
                        color: FieldLog.textSecondary,
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
}
