import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
            Icon(
              Icons.map,
              size: 100,
              color: pedido.status == 'Entregue' ? Colors.green : Colors.blue,
            ),
            const SizedBox(height: 20),
            Text(
              'Status Atual: ${pedido.status}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Valor Total: R\$ ${pedido.valor.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 40),
            if (pedido.status != 'Entregue')
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                icon: const Icon(Icons.check_circle),
                label: const Text(
                  'Confirmar Entrega',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () async {
                  // Aqui é onde o aplicativo manda o comando para a nuvem!
                  await FirebaseFirestore.instance
                      .collection('pedidos')
                      .doc(pedido.id) // Apontamos para o documento exato
                      .update({
                        'status': 'Entregue',
                      }); // Mandamos atualizar apenas o status

                  // Após atualizar na nuvem, voltamos para a tela anterior automaticamente
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
