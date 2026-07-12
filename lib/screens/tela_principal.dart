import 'package:flutter/material.dart';
import '../models/pedido.dart';
import 'tela_detalhes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Painel de Entregas')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('pedidos').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Nenhum pedido na nuvem.'));
          }
          final documentos = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documentos.length,
            itemBuilder: (context, index) {
              var dados = documentos[index].data() as Map<String, dynamic>;
              Pedido pedidoReal = Pedido(
                id: documentos[index].id,
                numero: dados['numero'] ?? 0,
                status: dados['status'] ?? 'Desconhecido',
                valor: (dados['valor'] ?? 0.0).toDouble(),
              );

              return ListTile(
                leading: Icon(
                  Icons.fastfood,
                  color: pedidoReal.status == 'Entregue'
                      ? Colors.green
                      : Colors.orange,
                ),
                title: Text('Pedido #${pedidoReal.numero}'),
                subtitle: Text('Status: ${pedidoReal.status}'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaDetalhes(pedido: pedidoReal),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          TextEditingController valorController = TextEditingController();

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Nova Entrega'),
                content: TextField(
                  controller: valorController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Valor do Pedido (R\$)',
                    hintText: 'Ex: 45.50',
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      double valorDigitado =
                          double.tryParse(
                            valorController.text.replaceAll(',', '.'),
                          ) ??
                          0.0;
                      int numeroGerado = Random().nextInt(9000) + 1000;
                      await FirebaseFirestore.instance
                          .collection('pedidos')
                          .add({
                            'numero': numeroGerado,
                            'status': 'Em Preparo',
                            'valor': valorDigitado,
                          });

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Criar Pedido'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
