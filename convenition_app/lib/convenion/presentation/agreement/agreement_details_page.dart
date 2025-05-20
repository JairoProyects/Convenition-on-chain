import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';

class AgreementDetailsPage extends StatefulWidget {
  final Function(String descripcion, String condiciones, DateTime fecha)
      onDetailsCompleted;
  final String? initialDescripcion;
  final String? initialCondiciones;
  final DateTime? initialFecha;

  const AgreementDetailsPage({
    super.key,
    required this.onDetailsCompleted,
    this.initialDescripcion,
    this.initialCondiciones,
    this.initialFecha,
  });

  @override
  State<AgreementDetailsPage> createState() => _AgreementDetailsPageState();
}

class _AgreementDetailsPageState extends State<AgreementDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descripcionController;
  late TextEditingController _condicionesController;
  DateTime? _fechaVencimiento;
  bool _fechaInvalida = false;

  @override
  void initState() {
    super.initState();
    _descripcionController = TextEditingController(
      text: widget.initialDescripcion ?? '',
    );
    _condicionesController = TextEditingController(
      text: widget.initialCondiciones ?? '',
    );
    _fechaVencimiento = widget.initialFecha;
  }

  void _pickDate() async {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaVencimiento ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme(
              brightness: Theme.of(context).brightness,
              primary: colors.accentBlue,
              onPrimary: colors.textPrimary,
              surface: colors.panelBackground,
              onSurface: colors.textPrimary,
              background: colors.panelBackground,
              onBackground: colors.textPrimary,
              secondary: colors.accentGreen,
              onSecondary: colors.textHighlight,
              error: Colors.red,
              onError: Colors.white,
            ),
            dialogBackgroundColor: colors.modalBackground,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _fechaVencimiento = picked;
        _fechaInvalida = false;
      });
    }
  }

  void _submitDetails() {
    final isValid = _formKey.currentState!.validate();
    final isFechaValid = _fechaVencimiento != null;

    setState(() {
      _fechaInvalida = !isFechaValid;
    });

    if (isValid && isFechaValid) {
      widget.onDetailsCompleted(
        _descripcionController.text,
        _condicionesController.text,
        _fechaVencimiento!,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Detalles del Convenio",
          style: TextStyle(color: colors.textPrimary),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(gradient: colors.backgroundMain),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Theme(
              data: Theme.of(context).copyWith(
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: colors.panelBackground,
                  labelStyle: TextStyle(color: colors.textSecondary),
                  errorStyle: const TextStyle(color: Colors.redAccent),
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
                      decoration: const InputDecoration(
                        labelText: "Descripción del convenio",
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty
                              ? "Este campo es obligatorio"
                              : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _condicionesController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: "Condiciones adicionales",
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty
                              ? "Este campo es obligatorio"
                              : null,
                    ),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _fechaVencimiento != null
                              ? "Fecha seleccionada: ${_fechaVencimiento!.toLocal().toString().split(' ')[0]}"
                              : "Seleccioná la fecha de vencimiento",
                          style: TextStyle(
                            color: _fechaInvalida
                                ? Colors.redAccent
                                : colors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        ElevatedButton(
                          onPressed: _pickDate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.accentBlue,
                            foregroundColor: Colors.black,
                          ),
                          child: const Text("Seleccionar fecha"),
                        ),
                        if (_fechaInvalida)
                          const Padding(
                            padding: EdgeInsets.only(top: 6.0),
                            child: Text(
                              "Debés seleccionar una fecha",
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 13,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submitDetails,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.accentBlue,
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
      ),
    );
  }
}
