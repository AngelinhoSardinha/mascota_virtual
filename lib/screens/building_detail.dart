import 'package:flutter/material.dart';
import '../models/buildings.dart';

class BuildingDetailScreen extends StatelessWidget {
  // Recibimos el objeto completo del edificio
  final Buildings building;

  const BuildingDetailScreen({super.key, required this.building});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(building.name), // Título con el nombre del edificio
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- ENCABEZADO: FOTO (ICONO) Y ESTADO ---
            Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.apartment,
                    size: 100,
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(height: 10),
                  // Mostramos si está validado o no con un chip bonito
                  Chip(
                    label: Text(
                      building.validate
                          ? "Validado ✅"
                          : "Pendiente de Revisión ⏳",
                      style: TextStyle(
                        color: building.validate
                            ? Colors.green.shade900
                            : Colors.orange.shade900,
                      ),
                    ),
                    backgroundColor: building.validate
                        ? Colors.green.shade100
                        : Colors.orange.shade100,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),

            // --- SECCIÓN 1: DATOS PRINCIPALES ---
            _crearTituloSeccion("📍 Información General"),
            _crearDato("Ubicación", building.location, Icons.location_on),
            _crearDato(
              "Año Construcción",
              "${building.construction_year}",
              Icons.calendar_today,
            ),
            _crearDato("Coordenadas", building.coordinates, Icons.map),

            const Divider(),

            // --- SECCIÓN 2: DETALLES TÉCNICOS ---
            _crearTituloSeccion("📏 Detalles Técnicos"),
            _crearDato(
              "Superficie",
              "${building.surface_area} m²",
              Icons.square_foot,
            ),
            _crearDato(
              "Tipología (ID)",
              "${building.id_typology}",
              Icons.category,
            ),
            _crearDato(
              "Protección (ID)",
              "${building.id_protection}",
              Icons.shield,
            ),

            const Divider(),

            // --- SECCIÓN 3: DESCRIPCIÓN ---
            _crearTituloSeccion("📝 Descripción"),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: Text(
                building.descripction.isNotEmpty
                    ? building.descripction
                    : "Sin descripción disponible.",
                style: const TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper UwU para crear títulos de sección
  Widget _crearTituloSeccion(String titulo) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        titulo,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  // Helper UwU para crear cada fila de dato
  Widget _crearDato(String etiqueta, String valor, IconData icono) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      elevation: 0, // Planito para que se vea limpio
      color: Colors.grey.shade100,
      child: ListTile(
        leading: Icon(icono, color: Colors.deepPurpleAccent),
        title: Text(
          etiqueta,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        subtitle: Text(
          valor,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
