import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/map_card_widget.dart';
import '../widgets/task_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterDialog(BuildContext context) {
    final taskProvider = context.read<TaskProvider>();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter Tugas Hari Ini',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    children: ['Semua', 'IN', 'OUT', 'Selesai'].map((filter) {
                      final isSelected = taskProvider.activeFilter == filter;
                      return ChoiceChip(
                        label: Text(filter),
                        selected: isSelected,
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        onSelected: (selected) {
                          taskProvider.setActiveFilter(filter);
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final rackController = TextEditingController(text: 'Rak A-05');
    final nameController = TextEditingController();
    final skuController = TextEditingController(text: 'SKU-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}');
    final qtyController = TextEditingController(text: '50');
    TaskType selectedType = TaskType.inBound;

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Row(
                children: [
                  Icon(Icons.add_task, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text(
                    'Tambah Tugas Baru',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      TextFormField(
                        controller: rackController,
                        decoration: const InputDecoration(
                          labelText: 'Lokasi Rak',
                          hintText: 'Contoh: Rak A-02',
                        ),
                        validator: (v) => v!.trim().isEmpty ? 'Wajib diisi' : null,
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nama Barang',
                          hintText: 'Contoh: Hydraulic Pump',
                        ),
                        validator: (v) => v!.trim().isEmpty ? 'Wajib diisi' : null,
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: skuController,
                              decoration: const InputDecoration(
                                labelText: 'SKU Code',
                              ),
                              validator: (v) => v!.trim().isEmpty ? 'Wajib diisi' : null,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              controller: qtyController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Qty',
                              ),
                              validator: (v) => v!.trim().isEmpty ? 'Wajib diisi' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      Row(
                        children: [
                          const Text(
                            'Tipe Operasi:',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          ChoiceChip(
                            label: const Text('IN'),
                            selected: selectedType == TaskType.inBound,
                            selectedColor: AppColors.inBadge,
                            labelStyle: TextStyle(
                              color: selectedType == TaskType.inBound
                                  ? Colors.white
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                            onSelected: (selected) {
                              setDialogState(() {
                                selectedType = TaskType.inBound;
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: const Text('OUT'),
                            selected: selectedType == TaskType.outBound,
                            selectedColor: AppColors.outBadge,
                            labelStyle: TextStyle(
                              color: selectedType == TaskType.outBound
                                  ? Colors.white
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                            onSelected: (selected) {
                              setDialogState(() {
                                selectedType = TaskType.outBound;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: const Text('Batal', style: TextStyle(color: AppColors.greyDark)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final newTask = TaskModel(
                        id: 'TSK-${DateTime.now().millisecondsSinceEpoch}',
                        rack: rackController.text.trim(),
                        itemName: nameController.text.trim(),
                        sku: skuController.text.trim(),
                        quantity: int.tryParse(qtyController.text.trim()) ?? 1,
                        type: selectedType,
                      );
                      context.read<TaskProvider>().addTask(newTask);
                      Navigator.pop(dialogCtx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tugas baru berhasil ditambahkan!'),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    }
                  },
                  child: const Text('Simpan', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final tasks = taskProvider.filteredTasks;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Stack(
          children: [

            CustomScrollView(
              slivers: [

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                    child: CustomSearchBar(
                      controller: _searchController,
                      placeholder: 'Search',
                      onChanged: (val) {
                        taskProvider.setSearchQuery(val);
                      },
                      onFilterTap: () => _showFilterDialog(context),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                    child: Container(
                      height: 54,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.greyDark,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: Colors.white70, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Shift Pagi: 4 Petugas Aktif • ${taskProvider.pendingTasksCount} Tugas Menunggu',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: MapCardWidget(),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tugas Hari Ini',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (taskProvider.activeFilter != 'Semua')
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.greyLight,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Filter: ${taskProvider.activeFilter}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.greyDark.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: tasks.isEmpty
                          ? Container(
                              height: 120,
                              alignment: Alignment.center,
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.assignment_turned_in_outlined,
                                      color: Colors.white54, size: 36),
                                  SizedBox(height: 8),
                                  Text(
                                    'Tidak ada tugas yang sesuai.',
                                    style: TextStyle(color: Colors.white70, fontSize: 13),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              children: tasks.map((task) {
                                return TaskCardWidget(
                                  task: task,
                                  onToggle: () {
                                    taskProvider.toggleTaskStatus(task.id);
                                  },
                                );
                              }).toList(),
                            ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 80),
                ),
              ],
            ),

            Positioned(
              bottom: 16,
              right: 28,
              child: GestureDetector(
                onTap: () => _showAddTaskDialog(context),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.greyLight,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 32,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
