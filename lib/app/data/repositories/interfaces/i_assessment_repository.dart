import '../../models/assessment_payload_model.dart';
import '../../models/assessment_result_model.dart';

abstract class IAssessmentRepository {
  Future<AssessmentResult> submitAssessment(AssessmentPayload payload);
  Future<List<AssessmentResult>> getHistoryByChild(String childId);
  Future<AssessmentResult?> getLatestAssessment(String childId);
  /// Returns all assessments across all children for the current parent.
  Future<List<AssessmentResult>> getAllHistory();
}
