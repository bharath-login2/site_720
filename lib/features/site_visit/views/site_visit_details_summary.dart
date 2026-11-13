import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/connectivity_dialog.dart';
import '../../../core/widgets/snack_bar.dart';
import '../../../data/models/visit/visit_questions_model.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../connectivity/cubit/connectivity_state.dart';
import '../cubit/site_visit_details_cubit.dart';
import '../cubit/site_visit_details_state.dart';

class VisitDetails extends StatefulWidget {
  const VisitDetails({super.key});

  @override
  State<VisitDetails> createState() => _VisitDetailsState();
}

class _VisitDetailsState extends State<VisitDetails> {
  final Map<int, TextEditingController> _text = {};
  final Map<int, String> _choice = {};
  final Map<int, List<String>> _files = {}; // picked on phone, not uploaded yet
  final Set<String> _deleting = {}; // server file ids being deleted
  final Map<int, GlobalKey> _keys = {}; // one key per question card
  final ScrollController _scroll = ScrollController();

  VisitTaskData? _loaded;
  bool _serverCompleted = false; // status the server returned
  bool _editing = false; // user reopened a completed visit for editing
  bool _showErrors = false;
  bool _saving = false;
  bool _savingComplete = false; // which button is showing the spinner
  bool _changed = false; // something was saved/deleted: the list must reload

  /// View only: the server says Completed and the user has not tapped Edit.
  bool get _readOnly => _serverCompleted && !_editing;

  String _arg(Map<String, dynamic> args, String key) =>
      args[key]?.toString().trim() ?? "";

  @override
  void dispose() {
    for (final c in _text.values) {
      c.dispose();
    }
    _scroll.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // COLORS
  // ---------------------------------------------------------------------------
  Color _priorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case "high":
        return Colors.red;
      case "medium":
        return Colors.orange;
      case "low":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  static const Color _completedColor = Color.fromARGB(255, 10, 180, 90);
  Color get _pendingColor => Colors.amber.shade800;

  // ---------------------------------------------------------------------------
  // HELPERS
  // ---------------------------------------------------------------------------
  bool _isImage(String s) {
    final last = s.split('?').first.split('/').last.toLowerCase();
    if (!last.contains('.')) return true;
    final ext = last.split('.').last;
    return const ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'heic']
        .contains(ext);
  }

  /// Only these image types can be attached.
  static const List<String> _allowedExt = ['jpg', 'jpeg', 'png', 'heic'];
  static const int _maxImageMb = 5; // change to match your server limit

  String _ext(String path) {
    final name = path.split('?').first.split('/').last.toLowerCase();
    return name.contains('.') ? name.split('.').last : '';
  }

  static const String _fileBaseUrl = "";

  String _fullUrl(String u) {
    final t = u.trim();
    if (t.isEmpty || t.startsWith('http')) return t;
    if (_fileBaseUrl.isEmpty) return t;
    return "$_fileBaseUrl${t.startsWith('/') ? t.substring(1) : t}";
  }

  String _baseName(String s) => s.split('?').first.split('/').last;

