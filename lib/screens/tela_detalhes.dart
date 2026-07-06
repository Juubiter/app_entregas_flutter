import 'package:flutter/material.dart';
import '../models/pedido.dart';

class TelaDetalhes extends StatelessWidget {
  final Pedido pedido;

  const TelaDetalhes({super.key, required this.pedido});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalhes do Pedido #${pedido.numero}')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.map, size: 100, color: Colors.blue),
            const SizedBox(height: 20),
            Text(
              'Status Atual: ${pedido.status}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Valor Total: R\$ ${pedido.valor}',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
