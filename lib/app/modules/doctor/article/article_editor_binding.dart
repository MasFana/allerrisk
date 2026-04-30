import 'package:get/get.dart';
import 'article_editor_controller.dart';

class ArticleEditorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArticleEditorController>(() => ArticleEditorController());
  }
}
