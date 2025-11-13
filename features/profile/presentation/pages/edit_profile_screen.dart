import 'package:bienestar_integral_app/features/events/presentation/widgets/success_dialog.dart';
import 'package:bienestar_integral_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:bienestar_integral_app/features/profile/presentation/widgets/confirmation_dialog.dart';
import 'package:bienestar_integral_app/features/profile/presentation/widgets/edit_profile_header.dart';
import 'package:bienestar_integral_app/features/profile/presentation/widgets/profile_text_field.dart';
import 'package:bienestar_integral_app/features/register/domain/entities/skill.dart';
import 'package:bienestar_integral_app/features/register/presentation/providers/register_provider.dart';
import 'package:bienestar_integral_app/features/register/presentation/widgets/availability_day_card.dart';
import 'package:bienestar_integral_app/features/register/presentation/widgets/custom_checkbox.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _firstLastNameCtrl = TextEditingController();
  final _secondLastNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  Map<int, bool> _selectedSkills = {};
  final Map<String, bool> _daysSelected = {
    'lunes': false, 'martes': false, 'miércoles': false, 'jueves': false, 'viernes': false, 'sábado': false, 'domingo': false
  };
  final Map<String, TimeOfDay?> _startTimes = {};
  final Map<String, TimeOfDay?> _endTimes = {};
  final List<String> _dayOrder = ['lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider = context.read<ProfileProvider>();
      if (profileProvider.userProfile == null || profileProvider.status == ProfileStatus.initial) {
        profileProvider.fetchProfile().then((_) {
          _populateForm();
        });
      } else {
        _populateForm();
      }
    });
  }

  void _populateForm() {
    if (!mounted) return;
    final profile = context.read<ProfileProvider>().userProfile;
    if (profile == null) return;

    _nameCtrl.text = profile.user.names;
    _firstLastNameCtrl.text = profile.user.firstLastName ?? '';
    _secondLastNameCtrl.text = profile.user.secondLastName ?? '';
    _phoneCtrl.text = profile.user.phoneNumber ?? '';

    final userSkillIds = profile.skills.map((s) => s.id).toSet();
    final allSkills = context.read<RegisterProvider>().skills;
    _selectedSkills = {for (var skill in allSkills) skill.id: userSkillIds.contains(skill.id)};

    _daysSelected.updateAll((key, value) => false);
    _startTimes.clear();
    _endTimes.clear();

    for (var slot in profile.availability) {
      final dayKey = _mapDayToSpanish(slot.dayOfWeek);
      if (_daysSelected.containsKey(dayKey)) {
        _daysSelected[dayKey] = true;
        _startTimes[dayKey] = TimeOfDay(hour: int.parse(slot.startTime.split(':')[0]), minute: int.parse(slot.startTime.split(':')[1]));
        _endTimes[dayKey] = TimeOfDay(hour: int.parse(slot.endTime.split(':')[0]), minute: int.parse(slot.endTime.split(':')[1]));
      }
    }
    setState(() {});
  }

  String _mapDayToSpanish(String day) {
    switch (day.toLowerCase()) {
      case 'monday': return 'lunes';
      case 'tuesday': return 'martes';
      case 'wednesday': return 'miércoles';
      case 'thursday': return 'jueves';
      case 'friday': return 'viernes';
      case 'saturday': return 'sábado';
      case 'sunday': return 'domingo';
      default: return '';
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _firstLastNameCtrl.dispose();
    _secondLastNameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      showDialog(
        context: context,
        builder: (_) => ConfirmationDialog(
          title: 'Guardar cambios',
          message: '¿Deseas guardar los cambios realizados en tu perfil?',
          onConfirm: _performSave,
        ),
      );
    }
  }

  void _performSave() async {
    final profileProvider = context.read<ProfileProvider>();

    final basicInfo = {
      "names": _nameCtrl.text.trim(),
      "firstLastName": _firstLastNameCtrl.text.trim(),
      "phoneNumber": _phoneCtrl.text.trim(),
    };
    final secondLastName = _secondLastNameCtrl.text.trim();
    if (secondLastName.isNotEmpty) {
      basicInfo["secondLastName"] = secondLastName;
    }

    final newSkillIds = _selectedSkills.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();

    final success = await profileProvider.saveChanges(
      basicInfo: basicInfo,
      newSkillIds: newSkillIds,
      daysSelected: _daysSelected,
      startTimes: _startTimes,
      endTimes: _endTimes,
    );

    if (mounted && success) {
      showDialog(
        context: context,
        builder: (_) => SuccessDialog(
          message: '¡Perfil actualizado exitosamente!',
          onClose: () => context.pop(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final allSkills = context.watch<RegisterProvider>().skills;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const HomeAppBar(title: 'Editar Perfil', showBackButton: true),
      body: _buildBody(profileProvider, allSkills, theme),
    );
  }

  Widget _buildBody(ProfileProvider profileProvider, List<Skill> allSkills, ThemeData theme) {
    switch (profileProvider.status) {
      case ProfileStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case ProfileStatus.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(profileProvider.errorMessage ?? 'Ocurrió un error', textAlign: TextAlign.center),
          ),
        );
      case ProfileStatus.initial:
      case ProfileStatus.success:
      case ProfileStatus.updating:
        if (profileProvider.userProfile == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      EditProfileHeader(onCameraPressed: () {}),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProfileTextField(label: 'Nombres', controller: _nameCtrl, hintText: 'Ingresa tus nombres'),
                            const SizedBox(height: 16),
                            ProfileTextField(label: 'Primer apellido', controller: _firstLastNameCtrl, hintText: 'Ingresa tu primer apellido'),
                            const SizedBox(height: 16),
                            ProfileTextField(label: 'Segundo apellido', controller: _secondLastNameCtrl, hintText: 'Opcional', isRequired: false),
                            const SizedBox(height: 16),
                            ProfileTextField(label: 'Teléfono', controller: _phoneCtrl, hintText: 'Ingresa tu teléfono', keyboardType: TextInputType.phone),
                            const SizedBox(height: 32),
                            Text('Habilidades', style: theme.textTheme.titleLarge),
                            const SizedBox(height: 16),
                            if (allSkills.isEmpty) const Center(child: Text('Cargando habilidades...')) else
                              ...allSkills.map((skill) {
                                return CustomCheckbox(
                                  label: skill.name,
                                  value: _selectedSkills[skill.id] ?? false,
                                  onChanged: (bool? value) => setState(() => _selectedSkills[skill.id] = value ?? false),
                                );
                              }).toList(),
                            const SizedBox(height: 32),
                            Text('Disponibilidad', style: theme.textTheme.titleLarge),
                            const SizedBox(height: 16),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _dayOrder.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final day = _dayOrder[index];
                                return AvailabilityDayCard(
                                  dayName: day.substring(0, 1).toUpperCase() + day.substring(1),
                                  dayInitial: day.substring(0, 1).toUpperCase(),
                                  isSelected: _daysSelected[day]!,
                                  startTime: _startTimes[day],
                                  endTime: _endTimes[day],
                                  onDaySelected: (isSelected) => setState(() => _daysSelected[day] = isSelected),
                                  onStartTimeChanged: (time) => setState(() => _startTimes[day] = time),
                                  onEndTimeChanged: (time) => setState(() => _endTimes[day] = time),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (profileProvider.status == ProfileStatus.updating) const LinearProgressIndicator(),
              _buildBottomActionBar(context),
            ],
          ),
        );
    }
  }

  Widget _buildBottomActionBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.shadow.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: Row(
        children: [
          Expanded(child: OutlinedButton(onPressed: () => context.pop(), child: const Text('Cancelar'))),
          const SizedBox(width: 12),
          Expanded(child: ElevatedButton(onPressed: _handleSave, child: const Text('Guardar'))),
        ],
      ),
    );
  }
}