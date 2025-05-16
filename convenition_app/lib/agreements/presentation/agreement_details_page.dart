import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';

class AgreementDetailsPage extends StatefulWidget {
  final Function(String descripcion, String condiciones, DateTime fecha) onDetailsCompleted;
  final String? initialDescripcion;
  final String? initialCondiciones;
  final DateTime? initialFecha;

  const AgreementDetailsPage({
    Key? key,
    required this.onDetailsCompleted,
    this.initialDescripcion,
    this.initialCondiciones,
    this.initialFecha,
  }) : super(key: key);

  @override
  State<AgreementDetailsPage> createState() => _AgreementDetailsPageState();
}

class _AgreementDetailsPageState extends State<AgreementDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descripcionController;
  late TextEditingController _condicionesController;
  DateTime? _fechaVencimiento;

  @override
  void initState() {
    super.initState();
    _descripcionController = TextEditingController(text: widget.initialDescripcion ?? '');
    _condicionesController = TextEditingController(text: widget.initialCondiciones ?? '');
    _fechaVencimiento = widget.initialFecha;
  }

  void _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaVencimiento ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.accentBlue,
              onPrimary: AppColors.textPrimary,
              surface: AppColors.panelBackground,
              onSurface: AppColors.textPrimary,
            ),
            dialogBackgroundColor: AppColors.modalBackground,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _fechaVencimiento = picked;
      });
    }
  }

  void _submitDetails() {
    if (_formKey.currentState!.validate() && _fechaVencimiento != null) {
      widget.onDetailsCompleted(
        _descripcionController.text,
        _condicionesController.text,
        _fechaVencimiento!,
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor completá todos los campos.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Detalles del Convenio",
          style: TextStyle(color: AppColors.textPrimary),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundMain,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Theme(
            data: ThemeData.dark().copyWith(
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: AppColors.panelBackground,
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _descripcionController,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: "Descripción del convenio"),
                    validator: (value) => value == null || value.isEmpty ? "Campo obligatorio" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _condicionesController,
                    maxLines: 4,
                    decoration: const InputDecoration(labelText: "Condiciones adicionales"),
                    validator: (value) => value == null || value.isEmpty ? "Campo obligatorio" : null,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _fechaVencimiento != null
                        ? "Fecha seleccionada: ${_fechaVencimiento!.toLocal().toString().split(' ')[0]}"
                        : "Seleccioná la fecha de vencimiento",
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 6),
                  ElevatedButton(
                    onPressed: _pickDate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentBlue,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text("Seleccionar fecha"),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _submitDetails,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentBlue,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text("Guardar detalles"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
