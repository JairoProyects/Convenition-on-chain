import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../domains/convenio_model.dart';
import 'agreement_details_page.dart';
import '../../shared/util/validators.dart';
import '../../shared/util/notifications.dart';

class CreateAgreementPage extends StatefulWidget {
  const CreateAgreementPage({Key? key}) : super(key: key);

  @override
  State<CreateAgreementPage> createState() => _CreateAgreementPageState();
}

class _CreateAgreementPageState extends State<CreateAgreementPage> {
  final _formKey = GlobalKey<FormState>();
  final _montoController = TextEditingController();
  final _participantesController = TextEditingController();

  String? _descripcion;
  String? _condiciones;
  DateTime? _fechaVencimiento;

  void _abrirDetalles() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AgreementDetailsPage(
          initialDescripcion: _descripcion,
          initialCondiciones: _condiciones,
          initialFecha: _fechaVencimiento,
          onDetailsCompleted: (descripcion, condiciones, fecha) {
            setState(() {
              _descripcion = descripcion;
              _condiciones = condiciones;
              _fechaVencimiento = fecha;
            });
          },
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _descripcion != null && _fechaVencimiento != null) {
      final convenio = Convenio(
        id: const Uuid().v4(),
        timestamp: DateTime.now(),
        monto: double.parse(_montoController.text),
        firmado: false,
        participantes: int.parse(_participantesController.text),
        hash: "0x${DateTime.now().millisecondsSinceEpoch.toRadixString(16)}",
        descripcion: _descripcion!,
        condiciones: _condiciones ?? '',
        vencimiento: _fechaVencimiento!,
      );

      // Aquí iría la futura llamada a starknet_service.createAgreement(convenio);

      showToast("Convenio listo para enviarse a la blockchain", bgColor: Colors.green);

      _formKey.currentState!.reset();
      _montoController.clear();
      _participantesController.clear();
      setState(() {
        _descripcion = null;
        _condiciones = null;
        _fechaVencimiento = null;
      });
    } else {
      showToast("Faltan los detalles del convenio", bgColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nuevo Convenio")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _montoController,
                decoration: const InputDecoration(labelText: "Monto acordado (₡)"),
                keyboardType: TextInputType.number,
                validator: (value) => validatePositiveNumber(value, fieldName: "Monto"),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _participantesController,
                decoration: const InputDecoration(labelText: "Número de participantes"),
                keyboardType: TextInputType.number,
                validator: (value) => validateInteger(value, fieldName: "Participantes"),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _abrirDetalles,
                icon: const Icon(Icons.description),
                label: Text(
                  _descripcion != null
                      ? "Detalles Completados"
                      : "Agregar Detalles del Convenio",
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text("Crear Convenio"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
