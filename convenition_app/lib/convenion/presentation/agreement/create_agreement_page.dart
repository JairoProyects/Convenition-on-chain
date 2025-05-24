import 'package:flutter/material.dart';
import '../../../shared/util/validators.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/breadcrumb_widget.dart';
import 'create_select_user_page.dart';
import '../../domains/convenio_model.dart'; // Aquí está AgreementDraft
import '../../domains/user_model.dart';

class CreateAgreementPage extends StatefulWidget {

  const CreateAgreementPage({super.key});

  @override
  State<CreateAgreementPage> createState() => _CreateAgreementPageState();
}

class _CreateAgreementPageState extends State<CreateAgreementPage> {
  final _formKey = GlobalKey<FormState>();
  final _montoController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _condicionesController = TextEditingController();

  DateTime? _fechaVencimiento;
  String? _monedaSeleccionada;
  bool _fechaInvalida = false;

  final List<String> _opcionesMoneda = ['₡', '\$', 'Ξ', '₿', '€'];

  @override
  void dispose() {
    _montoController.dispose();
    _descripcionController.dispose();
    _condicionesController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaVencimiento ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _fechaVencimiento = picked;
        _fechaInvalida = false;
      });
    }
  }

  void _goToNextStep() {
    final isFormValid = _formKey.currentState?.validate() ?? false;
    final hasDate = _fechaVencimiento != null;
    setState(() => _fechaInvalida = !hasDate);

    if (!isFormValid || !hasDate) return;

    // Construimos el draft con party2 vacío por ahora
    final draft = AgreementDraft(
      monto: double.parse(_montoController.text.trim()),
      moneda: _monedaSeleccionada!,
      descripcion: _descripcionController.text.trim(),
      condiciones: _condicionesController.text.trim(),
      vencimiento: _fechaVencimiento!,
      party1: 'CURRENT_USER_WALLET_ADDRESS', // define tu wallet actual aquí
      party2: '',
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateSelectUserPage(draft: draft),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).brightness == Brightness.dark
            ? AppColors.dark
            : AppColors.light;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.panelBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: colors.textPrimary,
              size: 16,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Crear Convenio',
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(gradient: colors.backgroundMain),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: colors.panelBackground,
                labelStyle: TextStyle(color: colors.textSecondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  BreadcrumbWidget(
                    items: ['Inicio', 'Convenios', 'Crear'],
                    colors: colors,
                    onTap: (idx) {
                      if (idx == 0) {
                        Navigator.popUntil(context, (r) => r.isFirst);
                      } else if (idx == 1) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _montoController,
                    decoration: const InputDecoration(
                      labelText: "Monto acordado",
                    ),
                    keyboardType: TextInputType.number,
                    validator:
                        (v) => validatePositiveNumber(v, fieldName: "Monto"),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Tipo de moneda",
                    ),
                    value: _monedaSeleccionada,
                    onChanged: (v) => setState(() => _monedaSeleccionada = v),
                    items:
                        _opcionesMoneda
                            .map(
                              (m) => DropdownMenuItem(value: m, child: Text(m)),
                            )
                            .toList(),
                    validator:
                        (v) => v == null ? "Seleccioná una moneda" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descripcionController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: "Descripción del convenio",
                    ),
                    validator:
                        (v) =>
                            (v == null || v.isEmpty)
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
                    validator:
                        (v) =>
                            (v == null || v.isEmpty)
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
                          color:
                              _fechaInvalida
                                  ? Colors.redAccent
                                  : colors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      ElevatedButton(
                        onPressed: _pickDate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.panelBackground,
                          foregroundColor: colors.accentBlue,
                        ),
                        child: const Text("Seleccionar fecha"),
                      ),
                      if (_fechaInvalida)
                        const Padding(
                          padding: EdgeInsets.only(top: 6),
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
                    onPressed: _goToNextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.panelBackground,
                      foregroundColor: colors.accentBlue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text("Siguiente"),
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
