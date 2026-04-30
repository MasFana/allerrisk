import '../../models/patient_model.dart';
import '../../models/clinical_note_model.dart';

abstract class IPatientRepository {
  Future<List<Patient>> getPatientsForDoctor(String doctorId);
  Future<Patient> getPatientDetail(String childId);
  Future<List<ClinicalNote>> getNotesForPatient(String childId);
  Future<ClinicalNote> addClinicalNote({
    required String doctorId,
    required String doctorName,
    required String childId,
    String? assessmentId,
    required String note,
  });
}
