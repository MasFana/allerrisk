import 'package:get/get.dart';

import '../interfaces/i_assessment_repository.dart';
import '../../models/assessment_payload_model.dart';
import '../../models/assessment_result_model.dart';
import '../../mock/mock_saw_engine.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/auth_service.dart';

class MockAssessmentRepository implements IAssessmentRepository {
  StorageService get _storage => Get.find<StorageService>();
  AuthService get _auth => Get.find<AuthService>();

  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 1200));

  @override
  Future<AssessmentResult> submitAssessment(AssessmentPayload payload) async {
    await _delay(); // Simulate network and heavy SAW processing delay

    final parentId = _auth.currentUser.value?.id;
    if (parentId == null) throw Exception('User not logged in');

    // Process through the Mock SAW Engine
    final result = MockSawEngine.calculate(
      parentId: parentId,
      payload: payload,
    );

    // Persist
    await _storage.upsertOne(StorageKeys.assessments, result.toJson());
    return result;
  }

  @override
  Future<List<AssessmentResult>> getHistoryByChild(String childId) async {
    // Shorter delay for fast history loads
    await Future.delayed(const Duration(milliseconds: 300));

    final list = _storage.readList(StorageKeys.assessments);
    return list
        .where((e) => e['child_id'] == childId)
        .map((e) => AssessmentResult.fromJson(e))
        .toList()
      ..sort((a, b) => b.assessedAt.compareTo(a.assessedAt));
  }

  @override
  Future<AssessmentResult?> getLatestAssessment(String childId) async {
    final history = await getHistoryByChild(childId);
    if (history.isEmpty) return null;
    return history.first;
  }

  @override
  Future<List<AssessmentResult>> getAllHistory() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final list = _storage.readList(StorageKeys.assessments);
    final parentId = _auth.currentUser.value?.id;
    return list
        .where((e) => e['parent_id'] == parentId)
        .map((e) => AssessmentResult.fromJson(e))
        .toList()
      ..sort((a, b) => b.assessedAt.compareTo(a.assessedAt));
  }
}
