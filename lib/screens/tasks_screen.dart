import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final List<Map<String, dynamic>> tasks = [
    {'project': 'Trồng Rau Muống', 'task': 'Tưới rau muống', 'done': false, 'icon': Icons.eco, 'iconColor': AppColors.primaryGreen},
    {'project': 'Lúa Hè Thu', 'task': 'Bón phân lúa', 'done': false, 'icon': Icons.eco, 'iconColor': AppColors.primaryGreen},
    {'project': 'Trồng Rau Muống', 'task': 'Thu hoạch lứa đầu', 'done': true, 'icon': Icons.description_outlined, 'iconColor': AppColors.textSecondary},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Công việc hôm nay',
            style: GoogleFonts.beVietnamPro(
                fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primaryGreen)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        separatorBuilder: (_, i) => const SizedBox(height: 14),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          final isDone = task['done'] as bool;

          return Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border(
                left: BorderSide(
                  color: AppColors.primaryGreen,
                  width: 4,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Checkbox
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        tasks[index]['done'] = !isDone;
                      });
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDone ? AppColors.primaryGreen : Colors.transparent,
                        border: Border.all(
                          color: isDone ? AppColors.primaryGreen : AppColors.textLight,
                          width: 2,
                        ),
                      ),
                      child: isDone
                          ? const Icon(Icons.check, color: AppColors.white, size: 20)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(task['icon'] as IconData, size: 14,
                                color: isDone ? AppColors.textLight : task['iconColor'] as Color),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Dự án: ${task['project']}',
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 12,
                                  color: isDone ? AppColors.textLight : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          task['task'] as String,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: isDone ? AppColors.textLight : AppColors.textPrimary,
                            decoration: isDone ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
