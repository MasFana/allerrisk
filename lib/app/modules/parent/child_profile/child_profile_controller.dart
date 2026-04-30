import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/services/auth_service.dart';
import '../../../data/models/child_profile_model.dart';
import '../../../data/repositories/interfaces/i_child_repository.dart';
import '../../../routes/app_routes.dart';
import '../shell/parent_shell_controller.dart';

class ChildProfileController extends GetxController {
  final IChildRepository _childRepo = Get.find<IChildRepository>();
  final AuthService _auth = Get.find<AuthService>();

  // ── Reactive State ────────────────────────────────────────────
  final RxList<ChildProfile> children = <ChildProfile>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isSaving = false.obs;

  // ── Form Fields ───────────────────────────────────────────────
  String formName = '';
  DateTime? formDob;
  Gender formGender = Gender.male;
  double formWeight = 0;
  double formHeight = 0;
  String formNotes = '';
  XFile? formPhoto;

  /// When non-null, we're editing an existing child.
  ChildProfile? editingChild;

  // ── Lifecycle ─────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    loadChildren();
  }

  // ── Data ──────────────────────────────────────────────────────

  Future<void> loadChildren() async {
    isLoading.value = true;
    try {
      final parentId = _auth.currentUser.value?.id ?? '';
      children.value = await _childRepo.getChildren(parentId);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat profil anak: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  /// Prepare form for creating a new child.
  void prepareCreate() {
    editingChild = null;
    _resetForm();
  }

  /// Prepare form for editing an existing child.
  void prepareEdit(ChildProfile child) {
    editingChild = child;
    formName = child.name;
    formDob = child.dateOfBirth;
    formGender = child.gender;
    formWeight = child.weightKg;
    formHeight = child.heightCm;
    formNotes = child.notes ?? '';
    formPhoto = null;
  }

  void _resetForm() {
    formName = '';
    formDob = null;
    formGender = Gender.male;
    formWeight = 0;
    formHeight = 0;
    formNotes = '';
    formPhoto = null;
  }

  Future<void> pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 512,
    );
    if (picked != null) formPhoto = picked;
  }

  Future<void> saveChild() async {
    if (formName.trim().isEmpty || formDob == null) {
      Get.snackbar('Validasi', 'Nama dan tanggal lahir wajib diisi.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    isSaving.value = true;
    try {
      final parentId = _auth.currentUser.value!.id;
      if (editingChild == null) {
        // Create
        final newChild = await _childRepo.createChild(
          parentId: parentId,
          name: formName.trim(),
          dateOfBirth: formDob!,
          gender: formGender,
          weightKg: formWeight,
          heightCm: formHeight,
          notes: formNotes.trim().isEmpty ? null : formNotes.trim(),
          photo: formPhoto,
        );
        children.add(newChild);
      } else {
        // Update
        final updated = ChildProfile(
          id: editingChild!.id,
          parentId: parentId,
          name: formName.trim(),
          dateOfBirth: formDob!,
          gender: formGender,
          weightKg: formWeight,
          heightCm: formHeight,
          photoUrl: editingChild!.photoUrl,
          notes: formNotes.trim().isEmpty ? null : formNotes.trim(),
          createdAt: editingChild!.createdAt,
        );
        final saved = await _childRepo.updateChild(updated, newPhoto: formPhoto);
        final idx = children.indexWhere((c) => c.id == saved.id);
        if (idx >= 0) children[idx] = saved;
      }
      Get.back(); // close form
      Get.snackbar('Berhasil',
          editingChild == null ? 'Profil anak ditambahkan.' : 'Profil diperbarui.',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Gagal menyimpan: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deleteChild(ChildProfile child) async {
    try {
      await _childRepo.deleteChild(child.id);
      children.remove(child);
      Get.snackbar('Berhasil', 'Profil anak dihapus.',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // ── Navigation ────────────────────────────────────────────────

  void goToForm({ChildProfile? child}) {
    if (child != null) {
      prepareEdit(child);
    } else {
      prepareCreate();
    }
    Get.toNamed(Routes.CHILD_FORM);
  }

  void goToAssessment(String childId) {
    _auth.setActiveChild(childId);
    if (Get.isRegistered<ParentShellController>()) {
      Get.back();
      Get.find<ParentShellController>().switchTab(1);
      return;
    }
    Get.toNamed(Routes.ASSESSMENT);
  }
}
