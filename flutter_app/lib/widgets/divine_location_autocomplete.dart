import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DivineLocationAutocomplete extends StatefulWidget {
  final TextEditingController controller;
  const DivineLocationAutocomplete({super.key, required this.controller});
  @override
  State<DivineLocationAutocomplete> createState() => _LocationState();
}

class _LocationState extends State<DivineLocationAutocomplete> {
  Timer? timer;
  int generation = 0;
  List<String> suggestions = [];
  bool loading = false;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void search(String query) {
    timer?.cancel();
    final id = ++generation;
    setState(() {
      suggestions = [];
      loading = false;
    });
    if (query.trim().length < 3) return;
    timer = Timer(const Duration(milliseconds: 800), () async {
      if (!mounted || id != generation) return;
      setState(() => loading = true);
      try {
        final uri = Uri.https('photon.komoot.io', '/api/', {
          'q': query.trim(),
          'limit': '5',
        });
        final response = await http
            .get(uri)
            .timeout(const Duration(seconds: 8));
        if (response.statusCode != 200) throw Exception('Search failed');
        final features =
            (jsonDecode(response.body) as Map<String, dynamic>)['features']
                as List<dynamic>? ??
            [];
        final found = <String>[];
        for (final feature in features) {
          final p =
              (feature as Map<String, dynamic>)['properties']
                  as Map<String, dynamic>? ??
              {};
          final street = [
            p['housenumber'],
            p['street'],
          ].where((v) => v != null).join(' ');
          final parts =
              [
                    street.isEmpty ? p['name'] : street,
                    p['city'] ?? p['town'] ?? p['village'],
                    p['state'],
                    p['country'],
                  ]
                  .where((v) => v != null && v.toString().isNotEmpty)
                  .map((v) => v.toString());
          final address = parts.join(', ');
          if (address.isNotEmpty && !found.contains(address)) {
            found.add(address);
          }
        }
        if (mounted && id == generation) setState(() => suggestions = found);
      } catch (_) {
        if (mounted && id == generation) setState(() => suggestions = []);
      } finally {
        if (mounted && id == generation) setState(() => loading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      TextField(
        controller: widget.controller,
        onChanged: search,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search address or place',
          hintStyle: const TextStyle(color: Color(0xFFBCAACB)),
          filled: true,
          fillColor: const Color(0xFF1C102F),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
          suffixIcon: loading
              ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.search, color: Color(0xFFE8C57B)),
        ),
      ),
      for (final address in suggestions)
        ListTile(
          leading: const Icon(
            Icons.location_on_outlined,
            color: Color(0xFFE8C57B),
          ),
          title: Text(
            address,
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
          onTap: () {
            ++generation;
            timer?.cancel();
            widget.controller.text = address;
            FocusScope.of(context).unfocus();
            setState(() {
              suggestions = [];
              loading = false;
            });
          },
        ),
      const Text(
        'Search data: OpenStreetMap contributors',
        style: TextStyle(color: Color(0xFFBCAACB), fontSize: 10),
      ),
    ],
  );
}
