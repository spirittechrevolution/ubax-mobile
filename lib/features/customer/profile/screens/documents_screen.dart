import 'package:flutter/material.dart';

import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

// ─── Data ─────────────────────────────────────────────────────────────────────

class _DocumentSection {
  const _DocumentSection({
    required this.title,
    required this.fileName,
    required this.fileSize,
  });

  final String title;
  final String fileName;
  final String fileSize;
}

const _kDocuments = [
  _DocumentSection(
    title: 'Piéce d\'identité',
    fileName: 'Carte d\'identité .jpg',
    fileSize: '169 KB',
  ),
  _DocumentSection(
    title: 'Contrat de bail',
    fileName: 'Contrat de bail.pdf',
    fileSize: '147 KB',
  ),
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Dark header
          Container(
            padding: EdgeInsets.fromLTRB(18, topPadding + 20, 18, 28),
            decoration: const BoxDecoration(
              color: AppColors.text,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Title
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 20),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Mes documents',
                          style: AppTextStyles.sectionTitle.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
                const SizedBox(height: 14),
                // Search bar
                Container(
                  height: 45,
                  margin: EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF243E55),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Rechercher un document',
                          style: AppTextStyles.regular12.copyWith(
                            color: const Color(0xFF94A3B8),
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const Icon(Icons.search_rounded,
                          color: Colors.white, size: 22),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Body
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
              itemCount: _kDocuments.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, i) => _DocumentCard(doc: _kDocuments[i]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Document card ────────────────────────────────────────────────────────────

class _DocumentCard extends StatelessWidget {
  const _DocumentCard({required this.doc});

  final _DocumentSection doc;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 285,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            doc.title,
            style: AppTextStyles.sectionTitle
                .copyWith(color: AppColors.text, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 24),
          // File row
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0E6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.description_outlined,
                      color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc.fileName,
                        style: AppTextStyles.sectionTitle.copyWith(
                            color: AppColors.text,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        doc.fileSize,
                        style: AppTextStyles.regular12.copyWith(
                            color: AppColors.text,
                            fontSize: 11,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.check_circle_rounded,
                    color: AppColors.primary, size: 22),
              ],
            ),
          ),
          const SizedBox(height: 36),
          // Telecharger button
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.dark,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              onPressed: () {},
              child: const Text(
                'Telecharger',
                style: AppTextStyles.button,
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Voir le document
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.dark,
                side: const BorderSide(color: Color(0xFFE5E7EB)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              onPressed: () {},
              icon: const Icon(Icons.visibility_rounded, size: 18),
              label: const Text(
                'Voir le document',
                style: AppTextStyles.button,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
