import 'package:flutter/material.dart';

void main() {
  runApp(const MisNotasApp());
}

// --- 1. CONFIGURACIÓN PRINCIPAL ---
class MisNotasApp extends StatelessWidget {
  const MisNotasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notas Secretas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Iniciamos en la Pantalla 1
      home: const PantallaLista(),
    );
  }
}

// --- 2. PANTALLA 1: LISTA DE NOTAS (El Home) ---
class PantallaLista extends StatefulWidget {
  const PantallaLista({super.key});

  @override
  State<PantallaLista> createState() => _PantallaListaState();
}

class _PantallaListaState extends State<PantallaLista> {
  // Esta lista simula nuestra Base de Datos local
  List<String> misNotas = [
    "Comprar leche 🥛",
    "Aprender Flutter con Gemini 🤖",
  ];

  // Función para navegar a la Pantalla 2 y ESPERAR el resultado
  void _irACrearNota() async {
    // Navigator.push es como "poner una carta encima de otra"
    // El 'await' significa: "Espera aquí hasta que la pantalla 2 se cierre y traiga algo"
    final nuevaNota = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PantallaCrear()),
    );

    // Cuando volvemos, verificamos si trajo algo
    if (nuevaNota != null) {
      setState(() {
        misNotas.add(nuevaNota); // Guardamos la nota en la lista
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Notas Secretas 🤫"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      // ListView es especial para listas infinitas o largas
      body: ListView.builder(
        itemCount: misNotas.length, // Cuántas notas hay
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(Icons.note, color: Colors.purple),
              title: Text(misNotas[index]), // Muestra el texto de la nota
              onTap: () {
                // Aquí podrías poner lógica para borrar o editar
                print("Tocaste la nota: ${misNotas[index]}");
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _irACrearNota, // Llamamos a la función de navegar
        child: const Icon(Icons.add),
      ),
    );
  }
}

// --- 3. PANTALLA 2: CREAR NOTA (El Formulario) ---
class PantallaCrear extends StatefulWidget {
  const PantallaCrear({super.key});

  @override
  State<PantallaCrear> createState() => _PantallaCrearState();
}

class _PantallaCrearState extends State<PantallaCrear> {
  // Controlador: Es como el "mayordomo" que vigila lo que escribes en el cuadro de texto
  final TextEditingController _controladorTexto = TextEditingController();

  void _guardarYSalir() {
    // Navigator.pop es "quitar la carta de arriba" (volver atrás)
    // El segundo parámetro (_controladorTexto.text) es el REGALO que le llevamos a la Pantalla 1
    Navigator.pop(context, _controladorTexto.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nueva Nota 📝")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Escribe tu secreto:", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),

            // TextField: El cuadro para escribir
            TextField(
              controller: _controladorTexto, // Conectamos al mayordomo
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ej: Conquistar el mundo...',
              ),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _guardarYSalir,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: const Text("GUARDAR NOTA"),
            ),
          ],
        ),
      ),
    );
  }
}
