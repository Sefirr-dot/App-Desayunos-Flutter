import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prueba_final/firebase_options.dart';
import 'package:prueba_final/utils/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
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
                  .withOpacity(0.8), // Fondo blanco con opacidad del 20%
            ),
            // Contenido
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Usuario',
                        fillColor:
                            Colors.white, // Etiqueta para el campo de texto
                        border:
                            OutlineInputBorder(), // Borde para el campo de texto
                      ),
                    ),
                    const SizedBox(height: 16.0), // Espacio entre los campos
                    const TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        labelText:
                            'Contraseña', // Etiqueta para el campo de contraseña
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true, // Ocultar el texto ingresado
                    ),
                    const SizedBox(height: 16.0),
                    butonLogin(context), // Añadido como hijo del Column
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

ElevatedButton butonLogin(BuildContext context) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white, // Color del texto del botón
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Bordes redondeados de 8px
        ),
      ),
      onPressed: () async {
        final AuthService _auth = AuthService();
        var user = await _auth.createAccount("asd@asd.com", "12345678");

        if (user != null) {
          print("OK");
        }
      },
      child: const Text("Registro"));
}
