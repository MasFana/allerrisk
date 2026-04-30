import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../interfaces/i_article_repository.dart';
import '../../models/article_model.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/auth_service.dart';

class MockArticleRepository implements IArticleRepository {
  StorageService get _storage => Get.find<StorageService>();
  AuthService get _auth => Get.find<AuthService>();

  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 600));

  @override
  Future<List<Article>> getPublishedArticles({
    ArticleCategory? category,
    String? searchQuery,
    int limit = 10,
    int offset = 0,
  }) async {
    await _delay();

    var list = _storage
        .readList(StorageKeys.articles)
        .map((e) => Article.fromJson(e))
        .where((a) => a.status == ArticleStatus.published)
        .toList();

    if (category != null && category != ArticleCategory.all) {
      list = list.where((a) => a.category == category).toList();
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase();
      list = list
          .where(
            (a) =>
                a.title.toLowerCase().contains(q) ||
                a.tags.any((t) => t.toLowerCase().contains(q)),
          )
          .toList();
    }

    list.sort(
      (a, b) => (b.publishedAt ?? b.createdAt).compareTo(
        (a.publishedAt ?? a.createdAt),
      ),
    );

    // Mock Pagination
    if (offset >= list.length) return [];
    return list.skip(offset).take(limit).toList();
  }

  @override
  Future<Article> getArticleById(String id) async {
    await _delay();
    final map = _storage.findOne(StorageKeys.articles, 'id', id);
    if (map == null) throw Exception('Article not found');
    return Article.fromJson(map);
  }

  @override
  Future<List<Article>> getArticlesByAuthor(String doctorId) async {
    await _delay();
    return _storage
        .readList(StorageKeys.articles)
        .where((e) => e['author_id'] == doctorId)
        .map((e) => Article.fromJson(e))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<Article> createArticle(Article article) async {
    await _delay();
    final user = _auth.currentUser.value;
    if (user == null) throw Exception('Not logged in');

    final newArticle = Article(
      id: 'art_${const Uuid().v4().substring(0, 8)}',
      authorId: user.id,
      authorName: user.name,
      authorSpecialty: user.specialty,
      authorAvatarUrl: user.avatarUrl,
      title: article.title,
      category: article.category,
      tags: article.tags,
      coverImageUrl: article.coverImageUrl,
      body: article.body,
      status: article.status,
      readTimeMinutes: article.readTimeMinutes,
      createdAt: DateTime.now(),
      publishedAt: article.status == ArticleStatus.published
          ? DateTime.now()
          : null,
    );

    await _storage.upsertOne(StorageKeys.articles, newArticle.toJson());
    return newArticle;
  }

  @override
  Future<Article> updateArticle(Article article) async {
    await _delay();

    final existingMap = _storage.findOne(
      StorageKeys.articles,
      'id',
      article.id,
    );
    if (existingMap == null) throw Exception('Article not found');

    final existing = Article.fromJson(existingMap);

    // Update publishedAt if status changed to published
    DateTime? newPublishedAt = existing.publishedAt;
    if (existing.status == ArticleStatus.draft &&
        article.status == ArticleStatus.published) {
      newPublishedAt = DateTime.now();
    } else if (article.status == ArticleStatus.draft) {
      newPublishedAt = null;
    }

    final updated = article.copyWith(publishedAt: newPublishedAt);
    await _storage.upsertOne(StorageKeys.articles, updated.toJson());
    return updated;
  }

  @override
  Future<void> deleteArticle(String id) async {
    await _delay();
    await _storage.deleteOne(StorageKeys.articles, id);
  }
}
