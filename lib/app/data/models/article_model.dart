enum ArticleStatus { draft, published }

enum ArticleCategory {
  all,
  foodAllergy,
  asthma,
  eczema,
  environment,
  parentingTips,
  general,
}

extension ArticleCategoryLabel on ArticleCategory {
  String get label {
    switch (this) {
      case ArticleCategory.all:
        return 'Semua';
      case ArticleCategory.foodAllergy:
        return 'Alergi Makanan';
      case ArticleCategory.asthma:
        return 'Asma';
      case ArticleCategory.eczema:
        return 'Eksim';
      case ArticleCategory.environment:
        return 'Lingkungan';
      case ArticleCategory.parentingTips:
        return 'Tips Orang Tua';
      case ArticleCategory.general:
        return 'Umum';
    }
  }
}

class Article {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorSpecialty;
  final String? authorAvatarUrl;
  final String title;
  final ArticleCategory category;
  final List<String> tags;
  final String? coverImageUrl;
  final String body; // Contains HTML
  final ArticleStatus status;
  final int readTimeMinutes;
  final DateTime createdAt;
  final DateTime? publishedAt;

  const Article({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorSpecialty,
    this.authorAvatarUrl,
    required this.title,
    required this.category,
    required this.tags,
    this.coverImageUrl,
    required this.body,
    required this.status,
    required this.readTimeMinutes,
    required this.createdAt,
    this.publishedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
    id: json['id'] as String,
    authorId: json['author_id'] as String,
    authorName: json['author_name'] as String,
    authorSpecialty: json['author_specialty'] as String?,
    authorAvatarUrl: json['author_avatar_url'] as String?,
    title: json['title'] as String,
    category: ArticleCategory.values.byName(
      json['category'] as String? ?? ArticleCategory.general.name,
    ),
    tags: (json['tags'] as List).cast<String>(),
    coverImageUrl: json['cover_image_url'] as String?,
    body: json['body'] as String,
    status: ArticleStatus.values.byName(json['status'] as String),
    readTimeMinutes: json['read_time_minutes'] as int? ?? 5,
    createdAt: DateTime.parse(json['created_at'] as String),
    publishedAt: json['published_at'] != null
        ? DateTime.parse(json['published_at'] as String)
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'author_id': authorId,
    'author_name': authorName,
    'author_specialty': authorSpecialty,
    'author_avatar_url': authorAvatarUrl,
    'title': title,
    'category': category.name,
    'tags': tags,
    'cover_image_url': coverImageUrl,
    'body': body,
    'status': status.name,
    'read_time_minutes': readTimeMinutes,
    'created_at': createdAt.toIso8601String(),
    'published_at': publishedAt?.toIso8601String(),
  };

  Article copyWith({
    String? title,
    ArticleCategory? category,
    List<String>? tags,
    String? coverImageUrl,
    String? body,
    ArticleStatus? status,
    int? readTimeMinutes,
    DateTime? publishedAt,
  }) {
    return Article(
      id: id,
      authorId: authorId,
      authorName: authorName,
      authorSpecialty: authorSpecialty,
      authorAvatarUrl: authorAvatarUrl,
      title: title ?? this.title,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      body: body ?? this.body,
      status: status ?? this.status,
      readTimeMinutes: readTimeMinutes ?? this.readTimeMinutes,
      createdAt: createdAt,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }
}
