import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inri_driver/blocs/blocs.dart';
import 'package:inri_driver/constants/constants.dart';
import 'package:inri_driver/utils/form_validator.dart';
import 'package:inri_driver/widgets/forms/form_step_one.dart';
import 'package:inri_driver/widgets/forms/form_step_three.dart';
import 'package:inri_driver/widgets/forms/form_step_two.dart';

class BuildSteeperFormRegistration extends StatefulWidget {
  const BuildSteeperFormRegistration({
    super.key,
  });

  @override
  State<BuildSteeperFormRegistration> createState() =>
      _BuildSteeperFormRegistrationState();
}

class _BuildSteeperFormRegistrationState
    extends State<BuildSteeperFormRegistration> {
  AuthBloc? authBloc;
  int _currentStep = 0;

  final Map<int, GlobalKey<FormState>> formKeys = {
    0: GlobalKey<FormState>(),
    1: GlobalKey<FormState>(),
    2: GlobalKey<FormState>(),
  };

  bool _validarStepActual() {
    return ValidateStep().validateStep(_currentStep, formKeys);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ImagesBloc, ImagesState>(
      listenWhen: (previous, current) =>
        previous.isImagePermissionGranted != current.isImagePermissionGranted,
      listener: (context, state) {
        // Solo mostramos el SnackBar si NO se concedió el permiso
      if (!state.isImagePermissionGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Debes habilitar el permiso de imágenes para continuar.'),
          ),
        );
      }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height * 0.9,
              child: Theme(
                data: Theme.of(context).copyWith(
                    canvasColor: Colors.transparent,
                    colorScheme: Theme.of(context).colorScheme.copyWith(
                        primary: Colors.transparent,
                        onPrimary: Colors.transparent)),
                child: Stepper(
                  key: ValueKey(_currentStep),
                  type: StepperType.horizontal,
                  elevation: 0,
                  currentStep: _currentStep,
                  onStepContinue: () async {
                    if (!_validarStepActual()) return;

                    // 🔥 Pedir permisos justo antes del último formulario
                    if (_currentStep == 1) {
                      // Antes de FormStepThree
                      final imagesBloc = context.read<ImagesBloc>();
                      // Chequea el estado actual
                      final granted = imagesBloc.state.isImagePermissionGranted;

                      if (!granted) {
                        await imagesBloc.requestImagePermission();

                        await Future.delayed(const Duration(milliseconds: 200));
                       
                        if (!imagesBloc.state.isImagePermissionGranted) return;
                      }
                    }

                    if (_currentStep < 2) {
                      setState(() {
                        _currentStep++;
                      });
                    } else {
                      if(!context.mounted) return;
                      FocusScope.of(context).unfocus();
                      await Future.delayed(const Duration(milliseconds: 300));
                      if (!context.mounted) return;

                      final controller =
                          context.read<AuthBloc>().registerUserController;
                      controller.agregarNuevoUsuario();

                      // Emitís el evento de registro
                      context.read<AuthBloc>().add(RegisterUserEvent());
                    }
                  },
                  onStepCancel: () {
                    if (_currentStep > 0) {
                      setState(() {
                        _currentStep--;
                      });
                    }
                  },
                  controlsBuilder: (context, details) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [



                            BlocBuilder<AuthBloc,AuthState>(
                              builder: (context, state) {
                                final isLoading = state is UserRegisteringState;

                              
                              return ElevatedButton(
                                onPressed: details.onStepContinue,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: isLoading ?
                                 const CircularProgressIndicator(color: Colors.white)
                                 : Text(
                                  _currentStep == 2 ? 'Registrarme' : 'Siguiente',
                                ),
                              );
                             }
                             ),
                            const SizedBox(width: 8),
                            if (_currentStep > 0)
                              OutlinedButton(
                                onPressed: details.onStepCancel,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(color: Colors.red),
                                ),
                                child: const Text('Atrás'),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (_currentStep == 0) // Solo mostrar en el primer paso
                          Center(
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const Text(
                                  '¿Tienes Cuenta?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Color.fromARGB(255, 221, 203, 252)),
                                ),
                                const SizedBox(width: 10),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(
                                          context, 'login');
                                    },
                                    child: Text(
                                      'Ingresa Aqui',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppConstants.yellow),
                                    ))
                              ],
                            ),
                          ),
                      ],
                    );
                  },
                  steps: [
                    Step(
                      title: const Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          Text("Mis datos",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
                      content: Column(
                        children: [
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              return FormStepOne(
                                registerUserController: context
                                    .read<AuthBloc>()
                                    .registerUserController,
                                formKey: formKeys[0]!,
                              );
                            },
                          ),
                        ],
                      ),
                      isActive: true,
                      state: StepState.indexed,
                    ),
                    Step(
                      title: const Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          Text("Vehiculo",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
                      content: Column(
                        children: [
                          FormStepTwo(
                            registerUserController:
                                context.read<AuthBloc>().registerUserController,
                            formKey: formKeys[1]!,
                          ),
                        ],
                      ),
                      isActive: true,
                      state: StepState.indexed,
                    ),
                    Step(
                      title: const Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          Text("Otros datos",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
                      content: Column(
                        children: [
                          FormStepThree(
                            registerUserController:
                                context.read<AuthBloc>().registerUserController,
                            formKey: formKeys[2]!,
                          ),
                        ],
                      ),
                      isActive: true,
                      state: StepState.indexed,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
