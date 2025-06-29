import 'package:flutter/material.dart';

class SettingsLanguagePicker extends StatelessWidget {
  final String selectedLanguage;
  final Function(String) onLanguageChanged;

  const SettingsLanguagePicker({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
  });

  static const List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
    {'code': 'id', 'name': 'Bahasa Indonesia', 'flag': '🇮🇩'},
    {'code': 'zh', 'name': '中文', 'flag': '🇨🇳'},
    {'code': 'ja', 'name': '日本語', 'flag': '🇯🇵'},
    {'code': 'ko', 'name': '한국어', 'flag': '🇰🇷'},
  ];

  @override
  Widget build(BuildContext context) {
    final currentLanguage = languages.firstWhere(
      (lang) => lang['code'] == selectedLanguage,
      orElse: () => languages.first,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF6C5CE7).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.language,
            color: Color(0xFF6C5CE7),
            size: 20,
          ),
        ),
        title: const Text(
          'Language',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          currentLanguage['name']!,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              currentLanguage['flag']!,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              color: Colors.grey.shade400,
              size: 20,
            ),
          ],
        ),
        onTap: () => _showLanguagePicker(context),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Select Language',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...languages.map((language) {
              final isSelected = language['code'] == selectedLanguage;
              return ListTile(
                leading: Text(
                  language['flag']!,
                  style: const TextStyle(fontSize: 24),
                ),
                title: Text(
                  language['name']!,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? const Color(0xFF6C5CE7) : null,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(
                        Icons.check,
                        color: Color(0xFF6C5CE7),
                      )
                    : null,
                onTap: () {
                  onLanguageChanged(language['code']!);
                  Navigator.pop(context);
                },
              );
            }).toList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}