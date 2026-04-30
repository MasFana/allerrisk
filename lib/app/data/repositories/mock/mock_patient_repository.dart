import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../interfaces/i_patient_repository.dart';
import '../../models/patient_model.dart';
import '../../models/user_model.dart';
import '../../models/child_profile_model.dart';
import '../../models/assessment_result_model.dart';
import '../../models/clinical_note_model.dart';
import '../../../core/services/storage_service.dart';

class MockPatientRepository implements IPatientRepository {
  StorageService get _storage => Get.find<StorageService>();

  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 700));

  @override
  Future<List<Patient>> getPatientsForDoctor(String doctorId) async {
    await _delay();

    // In Prototype, doctors see all children who have taken at least one assessment.
    // In Production: this relies on a share_token linkage table.

    final allChildren = _storage
        .readList(StorageKeys.children)
        .map((e) => ChildProfile.fromJson(e))
        .toList();
    final allUsers = _storage
        .readList(StorageKeys.users)
        .map((e) => UserModel.fromJson(e))
        .toList();
    final allAssessmentsRaw = _storage.readList(StorageKeys.assessments);

    final List<Patient> patients = [];

    for (final child in allChildren) {
      final childAssessments =
          allAssessmentsRaw
              .where((a) => a['child_id'] == child.id)
              .map((a) => AssessmentResult.fromJson(a))
              .toList()
            ..sort((a, b) => b.assessedAt.compareTo(a.assessedAt));

      if (childAssessments.isEmpty) {
        continue; // Only show patients with assessments
      }

      final parent = allUsers.firstWhereOrNull((u) => u.id == child.parentId);
      if (parent == null) continue;

      patients.add(
        Patient(
          parent: parent,
          child: child,
          latestAssessment: childAssessments.first,
          pastAssessments: childAssessments,
        ),
      );
    }

    // Sort: High risk first, then by latest assessment date
    patients.sort((a, b) {
      if (a.latestAssessment?.level == RiskLevel.high &&
          b.latestAssessment?.level != RiskLevel.high) {
        return -1;
      }
      if (a.latestAssessment?.level != RiskLevel.high &&
          b.latestAssessment?.level == RiskLevel.high) {
        return 1;
      }
      final dateA = a.latestAssessment?.assessedAt ?? DateTime(1970);
      final dateB = b.latestAssessment?.assessedAt ?? DateTime(1970);
      return dateB.compareTo(dateA);
    });

    return patients;
  }

  @override
  Future<Patient> getPatientDetail(String childId) async {
    await _delay();

    final childMap = _storage.findOne(StorageKeys.children, 'id', childId);
    if (childMap == null) throw Exception('Patient not found');
    final child = ChildProfile.fromJson(childMap);

    final parentMap = _storage.findOne(StorageKeys.users, 'id', child.parentId);
    if (parentMap == null) throw Exception('Parent profile missing');
    final parent = UserModel.fromJson(parentMap);

    final childAssessments =
        _storage
            .readList(StorageKeys.assessments)
            .where((a) => a['child_id'] == childId)
            .map((a) => AssessmentResult.fromJson(a))
            .toList()
          ..sort((a, b) => b.assessedAt.compareTo(a.assessedAt));

    return Patient(
      parent: parent,
      child: child,
      latestAssessment: childAssessments.isNotEmpty
          ? childAssessments.first
          : null,
      pastAssessments: childAssessments,
    );
  }

  @override
  Future<List<ClinicalNote>> getNotesForPatient(String childId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _storage
        .readList(StorageKeys.clinicalNotes)
        .where((n) => n['patient_child_id'] == childId)
        .map((n) => ClinicalNote.fromJson(n))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<ClinicalNote> addClinicalNote({
    required String doctorId,
    required String doctorName,
    required String childId,
    String? assessmentId,
    required String note,
  }) async {
    await _delay();

    final clinicalNote = ClinicalNote(
      id: 'note_${const Uuid().v4().substring(0, 8)}',
      doctorId: doctorId,
      doctorName: doctorName,
      patientChildId: childId,
      assessmentId: assessmentId,
      note: note,
      createdAt: DateTime.now(),
    );

    await _storage.upsertOne(StorageKeys.clinicalNotes, clinicalNote.toJson());
    return clinicalNote;
  }
}
