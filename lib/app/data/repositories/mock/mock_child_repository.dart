import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';

import '../interfaces/i_child_repository.dart';
import '../../models/child_profile_model.dart';
import '../../../core/services/storage_service.dart';

class MockChildRepository implements IChildRepository {
  StorageService get _storage => Get.find<StorageService>();

  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 600));

  @override
  Future<List<ChildProfile>> getChildren(String parentId) async {
    await _delay();
    final list = _storage.readList(StorageKeys.children);
    return list
        .where((e) => e['parent_id'] == parentId)
        .map((e) => ChildProfile.fromJson(e))
        .toList()
      // Sort youngest first
      ..sort((a, b) => b.dateOfBirth.compareTo(a.dateOfBirth));
  }

  @override
  Future<ChildProfile> getChildById(String id) async {
    await _delay();
    final map = _storage.findOne(StorageKeys.children, 'id', id);
    if (map == null) throw Exception('Child not found');
    return ChildProfile.fromJson(map);
  }

  @override
  Future<ChildProfile> createChild({
    required String parentId,
    required String name,
    required DateTime dateOfBirth,
    required Gender gender,
    required double weightKg,
    required double heightCm,
    String? notes,
    XFile? photo,
  }) async {
    await _delay();

    // Stub: In a real app we'd upload the photo to Firebase Storage/S3 here
    final String? mockPhotoUrl = photo != null ? 'local://${photo.path}' : null;

    final child = ChildProfile(
      id: 'child_${const Uuid().v4().substring(0, 8)}',
      parentId: parentId,
      name: name,
      dateOfBirth: dateOfBirth,
      gender: gender,
      weightKg: weightKg,
      heightCm: heightCm,
      photoUrl: mockPhotoUrl,
      notes: notes,
      createdAt: DateTime.now(),
    );

    await _storage.upsertOne(StorageKeys.children, child.toJson());
    return child;
  }

  @override
  Future<ChildProfile> updateChild(
    ChildProfile child, {
    XFile? newPhoto,
  }) async {
    await _delay();

    // Stub photo upload
    final String? finalPhotoUrl = newPhoto != null
        ? 'local://${newPhoto.path}'
        : child.photoUrl;

    final updated = ChildProfile(
      id: child.id,
      parentId: child.parentId,
      name: child.name,
      dateOfBirth: child.dateOfBirth,
      gender: child.gender,
      weightKg: child.weightKg,
      heightCm: child.heightCm,
      photoUrl: finalPhotoUrl,
      notes: child.notes,
      createdAt: child.createdAt,
    );

    await _storage.upsertOne(StorageKeys.children, updated.toJson());
    return updated;
  }

  @override
  Future<void> deleteChild(String id) async {
    await _delay();
    await _storage.deleteOne(StorageKeys.children, id);

    // Cascade delete assessments for this child
    final assessments = _storage.readList(StorageKeys.assessments);
    assessments.removeWhere((e) => e['child_id'] == id);
    await _storage.writeList(StorageKeys.assessments, assessments);
  }
}
