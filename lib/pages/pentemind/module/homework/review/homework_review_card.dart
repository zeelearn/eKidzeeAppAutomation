import 'package:ekidzee/pages/k12/data/models/get_homework_student_model.dart';
import 'package:flutter/material.dart';

class HomeworkScreenCard extends StatefulWidget {
  final Data submission;
  final VoidCallback onChanged;

  const HomeworkScreenCard({
    super.key,
    required this.submission,
    required this.onChanged,
  });

  @override
  State<HomeworkScreenCard> createState() => _HomeworkScreenCardState();
}

class _HomeworkScreenCardState extends State<HomeworkScreenCard> {
  bool isHovered = false;

  bool homeworkNotUploaded() =>
      widget.submission.uploadUrl == null ||
      widget.submission.uploadUrl!.isEmpty;

  bool homeworkNotSubmitted() =>
      (widget.submission.is_teacher_homework_checked == 1) ||
      widget.submission.uploadUrl == null ||
      widget.submission.uploadUrl!.isEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: Color.alphaBlend(
            Colors.white,
            colorScheme.surface,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: widget.submission.isChecked ?? false
                ? (widget.submission.isCorrect ?? false
                    ? colorScheme.primary.withOpacity(0.35)
                    : colorScheme.error.withOpacity(0.35))
                : colorScheme.outline.withOpacity(0.25),
            width: 1,
          ),
          boxShadow: [
            if (isHovered)
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
          ],
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(18),
          child: homeworkNotUploaded()
              ? Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.submission.studentName ?? '-',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Pending',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                    )
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(colorScheme),
                    const SizedBox(height: 16),
                    _statusSelector(),
                    const SizedBox(height: 12),
                    _remarkField(),
                  ],
                ),
        ),
      ),
    );
  }

  // ---------------- HEADER ----------------
  Widget _header(ColorScheme colorScheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: widget.submission.isChecked,
          // activeColor: homeworkNotSubmitted() ? Colors.grey : null,
          fillColor: homeworkNotSubmitted()
              ? WidgetStateColor.resolveWith(
                  (states) => Colors.grey,
                )
              : null,
          onChanged: homeworkNotSubmitted()
              ? null
              : (v) {
                  setState(() => widget.submission.isChecked = v ?? false);
                  widget.onChanged();
                },
        ),

        // Student name + status
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.submission.studentName ?? '-',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (widget.submission.isCorrect != null &&
                  (widget.submission.isChecked ?? false))
                Text(
                  widget.submission.isCorrect ?? false
                      ? "Marked Correct"
                      : "ReDo",
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: widget.submission.isCorrect ?? false
                            ? Colors.green
                            : Colors.red,
                      ),
                ),
            ],
          ),
        ),

        // Attachment View
        /*  FilledButton.tonal(
          onPressed: () {
            widget.submission.uploadUrl != null &&
                    widget.submission.uploadUrl!.isNotEmpty
                ? octaveUtil.Utils.onFileTapKidzee(context, 'Attachment',
                    widget.submission.uploadUrl!, '', true)
                : null;
          },
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 22,
                width: 22,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Image.asset(
                  getAttachmentIcon(widget.submission.uploadUrl ?? ''),
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 8),
              const Text("View"),
            ],
          ),
        ), */
      ],
    );
  }

  // ---------------- STATUS ----------------
  Widget _statusSelector() {
    final selected = widget.submission.isCorrect;

    return SegmentedButton<bool>(
      segments: [
        ButtonSegment(
          value: true,
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: selected == true ? Colors.green : Colors.grey,
              ),
              const SizedBox(width: 6),
              Text(
                "Correct",
                style: TextStyle(
                  color: selected == true ? Colors.green : null,
                ),
              ),
            ],
          ),
        ),
        ButtonSegment(
          value: false,
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.highlight_off,
                color: selected == false ? Colors.red : Colors.grey,
              ),
              const SizedBox(width: 6),
              Text(
                "ReDo",
                style: TextStyle(
                  color: selected == false ? Colors.red : null,
                ),
              ),
            ],
          ),
        ),
      ],
      selected: selected == null ? {} : {selected},
      emptySelectionAllowed: true,
      showSelectedIcon: false,
      onSelectionChanged: homeworkNotSubmitted()
          ? null
          : (value) {
              setState(() {
                widget.submission
                  ..isChecked = true
                  ..isCorrect = value.first;
              });
              widget.onChanged();
            },
    );
  }

  // ---------------- REMARK ----------------
  Widget _remarkField() {
    // if (!widget.submission.isChecked) return const SizedBox();

    return homeworkNotSubmitted()
        ? widget.submission.remarks == null ||
                widget.submission.remarks!.isEmpty
            ? SizedBox.shrink()
            : Text(
                widget.submission.remarks ?? '',
                style: Theme.of(context).textTheme.titleMedium,
              )
        : AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextField(
                minLines: 1,
                maxLines: 3,
                enabled: !homeworkNotSubmitted(),
                maxLength: 50,
                decoration: InputDecoration(
                  labelText: "Remark (optional)",
                  filled: true,
                  fillColor:
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onChanged: (v) => widget.submission.remark = v,
              ),
            ),
          );
  }
}
