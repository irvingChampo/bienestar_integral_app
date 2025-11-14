// features/profile/presentation/pages/edit_profile_screen.dart (CÓDIGO MODIFICADO)

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bienestar_integral_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:bienestar_integral_app/features/profile/presentation/widgets/confirmation_dialog.dart';
import 'package:bienestar_integral_app/features/profile/presentation/widgets/edit_profile_header.dart';
import 'package:bienestar_integral_app/features/profile/presentation/widgets/profile_text_field.dart';
import 'package:bienestar_integral_app/features/register/domain/entities/skill.dart';
import 'package:bienestar_integral_app/features/register/presentation/providers/register_provider.dart';
import 'package:bienestar_integral_app/features/register/presentation/widgets/availability_day_card.dart';
import 'package:bienestar_integral_app/features/register/presentation/widgets/custom_checkbox.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/home_app_bar.dart';
import 'package:bienestar_integral_app/shared/validators/validators.dart';
import 'package:flutter/foundation.dart'; // --- CAMBIO: Se importa para usar mapEquals ---
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  // --- CAMBIO: Variables para guardar el estado inicial y detectar cambios ---
  String _initialName = '';
  String _initialFirstLastName = '';
  String _initialSecondLastName = '';
  String _initialPhone = '';
  Map<int, bool> _initialSelectedSkills = {};
  Map<String, bool> _initialDaysSelected = {};
  Map<String, TimeOfDay?> _initialStartTimes = {};
  Map<String, TimeOfDay?> _initialEndTimes = {};


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider = context.read<ProfileProvider>();
      final registerProvider = context.read<RegisterProvider>();

      if (registerProvider.skills.isEmpty) {
        registerProvider.loadInitialData().then((_) {
          if (profileProvider.userProfile == null || profileProvider.status == ProfileStatus.initial) {
            profileProvider.fetchProfile().then((_) => _populateForm());
          } else {
            _populateForm();
          }
        });
      } else {
        if (profileProvider.userProfile == null || profileProvider.status == ProfileStatus.initial) {
          profileProvider.fetchProfile().then((_) => _populateForm());
        } else {
          _populateForm();
        }
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

    // --- CAMBIO: Se guarda la "instantánea" inicial de los datos ---
    _saveInitialState();

    setState(() {});
  }

  // --- CAMBIO: Nuevo método para guardar el estado inicial ---
  void _saveInitialState() {
    _initialName = _nameCtrl.text;
    _initialFirstLastName = _firstLastNameCtrl.text;
    _initialSecondLastName = _secondLastNameCtrl.text;
    _initialPhone = _phoneCtrl.text;
    _initialSelectedSkills = Map.from(_selectedSkills);
    _initialDaysSelected = Map.from(_daysSelected);
    _initialStartTimes = Map.from(_startTimes);
    _initialEndTimes = Map.from(_endTimes);
  }

  // --- CAMBIO: Nuevo método para comprobar si hay cambios ---
  bool _hasChanges() {
    if (_initialName != _nameCtrl.text) return true;
    if (_initialFirstLastName != _firstLastNameCtrl.text) return true;
    if (_initialSecondLastName != _secondLastNameCtrl.text) return true;
    if (_initialPhone != _phoneCtrl.text) return true;
    if (!mapEquals(_initialSelectedSkills, _selectedSkills)) return true;
    if (!mapEquals(_initialDaysSelected, _daysSelected)) return true;
    if (!mapEquals(_initialStartTimes, _startTimes)) return true;
    if (!mapEquals(_initialEndTimes, _endTimes)) return true;
    return false;
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
    FocusManager.instance.primaryFocus?.unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      _showErrorSnackBar('Por favor, corrige los errores en el formulario.');
      return;
    }

    final businessRuleError = _validateBusinessRules();
    if (businessRuleError != null) {
      _showErrorSnackBar(businessRuleError);
      return;
    }

    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.bottomSlide,
      title: 'Guardar cambios',
      desc: '¿Deseas guardar los cambios realizados en tu perfil?',
      btnCancelOnPress: () {},
      btnOkText: 'Guardar',
      btnOkOnPress: _performSave,
    ).show();
  }

  // --- CAMBIO: Nueva función para manejar el botón de cancelar ---
  void _handleCancel() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_hasChanges()) {
      showDialog(
        context: context,
        builder: (_) => ConfirmationDialog(
          title: 'Descartar cambios',
          message: '¿Estás seguro de que deseas salir? Perderás todos los cambios no guardados.',
          confirmText: 'Salir',
          onConfirm: () {
            context.pop();
          },
        ),
      );
    } else {
      // Si no hay cambios, simplemente regresa.
      context.pop();
    }
  }

  String? _validateBusinessRules() {
    if (!_selectedSkills.containsValue(true)) {
      return 'Debes seleccionar al menos una habilidad.';
    }

    for (final day in _dayOrder) {
      if (_daysSelected[day] ?? false) {
        final start = _startTimes[day];
        final end = _endTimes[day];
        if (start == null || end == null) {
          return 'Debes seleccionar hora de inicio y fin para ${day.capitalize()}.';
        }

        final startTimeInMinutes = start.hour * 60 + start.minute;
        final endTimeInMinutes = end.hour * 60 + end.minute;

        if (startTimeInMinutes >= endTimeInMinutes) {
          return 'La hora de inicio debe ser anterior a la de fin para ${day.capitalize()}.';
        }
      }
    }
    return null;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Theme.of(context).colorScheme.error,
    ));
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
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: '¡Actualizado!',
        desc: '¡Perfil actualizado exitosamente!',
        btnOkOnPress: () {},
      ).show().then((_) {
        if (context.canPop()) {
          context.pop();
        }
      });
    } else if (mounted) {
      _showErrorSnackBar(profileProvider.errorMessage ?? "No se pudieron guardar los cambios.");
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
            child: Text(profileProvider.errorMessage ?? 'Ocurrió un error al cargar el perfil', textAlign: TextAlign.center),
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
                            ProfileTextField(
                              label: 'Nombres',
                              controller: _nameCtrl,
                              hintText: 'Ingresa tus nombres',
                              validator: (value) => AppValidators.nameValidator(value, 'nombre'),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                            ),
                            const SizedBox(height: 16),
                            ProfileTextField(
                              label: 'Primer apellido',
                              controller: _firstLastNameCtrl,
                              hintText: 'Ingresa tu primer apellido',
                              validator: (value) => AppValidators.nameValidator(value, 'primer apellido'),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                            ),
                            const SizedBox(height: 16),
                            ProfileTextField(
                              label: 'Segundo apellido (Opcional)',
                              controller: _secondLastNameCtrl,
                              hintText: 'Opcional',
                              validator: (value) {
                                if (value != null && value.isNotEmpty) {
                                  return AppValidators.nameValidator(value, 'segundo apellido');
                                }
                                return null;
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                            ),
                            const SizedBox(height: 16),
                            ProfileTextField(
                              label: 'Teléfono',
                              controller: _phoneCtrl,
                              hintText: 'Ingresa tu teléfono (10 dígitos)',
                              keyboardType: TextInputType.phone,
                              validator: AppValidators.phoneValidator,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                            ),
                            const SizedBox(height: 32),
                            Text('Habilidades', style: theme.textTheme.titleLarge),
                            const SizedBox(height: 4),
                            Text('Selecciona al menos una.', style: theme.textTheme.bodySmall),
                            const SizedBox(height: 12),
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
                                  dayName: day.capitalize(),
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
          // --- CAMBIO: Se llama a _handleCancel en lugar de context.pop() directamente ---
          Expanded(child: OutlinedButton(onPressed: _handleCancel, child: const Text('Cancelar'))),
          const SizedBox(width: 12),
          Expanded(child: ElevatedButton(onPressed: _handleSave, child: const Text('Guardar'))),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}