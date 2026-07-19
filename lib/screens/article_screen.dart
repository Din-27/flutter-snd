import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_and_drive/components/layout/app_page_scaffold.dart';
import 'package:shop_and_drive/core/theme/app_theme.dart';

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({super.key});

  static const _articles = [
    _ArticleItem(
      title: 'Tips Merawat Mesin Mobil di Musim Hujan',
      category: 'Tips & Trick',
      readTime: '5 min',
      summary: 'Musim hujan bisa menjadi tantangan tersendiri untuk perawatan mobil. Pelajari cara menjaga mesin tetap prima.',
      imageUrl: 'https://images.unsplash.com/photo-1487754180451-c456f719a1fc?q=80&w=400&auto=format&fit=crop',
    ),
    _ArticleItem(
      title: '5 Kesalahan Umum Saat Mengemudi',
      category: 'Safety',
      readTime: '3 min',
      summary: 'Hindari kesalahan umum yang sering dilakukan pengemudi dan tingkatkan keselamatan berkendara.',
      imageUrl: 'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?q=80&w=400&auto=format&fit=crop',
    ),
    _ArticleItem(
      title: 'Cara Memilih Oli Mesin yang Tepat',
      category: 'Review',
      readTime: '4 min',
      summary: 'Pemilihan oli mesin yang tepat sangat penting untuk performa dan umur mesin kendaraan Anda.',
      imageUrl: 'https://images.unsplash.com/photo-1530046339160-ce3e530c7d2f?q=80&w=400&auto=format&fit=crop',
    ),
    _ArticleItem(
      title: 'Tanda-tanda Aki Mobil Harus Diganti',
      category: 'Tips & Trick',
      readTime: '4 min',
      summary: 'Kenali tanda-tanda aki mobil mulai melemah dan kapan waktu yang tepat untuk menggantinya.',
      imageUrl: 'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?q=80&w=400&auto=format&fit=crop',
    ),
    _ArticleItem(
      title: 'Panduan Lengkap Service Berkala',
      category: 'Tips & Trick',
      readTime: '6 min',
      summary: 'Service berkala adalah kunci menjaga performa kendaraan. Simak jadwal dan komponen yang perlu diperiksa.',
      imageUrl: 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?q=80&w=400&auto=format&fit=crop',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Artikel',
      currentIndex: 3,
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _articles.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final article = _articles[index];
          return _ArticleCard(article: article, onTap: () => context.go('/article/${index + 1}'));
        },
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.article, required this.onTap});
  final _ArticleItem article;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE8EBF1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                article.imageUrl,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  height: 140,
                  color: AppTheme.accent,
                  child: const Icon(Icons.article_rounded, color: AppTheme.primary, size: 48),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.accent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          article.category,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.access_time, size: 14, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text(article.readTime, style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(article.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 6),
                  Text(
                    article.summary,
                    style: TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArticleItem {
  const _ArticleItem({
    required this.title,
    required this.category,
    required this.readTime,
    required this.summary,
    required this.imageUrl,
  });
  final String title;
  final String category;
  final String readTime;
  final String summary;
  final String imageUrl;
}