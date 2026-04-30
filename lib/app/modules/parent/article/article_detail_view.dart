import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../data/models/article_model.dart';
import 'article_detail_controller.dart';

class ArticleDetailView extends GetView<ArticleDetailController> {
  const ArticleDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final article = controller.article.value;
        if (article == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Artikel tidak ditemukan')),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 250,
              pinned: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    Share.share('Baca artikel edukasi ini: ${article.title}');
                  },
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: article.coverImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: article.coverImageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Container(color: Colors.grey[300]),
                        errorWidget: (context, url, error) =>
                            Container(color: Colors.grey[300]),
                      )
                    : Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.article,
                          size: 80,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(AppDimensions.lg),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Category & Time
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          article.category.label,
                          style: Get.textTheme.labelSmall?.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${article.readTimeMinutes} min read',
                        style: Get.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.md),

                  // Title
                  Text(
                    article.title,
                    style: Get.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.md),

                  // Author Info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: article.authorAvatarUrl != null
                            ? CachedNetworkImageProvider(
                                article.authorAvatarUrl!,
                              )
                            : null,
                        child: article.authorAvatarUrl == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      const SizedBox(width: AppDimensions.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article.authorName,
                              style: Get.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (article.authorSpecialty != null)
                              Text(
                                article.authorSpecialty!,
                                style: Get.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (article.publishedAt != null)
                        Text(
                          DateFormat(
                            'dd MMM yyyy',
                          ).format(article.publishedAt!),
                          style: Get.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),

                  const Divider(height: AppDimensions.xxl),

                  // Content
                  Html(
                    data: article.body,
                    style: {
                      "body": Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                        fontSize: FontSize(16.0),
                        lineHeight: LineHeight(1.5),
                        color: Get.isDarkMode ? Colors.white : Colors.black87,
                      ),
                      "p": Style(margin: Margins.only(bottom: 16)),
                      "img": Style(
                        width: Width(100, Unit.percent),
                        padding: HtmlPaddings.only(bottom: 16),
                      ),
                    },
                  ),

                  const SizedBox(height: AppDimensions.xxl),
                ]),
              ),
            ),
          ],
        );
      }),
    );
  }
}
