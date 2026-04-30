import '../../models/child_profile_model.dart';
import 'package:image_picker/image_picker.dart';

abstract class IChildRepository {
  Future<List<ChildProfile>> getChildren(String parentId);
  Future<ChildProfile> getChildById(String id);
  Future<ChildProfile> createChild({
    required String parentId,
    required String name,
    required DateTime dateOfBirth,
    required Gender gender,
    required double weightKg,
    required double heightCm,
    String? notes,
    XFile? photo,
  });
  Future<ChildProfile> updateChild(ChildProfile child, {XFile? newPhoto});
  Future<void> deleteChild(String id);
}
