import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local preview access gate. Not a substitute for server-side authentication.
class JusticeLocalLock extends StatefulWidget {
  const JusticeLocalLock({super.key, required this.child});
  final Widget child;
  static final ValueNotifier<bool> unlocked = ValueNotifier<bool>(false);
  static void lock() => unlocked.value = false;

  static Widget profileControls(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SizedBox(height: 18),
      const Text(
        'ACCESS SETTINGS',
        style: TextStyle(color: Color(0xFFFFD27C), fontSize: 17),
      ),
      const SizedBox(height: 8),
      OutlinedButton.icon(
        onPressed: () => _changeCredentials(context, false),
        icon: const Icon(Icons.person_outline),
        label: const Text('Change Username'),
      ),
      OutlinedButton.icon(
        onPressed: () => _changeCredentials(context, true),
        icon: const Icon(Icons.password),
        label: const Text('Change Password'),
      ),
      OutlinedButton.icon(
        onPressed: lock,
        icon: const Icon(Icons.lock_outline),
        label: const Text('Lock Justice Divine'),
      ),
    ],
  );

  static Future<void> _changeCredentials(
    BuildContext context,
    bool password,
  ) async {
    final current = TextEditingController();
    final updated = TextEditingController();
    final confirmation = TextEditingController();
    String error = '';
    try {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
          builder: (dialogContext, setDialogState) => AlertDialog(
            title: Text(password ? 'Change Password' : 'Change Username'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: current,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Current password',
                    ),
                  ),
                  TextField(
                    controller: updated,
                    obscureText: password,
                    decoration: InputDecoration(
                      labelText: password
                          ? 'New password (8+ characters)'
                          : 'New username',
                    ),
                  ),
                  if (password)
                    TextField(
                      controller: confirmation,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Confirm new password',
                      ),
                    ),
                  if (error.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        error,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  if (!_verify(prefs, current.text)) {
                    setDialogState(
                      () => error = 'Current password is incorrect.',
                    );
                    return;
                  }
                  if (password) {
                    if (updated.text.length < 8) {
                      setDialogState(
                        () => error = 'Use at least 8 characters.',
                      );
                      return;
                    }
                    if (updated.text != confirmation.text) {
                      setDialogState(() => error = 'Passwords do not match.');
                      return;
                    }
                    await _savePassword(prefs, updated.text);
                  } else {
                    if (updated.text.trim().length < 3) {
                      setDialogState(
                        () =>
                            error = 'Username must have at least 3 characters.',
                      );
                      return;
                    }
                    await prefs.setString(
                      'jd_local_username',
                      updated.text.trim(),
                    );
                  }
                  if (dialogContext.mounted) Navigator.pop(dialogContext);
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      );
    } finally {
      current.dispose();
      updated.dispose();
      confirmation.dispose();
    }
  }

  static String _salt() {
    final rng = Random.secure();
    return base64UrlEncode(List<int>.generate(24, (_) => rng.nextInt(256)));
  }

  static String _digest(String salt, String password) =>
      sha256.convert(utf8.encode('$salt:$password')).toString();
  static bool _verify(SharedPreferences prefs, String password) {
    final salt = prefs.getString('jd_local_salt');
    final hash = prefs.getString('jd_local_hash');
    return salt != null && hash != null && _digest(salt, password) == hash;
  }

  static Future<void> _savePassword(
    SharedPreferences prefs,
    String password,
  ) async {
    final salt = _salt();
    await prefs.setString('jd_local_salt', salt);
    await prefs.setString('jd_local_hash', _digest(salt, password));
  }

  @override
  State<JusticeLocalLock> createState() => _JusticeLocalLockState();
}

class _JusticeLocalLockState extends State<JusticeLocalLock> {
  final username = TextEditingController();
  final password = TextEditingController();
  final confirm = TextEditingController();
  SharedPreferences? prefs;
  bool loading = true;
  bool setup = false;
  bool busy = false;
  String error = '';
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final store = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      prefs = store;
      username.text = store.getString('jd_local_username') ?? '';
      setup = store.getString('jd_local_hash') == null;
      loading = false;
    });
  }

  Future<void> _submit() async {
    if (busy || prefs == null) return;
    setState(() {
      busy = true;
      error = '';
    });
    try {
      if (setup) {
        if (username.text.trim().length < 3 || password.text.length < 8) {
          setState(
            () => error = 'Username: 3+ characters. Password: 8+ characters.',
          );
          return;
        }
        if (password.text != confirm.text) {
          setState(() => error = 'Passwords do not match.');
          return;
        }
        await prefs!.setString('jd_local_username', username.text.trim());
        await JusticeLocalLock._savePassword(prefs!, password.text);
        setup = false;
      } else if (username.text.trim() !=
              prefs!.getString('jd_local_username') ||
          !JusticeLocalLock._verify(prefs!, password.text)) {
        setState(() => error = 'Incorrect username or password.');
        return;
      }
      password.clear();
      confirm.clear();
      JusticeLocalLock.unlocked.value = true;
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
    valueListenable: JusticeLocalLock.unlocked,
    builder: (context, unlocked, _) {
      if (unlocked) return widget.child;
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF271039), Color(0xFF10091F), Color(0xFF170D29)],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.lock_outline,
                        color: Color(0xFFFFD27C),
                        size: 55,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'JUSTICE DIVINE',
                        style: TextStyle(
                          fontFamily: 'serif',
                          color: Color(0xFFFFD27C),
                          fontSize: 32,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        loading
                            ? 'Preparing your sanctuary...'
                            : setup
                            ? 'Create your private access'
                            : 'Your personal spiritual sanctuary',
                        style: const TextStyle(color: Color(0xFFE4B8F9)),
                      ),
                      const SizedBox(height: 24),
                      if (!loading) ...[
                        TextField(
                          controller: username,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: password,
                          obscureText: true,
                          onSubmitted: (_) => setup ? null : _submit(),
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        if (setup) ...[
                          const SizedBox(height: 12),
                          TextField(
                            controller: confirm,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Confirm password',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                        if (error.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              error,
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                          ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: busy ? null : _submit,
                            child: Text(
                              setup ? 'CREATE ACCESS' : 'UNLOCK JUSTICE DIVINE',
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      const Text(
                        'Local preview access only. Keep a private copy of your credentials; there is no password recovery.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFE4B8F9),
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
    },
  );
}
