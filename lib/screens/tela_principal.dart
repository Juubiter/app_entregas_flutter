import 'package:flutter/material.dart';
import '../models/pedido.dart';
import 'tela_detalhes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        // 1. Apontamos o "tubo" para a nossa coleção criada na web
        stream: FirebaseFirestore.instance.collection('pedidos').snapshots(),
        builder: (context, snapshot) {
          // 2. Se estiver carregando, mostra a bolinha girando (Loading)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 3. Se a coleção estiver vazia ou der erro
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Nenhum pedido na nuvem.'));
          }

          // 4. Pegamos a lista de documentos da nuvem
          final documentos = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documentos.length,
            itemBuilder: (context, index) {
              // 5. Extrai o JSON que veio do Google
              var dados = documentos[index].data() as Map<String, dynamic>;

              // 6. Converte para a nossa Classe Pedido
              Pedido pedidoReal = Pedido(
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
    );
  }
}
