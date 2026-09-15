import 'package:ekidzee/Responsive.dart';
import 'package:ekidzee/constants.dart';
import 'package:ekidzee/pages/k12/data/models/get_homework_model.dart';
import 'package:ekidzee/pages/pentemind/module/homework/widget/homework_attachment.dart';
import 'package:ekidzee/pages/pentemind/module/homework/widget/homework_progress.dart';
import 'package:ekidzee/pages/pentemind/module/homework/widget/homework_upload_selection.dart';
import 'package:flutter/material.dart';

class HomeworkCard extends StatelessWidget {
  final String subject;
  final String chapter;
  final String message;
  final String assignDate;
  final String submissionDate;
  final String? fileUrl;
  final String status;
  final VoidCallback? onAttachmentTap;
  final VoidCallback? onHomeoworkTap;
  final int? total;
  final int? completed;
  final String? userType;
  final VoidCallback? onUploadTap;
  final Homework homework;

  const HomeworkCard(
      {super.key,
      required this.subject,
      required this.chapter,
      required this.message,
      required this.assignDate,
      required this.submissionDate,
      required this.homework,
      this.onHomeoworkTap,
      this.fileUrl,
      this.status = "Published",
      this.onAttachmentTap,
      this.total,
      this.completed,
      this.userType,
      this.onUploadTap});

  bool isTeach() {
    return userType?.toLowerCase() == "teach";
  }

  bool isStud() {
    return userType?.toLowerCase() == "p";
  }

  bool isAnswerSubmitted() {
    return homework.is_student_homework_uploaded == 1;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: IntrinsicHeight(
          // ✅ KEY FIX
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// LEFT ACCENT STRIP (NO INFINITE HEIGHT)
              Container(
                width: 5,
                decoration: const BoxDecoration(
                  color: Color(0xFF6A1B9A),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),

              /// CONTENT
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chapter,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          isStud() && status.toLowerCase() == 'corrected'
                              ? Icon(
                                  Icons.check_circle,
                                  color: kPrimaryLightColor,
                                )
                              : Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isStud()
                                        ? status == 'Pending' ||
                                                status.toLowerCase() == 'redo'
                                            ? Colors.red.shade100
                                            : Colors.green.shade100
                                        : Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    status,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: isStud()
                                          ? status == 'Pending' ||
                                                  status.toLowerCase() == 'redo'
                                              ? Colors.red
                                              : Colors.green
                                          : Colors.green,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subject,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Responsive.isMobile(context)
                          ? Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today,
                                        size: 16, color: Color(0xFF6A1B9A)),
                                    const SizedBox(width: 6),
                                    Text("Assign: $assignDate",
                                        style: const TextStyle(fontSize: 13)),
                                  ],
                                ),
                                const SizedBox(width: 18),
                                Row(
                                  children: [
                                    const Icon(Icons.schedule,
                                        size: 16, color: Color(0xFF6A1B9A)),
                                    const SizedBox(width: 6),
                                    Text("Due: $submissionDate",
                                        style: const TextStyle(fontSize: 13)),
                                  ],
                                )
                              ],
                            )
                          : Row(
                              children: [
                                const Icon(Icons.calendar_today,
                                    size: 16, color: Color(0xFF6A1B9A)),
                                const SizedBox(width: 6),
                                Text("Assign: $assignDate",
                                    style: const TextStyle(fontSize: 13)),
                                const SizedBox(width: 18),
                                const Icon(Icons.schedule,
                                    size: 16, color: Color(0xFF6A1B9A)),
                                const SizedBox(width: 6),
                                Text("Due: $submissionDate",
                                    style: const TextStyle(fontSize: 13)),
                              ],
                            ),
                      const SizedBox(height: 12),
                      if (fileUrl != null && fileUrl!.isNotEmpty) ...[
                        HomeworkAttachment(
                          fileUrl: fileUrl!,
                          onTap: onAttachmentTap ?? () {},
                          title: "Homework Attachment",
                        )
                      ],
                      if (!isStud()) ...[
                        const SizedBox(height: 12),
                        HomeworkProgress(
                            completed: completed ?? 0, total: total ?? 0),
                      ],
                      const SizedBox(height: 12),
                      Text(
                        'Message - $message',
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey.shade800),
                      ),
                      if (isStud()) ...[
                        const SizedBox(height: 12),
                        if (!isAnswerSubmitted()) ...[
                          /* if (homework.homework_attempt != null &&
                              homework.homework_attempt != 0) ...[
                            Text(
                                'Homework Attempt : ${homework.homework_attempt}'),
                            SizedBox(
                              height: 5,
                            ),
                          ], */
                          /*  if (homework.statusCode?.toLowerCase() == 'w') ...[
                            if (homework.upload_url != null &&
                                homework.upload_url!.isNotEmpty) ...[
                              HomeworkAttachment(
                                  fileUrl: homework.upload_url!,
                                  title: 'Wrong Homework Uploaded',
                                  onTap: onHomeoworkTap ?? () {}),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ], */
                          HomeworkUploadSection(
                            onUploadTap: onUploadTap,
                            isSubmitted: false,
                          ),
                        ] else ...[
                          /* if (homework.upload_url != null &&
                              homework.upload_url!.isNotEmpty) ...[
                            HomeworkAttachment(
                                fileUrl: homework.upload_url!,
                                title: 'Homework Uploaded',
                                onTap: onHomeoworkTap ?? () {})
                          ], */
                        ],
                        if (status.toLowerCase() != 'submitted' &&
                            (homework.remarks?.isNotEmpty ?? false)) ...[
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Teach Remark - ${homework.remarks ?? ''}',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey.shade800),
                          ),
                        ]
                      ]
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
