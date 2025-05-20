import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:starknet/starknet.dart';
import '../../domains/convenio_model.dart';
import 'agreement_details_page.dart';
import '../../../shared/util/validators.dart';
import '../../../shared/util/notifications.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../home/custom_app_bar.dart';
import '../../../shared/widgets/breadcrumb_widget.dart';
import '../../services/starknet_service.dart';

class CreateAgreementPage extends StatefulWidget {
  const CreateAgreementPage({super.key});

  @override
  State<CreateAgreementPage> createState() => _CreateAgreementPageState();
}

class _CreateAgreementPageState extends State<CreateAgreementPage> {
  final _formKey = GlobalKey<FormState>();
  final _montoController = TextEditingController();
  final _participantesController = TextEditingController();
  final _searchController = TextEditingController();

  String? _descripcion;
  String? _condiciones;
  DateTime? _fechaVencimiento;
  bool _firmado = false;
  String _estado = 'Idle';
  final List<String> _firmas = [];

  late StarknetService starknetService;

  @override
  void initState() {
    super.initState();
    final account = getAccount(
      accountAddress: Felt.fromHexString(
        "0x07fae9932307e3f44cc3523e1f50979cc89ed7928f41b5a2d4c9cf648100d0d5",
      ),
      privateKey: Felt.fromHexString(
        "0x05757c5161e7313276902aabf5cc0a89fd67e4b8ab4d270818ce2f228aa9f2f8",
      ),
    );
    starknetService = StarknetService(account);
  }

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

  void _submitForm() async {
    if (_formKey.currentState!.validate() &&
        _descripcion != null &&
        _fechaVencimiento != null) {
      final convenio = ConvenioModel(
        id: const Uuid().v4(),
        timestamp: DateTime.now(),
        monto: double.parse(_montoController.text),
        firmado: _firmado,
        participantes: int.parse(_participantesController.text),
        hash: "0x${DateTime.now().millisecondsSinceEpoch.toRadixString(16)}",
        descripcion: _descripcion!,
        condiciones: _condiciones ?? '',
        vencimiento: _fechaVencimiento!,
        firmas: _firmas,
        estado: _estado,
      );

      showConfirmationModal(
        context,
        message: "Enviando convenio a la blockchain...",
      );

      try {
        final txHash = await starknetService.createConvenio(
          descripcion: convenio.descripcion,
          condiciones: convenio.condiciones,
          vencimiento: convenio.vencimiento,
        );

        Navigator.pop(context);

        showConfirmationModal(
          context,
          message: "Convenio creado exitosamente.\nTx Hash: ${txHash.toHexString()}",
        );

        _formKey.currentState!.reset();
        _montoController.clear();
        _participantesController.clear();
        setState(() {
          _descripcion = null;
          _condiciones = null;
          _fechaVencimiento = null;
          _firmado = false;
          _estado = 'Idle';
          _firmas.clear();
        });
      } catch (e) {
        Navigator.pop(context);
        showConfirmationModal(
          context,
          message: "Error al crear convenio:\n${e.toString()}",
          buttonText: "Cerrar",
        );
        print(e.toString());
      }
    } else {
      showConfirmationModal(
        context,
        message: "Faltan los detalles del convenio",
        buttonText: "Entendido",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: CustomAppBar(controller: _searchController),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: colors.backgroundMain),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                    onTap: (index) {
                      if (index == 0) {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      } else if (index == 1) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _montoController,
                    decoration: const InputDecoration(
                      labelText: "Monto acordado (₡)",
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        validatePositiveNumber(value, fieldName: "Monto"),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _participantesController,
                    decoration: const InputDecoration(
                      labelText: "Número de participantes",
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        validateInteger(value, fieldName: "Participantes"),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _abrirDetalles,
                    icon: const Icon(Icons.description),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.accentBlue,
                      foregroundColor: Colors.black,
                    ),
                    label: Text(
                      _descripcion != null
                          ? "Detalles Completados"
                          : "Agregar Detalles del Convenio",
                    ),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text("¿Convenio ya firmado?"),
                    value: _firmado,
                    onChanged: (value) {
                      setState(() {
                        _firmado = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Estado del convenio",
                    ),
                    value: _estado,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _estado = value;
                        });
                      }
                    },
                    items: const [
                      DropdownMenuItem(value: 'Idle', child: Text('Idle')),
                      DropdownMenuItem(
                          value: 'SignedByOne', child: Text('Firmado por uno')),
                      DropdownMenuItem(
                          value: 'Completed', child: Text('Completado')),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.accentBlue,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text("Crear Convenio"),
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
