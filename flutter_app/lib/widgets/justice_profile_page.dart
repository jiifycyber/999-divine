import 'package:flutter/material.dart';

import '../services/justice_local_lock.dart';

import 'dart:convert';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Owner-only local preview. Member IDs reserve a path to future account isolation.
/// This is not an authentication or multi-user security system.
class JusticeProfileV1 extends StatefulWidget {
  const JusticeProfileV1({super.key});
  @override
  State<JusticeProfileV1> createState() => _JusticeProfileV1State();
}

class _JusticeProfileV1State extends State<JusticeProfileV1> {
  static const _memberId = 'owner_justice';
  static const _gold = Color(0xFFFFD27C);
  static const _panel = Color(0xFF28153E);
  static const _lavender = Color(0xFFE4B8F9);
  Uint8List? _profilePhoto;
  String _name = 'Justice Nicholson';
  String _intro = 'Spiritual Explorer • Dreamer';
  String _affirmation =
      'I am aligned, protected, and open to all the good that is coming.';
  List<String> _goals = [];
  List<String> _favorites = [];
  List<String> _reminders = [];
  bool _confirmDelete = true;
  bool _loaded = false;

  String _key(String field) => 'justice_divine.member.$_memberId.$field';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _name = p.getString(_key('name')) ?? _name;
      final savedPhoto = p.getString(_key('profile_photo'));
      if (savedPhoto != null) {
        try {
          _profilePhoto = base64Decode(savedPhoto);
        } catch (_) {
          _profilePhoto = null;
        }
      }
      _intro = p.getString(_key('intro')) ?? _intro;
      _affirmation = p.getString(_key('affirmation')) ?? _affirmation;
      _goals = p.getStringList(_key('goals')) ?? [];
      _favorites = p.getStringList(_key('favorites')) ?? [];
      _reminders = p.getStringList(_key('reminders')) ?? [];
      _confirmDelete = p.getBool(_key('confirm_delete')) ?? true;
      _loaded = true;
    });
  }

  Future<void> _editText(String title, String current, String field) async {
    final controller = TextEditingController(text: current);
    final value = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: field == 'name' ? 60 : 240,
          maxLines: field == 'intro' ? 3 : 1,
          decoration: InputDecoration(labelText: title),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (value == null || value.isEmpty || !mounted) return;
    final p = await SharedPreferences.getInstance();
    await p.setString(_key(field), value);
    if (!mounted) return;
    setState(() {
      if (field == 'name') _name = value;
      if (field == 'intro') _intro = value;
      if (field == 'affirmation') _affirmation = value;
    });
  }

  Future<void> _openCollection(String title, String field) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (ctx, refresh) {
          List<String> items() => field == 'goals'
              ? _goals
              : field == 'favorites'
              ? _favorites
              : _reminders;
          Future<void> persist(List<String> next) async {
            final p = await SharedPreferences.getInstance();
            await p.setStringList(_key(field), next);
            if (!mounted) return;
            setState(() {
              if (field == 'goals') _goals = next;
              if (field == 'favorites') _favorites = next;
              if (field == 'reminders') _reminders = next;
            });
            refresh(() {});
          }

          Future<void> add() async {
            final input = TextEditingController();
            final result = await showDialog<String>(
              context: ctx,
              builder: (subctx) => AlertDialog(
                title: Text('Add $title item'),
                content: TextField(
                  controller: input,
                  autofocus: true,
                  maxLength: 180,
                  decoration: const InputDecoration(hintText: 'Write here'),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(subctx),
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(subctx, input.text.trim()),
                    child: const Text('Add'),
                  ),
                ],
              ),
            );
            input.dispose();
            if (result != null && result.isNotEmpty && ctx.mounted) {
              await persist([...items(), result]);
            }
          }

          Future<void> remove(int index) async {
            if (_confirmDelete) {
              final confirmed = await showDialog<bool>(
                context: ctx,
                builder: (subctx) => AlertDialog(
                  title: const Text('Delete this item?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(subctx, false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(subctx, true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
              if (confirmed != true) return;
            }
            final next = [...items()]..removeAt(index);
            await persist(next);
          }

          return AlertDialog(
            title: Text(title),
            content: SizedBox(
              width: 380,
              child: items().isEmpty
                  ? const Text('Nothing saved yet. Add your first item.')
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: items().length,
                      itemBuilder: (_, i) => ListTile(
                        title: Text(items()[i]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          tooltip: 'Delete',
                          onPressed: () => remove(i),
                        ),
                      ),
                    ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Close'),
              ),
              FilledButton.icon(
                onPressed: add,
                icon: const Icon(Icons.add),
                label: const Text('Add'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _changeProfilePhoto() async {
    try {
      final photo = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );
      if (photo == null) return;
      final bytes = await photo.readAsBytes();
      if (bytes.length > 700000) {
        if (mounted) {
          _showInfo("Photo Too Large", "Please choose a smaller image.");
        }
        return;
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key("profile_photo"), base64Encode(bytes));
      if (!mounted) return;
      setState(() => _profilePhoto = bytes);
    } catch (error) {
      if (mounted) {
        _showInfo("Photo Error", "Could not load the selected photo: $error");
      }
    }
  }

  Future<void> _removeProfilePhoto() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key("profile_photo"));
    if (!mounted) return;
    setState(() => _profilePhoto = null);
  }

  void _showInfo(String title, String message) => showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Close'),
        ),
      ],
    ),
  );

  Widget _item(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback action,
  ) => Card(
    color: _panel,
    margin: const EdgeInsets.symmetric(vertical: 5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
      side: const BorderSide(color: _gold, width: 0.5),
    ),
    child: ListTile(
      leading: Icon(icon, color: _gold),
      title: Text(title, style: const TextStyle(color: _gold)),
      subtitle: Text(subtitle, style: const TextStyle(color: _lavender)),
      trailing: const Icon(Icons.chevron_right, color: _gold),
      onTap: action,
    ),
  );

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Profile',
          textAlign: TextAlign.center,
          style: TextStyle(color: _gold, fontSize: 33, fontFamily: 'serif'),
        ),
        const SizedBox(height: 6),
        const Text(
          'Your personal spiritual sanctuary',
          textAlign: TextAlign.center,
          style: TextStyle(color: _lavender),
        ),
        const SizedBox(height: 16),
        Center(
          child: InkWell(
            onTap: _changeProfilePhoto,
            borderRadius: BorderRadius.circular(50),
            child: CircleAvatar(
              radius: 42,
              backgroundColor: _gold,
              backgroundImage: _profilePhoto == null
                  ? null
                  : MemoryImage(_profilePhoto!),
              child: _profilePhoto == null
                  ? const Icon(Icons.person, size: 56, color: Color(0xFF10091F))
                  : null,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          _name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'serif',
            fontSize: 26,
            color: _gold,
          ),
        ),
        Text(
          _intro,
          textAlign: TextAlign.center,
          style: const TextStyle(color: _lavender),
        ),
        const SizedBox(height: 12),
        if (!_loaded) const Center(child: CircularProgressIndicator()),
        FilledButton.icon(
          onPressed: () => _editText('Display Name', _name, 'name'),
          icon: const Icon(Icons.edit_outlined),
          label: const Text('EDIT PROFILE — NAME'),
        ),
        _item(
          "Change Profile Photo",
          "Choose a photo from your device",
          Icons.add_a_photo_outlined,
          _changeProfilePhoto,
        ),
        if (_profilePhoto != null)
          _item(
            "Remove Profile Photo",
            "Restore the default gold avatar",
            Icons.delete_outline,
            _removeProfilePhoto,
          ),
        _item(
          'Edit Display Name',
          'Personalize your profile',
          Icons.edit_outlined,
          () => _editText('Display Name', _name, 'name'),
        ),
        _item(
          'Choose Spiritual Identity',
          'Select a spiritual path or write your own',
          Icons.auto_awesome,
          () async {
            const options = <String>[
              'Spiritual Seeker',
              'Spiritual Practitioner',
              'Mystic',
              'Ancestral Traditions',
              'Nature-Centered Spirituality',
              'Meditation Practitioner',
              'Prefer Not to Label',
              'Write My Own',
            ];
            final selected = await showDialog<String>(
              context: context,
              builder: (ctx) => SimpleDialog(
                title: const Text('Choose Spiritual Identity'),
                children: [
                  for (final option in options)
                    SimpleDialogOption(
                      onPressed: () => Navigator.pop(ctx, option),
                      child: Text(option),
                    ),
                ],
              ),
            );
            if (selected == null || !mounted) return;
            if (selected == 'Write My Own') {
              await _editText('Spiritual Identity', _intro, 'intro');
            } else {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString(_key('intro'), selected);
              if (!mounted) return;
              setState(() => _intro = selected);
            }
          },
        ),
        _item(
          'Edit Introduction',
          'Write your own spiritual introduction',
          Icons.notes,
          () => _editText('Introduction', _intro, 'intro'),
        ),
        _item(
          'Edit Personal Affirmation',
          'Customize your personal message',
          Icons.favorite_outline,
          () => _editText('Personal Affirmation', _affirmation, 'affirmation'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Text(
            _affirmation,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _gold,
              fontFamily: 'serif',
              fontSize: 17,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        _item(
          'My Goals',
          '${_goals.length} saved goals',
          Icons.flag_outlined,
          () => _openCollection('My Goals', 'goals'),
        ),
        _item(
          'My Favorites',
          '${_favorites.length} saved favorites',
          Icons.favorite_border,
          () => _openCollection('My Favorites', 'favorites'),
        ),
        _item(
          'Reminders',
          '${_reminders.length} saved reminder notes',
          Icons.notifications_outlined,
          () => _openCollection('Reminders', 'reminders'),
        ),
        _item(
          'Account & Security',
          'Username, password, and Lock App',
          Icons.lock_outline,
          () => showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (ctx) => SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: JusticeLocalLock.profileControls(ctx),
                ),
              ),
            ),
          ),
        ),
        _item(
          'App Settings',
          'Delete confirmation and preferences',
          Icons.settings_outlined,
          () => showDialog<void>(
            context: context,
            builder: (ctx) => StatefulBuilder(
              builder: (ctx, refresh) => AlertDialog(
                title: const Text('App Settings'),
                content: SwitchListTile(
                  title: const Text('Confirm before deleting'),
                  value: _confirmDelete,
                  onChanged: (value) async {
                    final p = await SharedPreferences.getInstance();
                    await p.setBool(_key('confirm_delete'), value);
                    if (!mounted) return;
                    setState(() => _confirmDelete = value);
                    refresh(() {});
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ),
        ),
        _item(
          'About Justice Divine',
          'Version 1.0 preview',
          Icons.info_outline,
          () => _showInfo(
            'About Justice Divine',
            'Justice Divine is a spiritual reflection and ritual companion. This is a local owner preview. Customer accounts, subscriptions, and cloud synchronization are not enabled.',
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'OWNER PREVIEW • Local data on this device',
          textAlign: TextAlign.center,
          style: TextStyle(color: _lavender, fontSize: 11),
        ),
      ],
    ),
  );
}
