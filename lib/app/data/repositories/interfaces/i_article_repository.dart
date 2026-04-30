import '../../models/article_model.dart';

abstract class IArticleRepository {
  // Parent & General
  Future<List<Article>> getPublishedArticles({
    ArticleCategory? category,
    String? searchQuery,
    int limit = 10,
    int offset = 0,
  });
  Future<Article> getArticleById(String id);

  // Doctor specifics
  Future<List<Article>> getArticlesByAuthor(String doctorId);
  Future<Article> createArticle(Article article);
  Future<Article> updateArticle(Article article);
  Future<void> deleteArticle(String id);
}
