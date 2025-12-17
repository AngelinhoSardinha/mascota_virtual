import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/buildings.dart';
import 'building_detail.dart';

class ListaEdificacionesScreen extends StatefulWidget {
  const ListaEdificacionesScreen({super.key});

  @override
  State<ListaEdificacionesScreen> createState() =>
      _ListaEdificacionesScreenState();
}

class _ListaEdificacionesScreenState extends State<ListaEdificacionesScreen> {
  final _supabase = Supabase.instance.client;

  final ScrollController _scrollController = ScrollController();
  final List<Buildings> _edificios = [];
  bool _cargando = false;
  bool _todoCargado = false;
  final int _cantidadPorPagina = 10;

  @override
  void initState() {
    super.initState();
    _cargarMasEdificios();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (!_cargando && !_todoCargado) {
          _cargarMasEdificios();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _cargarMasEdificios() async {
    if (_cargando) return;
    setState(() => _cargando = true);

    try {
      final inicio = _edificios.length;
      final fin = inicio + _cantidadPorPagina - 1;

      final response = await _supabase
          .from('buildings')
          .select()
          .range(inicio, fin)
          .order('id_building', ascending: true);

      final nuevosEdificios = (response as List)
          .map((mapa) => Buildings.fromMap(mapa))
          .toList();

      setState(() {
        _edificios.addAll(nuevosEdificios);
        if (nuevosEdificios.length < _cantidadPorPagina) {
          _todoCargado = true;
        }
      });
    } catch (e) {
      debugPrint("Error cargando: $e");
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Edificios 🏗️"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _edificios.isEmpty && _cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: _edificios.length + (_todoCargado ? 0 : 1),
              itemBuilder: (context, index) {
                if (index == _edificios.length) {
                  return const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final edificio = _edificios[index];

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: const Icon(
                      Icons.apartment,
                      color: Colors.deepPurple,
                    ),
                    title: Text(
                      edificio.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(edificio.location),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BuildingDetailScreen(building: edificio),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