  // ---------------------------------------------------------------------------
  // ANSWER STATE
  // ---------------------------------------------------------------------------
  void _initFrom(VisitTaskData data) {
    // The old TextFields are still mounted while this build runs, so their
    // controllers must only be disposed after the frame has finished.
    final old = _text.values.toList();
    if (old.isNotEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        for (final c in old) {
          c.dispose();
        }
      });
    }

    _text.clear();
    _choice.clear();
    _files.clear();
    _deleting.clear();

    for (final q in data.questions) {
      if (q.answerType == 'text_box') {
        _text[q.questionId] = TextEditingController(text: q.answer);
      } else if (q.answerType == 'checkbox' && q.answer.isNotEmpty) {
        _choice[q.questionId] = q.answer;
      }
    }
    _serverCompleted = data.isCompleted;
    _editing = false;
    _showErrors = false;
    _loaded = data;
  }

  /// True when the user changed something that is not saved on the server yet.
  bool _hasUnsavedChanges() {
    final data = _loaded;
    if (data == null) return false;
    if (_files.values.any((l) => l.isNotEmpty)) return true;
    for (final q in data.questions) {
      if (q.answerType == 'text_box' &&
          (_text[q.questionId]?.text.trim() ?? '') != q.answer.trim()) {
        return true;
      }
      if (q.answerType == 'checkbox' &&
          (_choice[q.questionId] ?? '') != q.answer) {
        return true;
      }
    }
    return false;
  }

  bool _isFilled(VisitQuestion q) {
    switch (q.answerType) {
      case 'text_box':
        return (_text[q.questionId]?.text.trim() ?? '').isNotEmpty;
      case 'checkbox':
        return (_choice[q.questionId] ?? '').isNotEmpty;
      case 'file_upload':
        return (_files[q.questionId]?.isNotEmpty ?? false) || q.hasFiles;
      default:
        return true;
    }
  }

  bool _requiredMet(List<VisitQuestion> qs) =>
      qs.where((q) => q.isRequired).every(_isFilled);

  Future<bool> _confirm({
    required String title,
    required String message,
    required String confirmLabel,
    String cancelLabel = "Cancel",
    Color confirmColor = AppColors.primaryColor,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Text(message, style: const TextStyle(fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(cancelLabel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(confirmLabel,
                style: TextStyle(
                    color: confirmColor, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<bool> _confirmDiscard(String message) => _confirm(
        title: "Discard changes?",
        message: message,
        confirmLabel: "Discard",
        cancelLabel: "Keep editing",
        confirmColor: Colors.red,
      );

  // ---------------------------------------------------------------------------
  // ACTIONS
  // ---------------------------------------------------------------------------
  Future<void> _save(VisitTaskCubit cubit, List<VisitQuestion> qs,
      {required bool complete}) async {
    if (_readOnly || _saving) return;

    if (complete && !_requiredMet(qs)) {
      setState(() => _showErrors = true);
      snackBar(
          context, "Fill all required questions before completing", Colors.red);
      _scrollToFirstMissing(qs);
      return;
    }

    if (complete) {
      final ok = await _confirm(
        title: "Complete this visit?",
        message:
            "The visit will be locked. You can tap Edit visit later if you need to change it.",
        confirmLabel: "Complete",
        confirmColor: _completedColor,
      );
      if (!ok || !mounted) return;
    }

    final answers = <Map<String, dynamic>>[];
    for (final q in qs) {
      String answer = "";
      if (q.answerType == 'text_box') {
        answer = _text[q.questionId]?.text.trim() ?? "";
      } else if (q.answerType == 'checkbox') {
        answer = _choice[q.questionId] ?? "";
      }
      answers.add({
        "question_id": q.questionId,
        "answer_type": q.answerType,
        "answer": answer,
      });
    }

    _savingComplete = complete;
    cubit.save(
      status: complete ? "Completed" : "Pending",
      answers: answers,
      files: {
        for (final e in _files.entries)
          if (e.value.isNotEmpty) e.key: List<String>.from(e.value),
      },
    );
  }

  /// Brings the first unanswered required question into view.
  void _scrollToFirstMissing(List<VisitQuestion> qs) {
    final first = qs.where((q) => q.isRequired && !_isFilled(q)).firstOrNull;
    if (first == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _keys[first.questionId]?.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
          alignment: 0.1,
        );
      }
    });
  }

  void _scrollToTop() {
    if (_scroll.hasClients) {
      _scroll.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  void _startEditing() => setState(() => _editing = true);

  Future<void> _cancelEditing() async {
    if (_hasUnsavedChanges()) {
      final ok = await _confirmDiscard(
          "Your edits will be lost. Files you already deleted stay deleted.");
      if (!ok || !mounted) return;
    }
    final data = _loaded;
    if (data != null) setState(() => _initFrom(data));
  }

  Future<void> _refresh(VisitTaskCubit cubit) async {
    if (_saving || _deleting.isNotEmpty) return;
    if (_hasUnsavedChanges()) {
      final ok = await _confirmDiscard(
          "Refreshing will reload the visit and your unsaved edits will be lost.");
      if (!ok || !mounted) return;
    }
    final success = await cubit.refresh();
    if (!mounted) return;
    if (!success) {
      snackBar(context, "Could not refresh. Please try again.", Colors.red);
    }
  }

  /// Used by the AppBar arrow, the system back button and the back gesture.
  Future<void> _onBack() async {
    if (!_hasUnsavedChanges()) {
      Navigator.of(context).pop(_changed);
      return;
    }
    final ok = await _confirmDiscard(
        "You have unsaved changes. If you leave now they will be lost.");
    if (ok && mounted) Navigator.of(context).pop(_changed);
  }

  // ---------------------------------------------------------------------------
  // FILES
  // ---------------------------------------------------------------------------
  /// Asks where the photo comes from, then adds it through the same checks.
  Future<void> _pickFiles(VisitQuestion q) async {
    if (_readOnly) return;

    final source = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined,
                  color: AppColors.primaryColor),
              title: const Text("Take photo"),
              onTap: () => Navigator.pop(ctx, 'camera'),
            ),
            ListTile(
              leading: const Icon(Icons.folder_open_outlined,
                  color: AppColors.primaryColor),
              title: const Text("Choose from files"),
              onTap: () => Navigator.pop(ctx, 'files'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;

    final picked = <({String name, String path, int size})>[];

    if (source == 'camera') {
      try {
        final x = await ImagePicker()
            .pickImage(source: ImageSource.camera, imageQuality: 85);
        if (x == null) return;
        picked.add((name: x.name, path: x.path, size: await x.length()));
      } catch (_) {
        if (mounted) {
          snackBar(
              context,
              "Could not open the camera. Check the camera permission.",
              Colors.red);
        }
        return;
      }
    } else {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: _allowedExt,
      );
      if (result == null) return;
      for (final f in result.files) {
        final path = f.path;
        if (path == null) continue;
        picked.add((
          name: f.name.isNotEmpty ? f.name : _baseName(path),
          path: path,
          size: f.size,
        ));
      }
    }

    if (!mounted) return;
    _addPicked(q, picked);
  }

  /// Same checks for camera photos and picked files: image type and size.
  void _addPicked(
      VisitQuestion q, List<({String name, String path, int size})> items) {
    final list = _files.putIfAbsent(q.questionId, () => []);
    final notImage = <String>[];
    final tooBig = <String>[];
    final toAdd = <String>[];

    for (final f in items) {
      if (!_allowedExt.contains(_ext(f.name))) {
        notImage.add(f.name);
        continue;
      }
      if (f.size > _maxImageMb * 1024 * 1024) {
        tooBig.add(f.name);
        continue;
      }
      if (!list.contains(f.path) && !toAdd.contains(f.path)) toAdd.add(f.path);
    }

    if (toAdd.isNotEmpty) setState(() => list.addAll(toAdd));

    if (notImage.isNotEmpty) {
      snackBar(
        context,
        "Only images are allowed (JPG, PNG, WEBP, HEIC). Skipped: ${notImage.join(', ')}",
        Colors.red,
      );
    } else if (tooBig.isNotEmpty) {
      snackBar(
        context,
        "Image too large (max $_maxImageMb MB). Skipped: ${tooBig.join(', ')}",
        Colors.red,
      );
    }
  }

  /// Not uploaded yet: just remove it from the phone list. No API, no dialog.
  void _removePicked(VisitQuestion q, String path) {
    if (_readOnly) return;
    setState(() => _files[q.questionId]?.remove(path));
  }

  /// Already uploaded: confirm, call the delete API, then remove it from screen.
  Future<void> _deleteServerFile(
      VisitTaskCubit cubit, VisitQuestion q, VisitFile f) async {
    if (_readOnly || f.id.isEmpty || _deleting.contains(f.id)) return;

    final name = f.name.isNotEmpty ? f.name : _baseName(f.url);
    final ok = await _confirm(
      title: "Delete file?",
      message:
          "\"$name\" will be deleted from the server right away, even if you do not save the other changes. This cannot be undone.",
      confirmLabel: "Delete",
      confirmColor: Colors.red,
    );
    if (!ok || !mounted) return;

    setState(() => _deleting.add(f.id));
    final success = await cubit.deleteFile(f.id);
    if (!mounted) return;

    setState(() {
      _deleting.remove(f.id);
      if (success) {
        q.files.remove(f);
        _changed = true;
      }
    });

    if (success) {
      snackBar(context, "File deleted", Colors.green);
    } else {
      snackBar(
          context, "Could not delete the file. Please try again.", Colors.red);
    }
  }

  void _openImage({String? url, String? path}) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            Positioned.fill(
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 5,
                child: Center(
                  child: path != null
                      ? Image.file(File(path), fit: BoxFit.contain)
                      : Image.network(
                          url!,
                          fit: BoxFit.contain,
                          loadingBuilder: (c, child, p) => p == null
                              ? child
                              : const Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.white)),
                          errorBuilder: (c, e, s) => const Icon(
                              Icons.broken_image,
                              color: Colors.white54,
                              size: 64),
                        ),
                ),
              ),
            ),
            Positioned(
              top: 32,
              right: 12,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // APP BAR (local copy of simpleAppbar so the arrow can call _onBack)
  // ---------------------------------------------------------------------------
  PreferredSizeWidget _appBar() {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return PreferredSize(
      preferredSize: Size.fromHeight(h * 0.2),
      child: Container(
        height: h * 0.15,
        width: w,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/appbar.png"),
            fit: BoxFit.fill,
          ),
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 15, top: 35),
          child: Row(
            children: [
              InkWell(
                onTap: _onBack,
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  "Visit Details",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    fontFamily: "Lobster",
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final args = (ModalRoute.of(context)?.settings.arguments as Map?)
            ?.cast<String, dynamic>() ??
        <String, dynamic>{};

    // final visitId =
    //     _arg(args, "id").isNotEmpty ? _arg(args, "id") : _arg(args, "visit_id");
    final visitId = _arg(args, "id");
    return BlocProvider(
      create: (_) => VisitTaskCubit(visitId),
      child: MultiBlocListener(
        listeners: [
          BlocListener<ConnectivityCubit, ConnectivityState>(
            listener: (context, state) {
              if (state is ConnectivityDisconnected) {
                if (connStatus == true) {
                  connStatus = false;
                  connectivityDialog(context);
                }
              } else {
                connStatus = true;
              }
            },
          ),
          BlocListener<VisitTaskCubit, VisitTaskState>(
            listener: (context, state) {
              if (state is VisitTaskSaving) {
                setState(() => _saving = true);
              } else if (state is VisitTaskSaved) {
                setState(() {
                  _saving = false;
                  _changed = true;
                });
                snackBar(context, state.message, Colors.green);
                _scrollToTop();
                context.read<VisitTaskCubit>().load();
              } else if (state is VisitTaskSaveFailed) {
                setState(() => _saving = false);
                snackBar(context, "Something went wrong. Please try again.",
                    Colors.red);
              }
            },
          ),
        ],
        // canPop is always false so we can check for unsaved edits ourselves.
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            _onBack();
          },
          child: Scaffold(
            backgroundColor: AppColors.backgroundColor,
            // The arrow goes through _onBack, same as system back and swipe.
            appBar: _appBar(),
            body: BlocBuilder<VisitTaskCubit, VisitTaskState>(
              buildWhen: (p, c) =>
                  c is VisitTaskLoading ||
                  c is VisitTaskLoaded ||
                  c is VisitTaskFailure,
              builder: (context, state) {
                final cubit = context.read<VisitTaskCubit>();

                if (state is VisitTaskLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is VisitTaskFailure) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline,
                            size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 8),
                        Text(
                          "Something went wrong",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          onPressed: cubit.load,
                          icon: const Icon(Icons.refresh, size: 18),
                          label: const Text("Retry"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primaryColor,
                            side:
                                const BorderSide(color: AppColors.primaryColor),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (state is VisitTaskLoaded) {
                  if (!identical(_loaded, state.data)) {
                    _initFrom(state.data);
                  }
                  final qs = state.data.questions;

                  return Column(
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                          color: AppColors.primaryColor,
                          onRefresh: () => _refresh(cubit),
                          child: ListView(
                            controller: _scroll,
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(14),
                            children: [
                              _summaryCard(args),
                              const SizedBox(height: 12),
                              _statusCard(),
                              const SizedBox(height: 12),
                              if (qs.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 40),
                                  child: Center(
                                    child: Text(
                                      "No questions for this visit",
                                      style: TextStyle(
                                          color: Colors.grey.shade600),
                                    ),
                                  ),
                                ),
                              for (final q in qs) _questionCard(q, cubit),
                            ],
                          ),
                        ),
                      ),
                      if (!_readOnly) _saveBar(cubit, qs),
                    ],
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SUMMARY
  // ---------------------------------------------------------------------------
  Widget _summaryCard(Map<String, dynamic> args) {
    final title = _arg(args, "task_title");
    final project = _arg(args, "project_name");
    final stage = _arg(args, "stage_name");
    final priority = _arg(args, "priority");
    final from = _arg(args, "from_date");
    final to = _arg(args, "to_date");
    final desc = _arg(args, "description");
    final assignedTo = _arg(args, "staff_name");
    final completedBy = _loaded?.answeredBy ?? "";
    // GUESS: confirm the real key for the person who completed the visit.
    // var completedBy = _arg(args, "completed_by");
    // if (completedBy.isEmpty) completedBy = _arg(args, "completed_by_name");

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.isEmpty ? "-" : title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Icon(Icons.apartment,
                    size: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(project,
                    style:
                        TextStyle(fontSize: 11, color: Colors.grey.shade700)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              if (stage.isNotEmpty) _labelTag("Stage", stage, Colors.blueGrey),
              if (priority.isNotEmpty)
                _labelTag("Priority", priority, _priorityColor(priority)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _dateInfo("From", from)),
              Icon(Icons.arrow_forward, size: 16, color: Colors.grey.shade400),
              Expanded(child: _dateInfo("To", to, alignEnd: true)),
            ],
          ),
          if (desc.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(desc,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
          ],
          const SizedBox(height: 10),
          Divider(height: 1, color: Colors.grey.shade200),
          const SizedBox(height: 8),
          _personRow(Icons.person_outline, "Assigned to", assignedTo,
              emptyText: "Unassigned"),
          if (_serverCompleted) ...[
            const SizedBox(height: 6),
            _personRow(Icons.verified_outlined, "Completed by", completedBy,
                emptyText: "-", color: _completedColor),
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // STATUS CARD (no toggle)
  // ---------------------------------------------------------------------------
  Widget _statusCard() {
    final Color color;
    final String label;
    final IconData icon;
    final String message;

    if (_readOnly) {
      color = _completedColor;
      label = "Completed";
      icon = Icons.lock_outline;
      message = "This visit is completed and view only.";
    } else if (_serverCompleted) {
      color = _pendingColor;
      label = "Editing";
      icon = Icons.edit_outlined;
      message =
          "You are editing a completed visit. Save draft reopens it as Pending. Save & Complete locks it again.";
    } else {
      color = _pendingColor;
      label = "Pending";
      icon = Icons.info_outline;
      message =
          "Fill all required (*) questions, then tap Save & Complete. Tap Save draft to finish later.";
    }

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Visit Status",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700)),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(label,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: color)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _banner(icon: icon, color: color, text: message),
          if (_readOnly) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _startEditing,
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text("Edit visit"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryColor,
                  side: const BorderSide(color: AppColors.primaryColor),
                ),
              ),
            ),
          ] else if (_serverCompleted) ...[
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _cancelEditing,
                child: const Text("Cancel editing"),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _personRow(IconData icon, String label, String value,
      {required String emptyText, Color? color}) {
    final empty = value.isEmpty;
    return Row(
      children: [
        Icon(icon, size: 15, color: color ?? Colors.grey.shade600),
        const SizedBox(width: 6),
        Text("$label: ",
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
        Expanded(
          child: Text(
            empty ? emptyText : value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontStyle: empty ? FontStyle.italic : FontStyle.normal,
              color: empty ? Colors.grey.shade400 : (color ?? Colors.black87),
            ),
          ),
        ),
      ],
    );
  }

  Widget _banner(
      {required IconData icon, required Color color, required String text}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade800)),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // QUESTIONS
  // ---------------------------------------------------------------------------
  Widget _questionCard(VisitQuestion q, VisitTaskCubit cubit) {
    final readOnly = _readOnly;
    final missing = _showErrors && !readOnly && q.isRequired && !_isFilled(q);

    Widget body;
    switch (q.answerType) {
      case 'text_box':
        body = _textAnswer(q);
        break;
      case 'checkbox':
        body = _checkboxAnswer(q);
        break;
      case 'file_upload':
        body = _fileAnswer(q, cubit);
        break;
      default:
        body = const SizedBox();
    }

    return Padding(
      key: _keys.putIfAbsent(q.questionId, () => GlobalKey()),
      padding: const EdgeInsets.only(bottom: 12),
      child: _card(
        borderColor: missing ? Colors.red.shade300 : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "${q.questionNumber}. ${q.question}",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  if (q.isRequired && !readOnly)
                    const TextSpan(
                      text: " *",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            body,
            if (missing)
              const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text("This question is required",
                    style: TextStyle(fontSize: 11, color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _readOnlyText(String value, {IconData? icon}) {
    final empty = value.trim().isEmpty;
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 6),
        ],
        Expanded(
          child: Text(
            empty ? "Not answered" : value,
            style: TextStyle(
              fontSize: 13,
              fontStyle: empty ? FontStyle.italic : FontStyle.normal,
              color: empty ? Colors.grey.shade400 : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _textAnswer(VisitQuestion q) {
    if (_readOnly) {
      return _readOnlyText(_text[q.questionId]?.text ?? q.answer);
    }

    return TextField(
      controller: _text[q.questionId],
      minLines: 1,
      maxLines: 4,
      style: const TextStyle(fontSize: 13),
      onChanged: (_) {
        if (_showErrors) setState(() {});
      },
      decoration: InputDecoration(
        hintText: "Enter your answer",
        isDense: true,
        contentPadding: const EdgeInsets.all(10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  Widget _checkboxAnswer(VisitQuestion q) {
    if (_readOnly) {
      return _readOnlyText(_choice[q.questionId] ?? q.answer,
          icon: Icons.radio_button_checked);
    }

    // Only one answer is stored per question, so show it as a single choice.
    final selected = _choice[q.questionId];
    return Column(
      children: q.options.map((option) {
        final isSelected = selected == option;
        return InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: () => setState(() => _choice[q.questionId] = option),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  size: 22,
                  color: isSelected
                      ? AppColors.primaryColor
                      : Colors.grey.shade500,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(option, style: const TextStyle(fontSize: 14)),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ---------------------------------------------------------------------------
  // FILES
  // ---------------------------------------------------------------------------
  Widget _fileAnswer(VisitQuestion q, VisitTaskCubit cubit) {
    final picked = _files[q.questionId] ?? <String>[];
    final hasAny = q.hasFiles || picked.isNotEmpty;

    // View only: no delete, no add, no labels.
    if (_readOnly) {
      if (!q.hasFiles) return _readOnlyText("", icon: Icons.attach_file);
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final f in q.files)
            _thumb(
              url: f.url,
              name: f.name.isNotEmpty ? f.name : _baseName(f.url),
            ),
        ],
      );
    }

    // Editable
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasAny)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // already on the server -> delete calls the API
              for (final f in q.files)
                _thumb(
                  url: f.url,
                  name: f.name.isNotEmpty ? f.name : _baseName(f.url),
                  badge: "Uploaded",
                  badgeColor: _completedColor,
                  busy: _deleting.contains(f.id),
                  onDelete: f.id.isEmpty
                      ? null
                      : () => _deleteServerFile(cubit, q, f),
                ),
              // picked on the phone -> delete is local only
              for (final p in picked)
                _thumb(
                  path: p,
                  name: _baseName(p),
                  badge: "Not saved",
                  badgeColor: _pendingColor,
                  onDelete: () => _removePicked(q, p),
                ),
            ],
          ),
        if (picked.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            "Photos marked \"Not saved\" are uploaded when you tap Save.",
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
        if (hasAny) const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: () => _pickFiles(q),
          icon: const Icon(Icons.add_a_photo_outlined, size: 16),
          label: Text(hasAny ? "Add more photos" : "Add photos",
              style: const TextStyle(fontSize: 12)),
          // ...style stays the same
        ),
        const SizedBox(height: 6),
        Text(
          "Take a photo or choose images (JPG, PNG, HEIC), up to $_maxImageMb MB each.",
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _thumb({
    String? url,
    String? path,
    required String name,
    String? badge,
    Color? badgeColor,
    bool busy = false,
    VoidCallback? onDelete,
  }) {
    const double size = 92;
    final fullUrl = (url == null || url.isEmpty) ? null : _fullUrl(url);
    final hasSource = path != null || fullUrl != null;
    final isImg = hasSource && _isImage(path ?? fullUrl!);

    Widget fileIcon() => Padding(
          padding: const EdgeInsets.fromLTRB(6, 6, 6, 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.insert_drive_file_outlined,
                  size: 24, color: Colors.grey.shade600),
              const SizedBox(height: 4),
              Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
              ),
            ],
          ),
        );

    Widget content;
    if (isImg && path != null) {
      content = Image.file(
        File(path),
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => fileIcon(),
      );
    } else if (isImg && fullUrl != null) {
      content = Image.network(
        fullUrl,
        fit: BoxFit.cover,
        loadingBuilder: (c, child, p) => p == null
            ? child
            : const Center(
                child: SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2))),
        errorBuilder: (c, e, s) => fileIcon(),
      );
    } else {
      content = fileIcon();
    }

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Positioned.fill(
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: (isImg && hasSource && !busy)
                  ? () => _openImage(url: fullUrl, path: path)
                  : null,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                clipBehavior: Clip.antiAlias,
                child: content,
              ),
            ),
          ),
          if (badge != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                  color: (badgeColor ?? Colors.black54).withOpacity(0.9),
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(8)),
                ),
                child: Text(
                  badge,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
            ),
          if (onDelete != null && !busy)
            Positioned(
              top: 0,
              right: 0,
              child: InkWell(
                onTap: onDelete,
                // Larger tap area than the visible red circle.
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.close, size: 15, color: Colors.white),
                  ),
                ),
              ),
            ),
          if (busy)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SAVE BAR (Save + Save & Complete)
  // ---------------------------------------------------------------------------
  Widget _saveBar(VisitTaskCubit cubit, List<VisitQuestion> qs) {
    final busy = _saving || _deleting.isNotEmpty;
    const saveLabel = "Save as pending";

    Widget spinner(Color c) => SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(strokeWidth: 2, color: c),
        );

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed:
                      busy ? null : () => _save(cubit, qs, complete: false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryColor,
                    side: const BorderSide(color: AppColors.primaryColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: (_saving && !_savingComplete)
                      ? spinner(AppColors.primaryColor)
                      : Text(saveLabel,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed:
                      busy ? null : () => _save(cubit, qs, complete: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _completedColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: (_saving && _savingComplete)
                      ? spinner(Colors.white)
                      : const Text("Save & Complete",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SHARED WIDGETS
  // ---------------------------------------------------------------------------
  Widget _card({required Widget child, Color? borderColor}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: borderColor == null ? null : Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            blurRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _labelTag(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("$label: ",
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700)),
          Text(value,
              style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }

  Widget _dateInfo(String label, String value, {bool alignEnd = false}) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
        const SizedBox(height: 2),
        Text(
          value.isEmpty ? "-" : value,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor),
        ),
      ],
    );
  }
}
