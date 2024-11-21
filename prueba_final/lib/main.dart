import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prueba_final/firebase_options.dart';
import 'package:prueba_final/utils/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            // Imagen de fondo
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/fondo.jpg'), // Ruta de la imagen
                  fit:
                      BoxFit.cover, // Ajustar la imagen para cubrir la pantalla
                ),
              ),
            ),
            // Capa blanca semitransparente
            Container(
              color: Colors.white
                  .withOpacity(0.8), // Fondo blanco semitransparente
            ),
            // Contenido
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: LoginForm(), // Formulario separado en un widget
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _auth = AuthService(); // Instancia de AuthService

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _userController, // Controlador para capturar usuario
          decoration: const InputDecoration(
            labelText: 'Usuario',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16.0),
        TextField(
          controller:
              _passwordController, // Controlador para capturar contraseña
          decoration: const InputDecoration(
            labelText: 'Contraseña',
            border: OutlineInputBorder(),
          ),
          obscureText: true, // Ocultar el texto ingresado
        ),
        const SizedBox(height: 16.0),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white, // Color del texto del botón
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Bordes redondeados
            ),
          ),
          onPressed: _register, // Método para registrar
          child: const Text("Registro"),
        ),
        const SizedBox(height: 16.0),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black, // Color del texto
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: _signInWithGoogle,
          icon: Image.asset(
            'assets/google_logo.png', // Logo de Google en assets
            height: 20.0,
          ),
          label: const Text("Iniciar sesión con Google"),
        ),
      ],
    );
  }

  Future<void> _register() async {
    final String email = _userController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar("Usuario o contraseña vacíos");
      return;
    }

    if (!_isValidEmail(email)) {
      _showSnackBar("Email no válido, prueba con otro!");
      return;
    }

    if (!_isValidPassword(password)) {
      _showSnackBar("Contraseña no válida. Debe tener al menos 8 caracteres.");
      return;
    }

    try {
      var result = await _auth.createAccount(email, password);

      if (result == 1) {
        _showSnackBar("Contraseña débil. Usa una más segura.");
      } else if (result == 2) {
        _showSnackBar("Este correo ya está en uso. Prueba con otro.");
      } else if (result != null) {
        _showSnackBar("Cuenta creada exitosamente!");
      } else {
        _showSnackBar("Error desconocido. Intenta de nuevo.");
      }
    } catch (e) {
      _showSnackBar("Error al registrar: $e");
    }
  }

  Future<void> _signInWithGoogle() async {
    final result = await _auth.signInWithGoogle();

    if (result != null) {
      _showSnackBar("Inicio de sesión exitoso con Google!");
    } else {
      _showSnackBar("Error al iniciar sesión con Google.");
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 8;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
