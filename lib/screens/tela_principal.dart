import 'package:flutter/material.dart';
import '../models/pedido.dart';
import 'tela_detalhes.dart';

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  List<Pedido> meusPedidos = [
    Pedido(numero: 1024, status: 'Aguardando Retirada', valor: 45.90),
    Pedido(numero: 1025, status: 'Em Rota', valor: 89.00),
    Pedido(numero: 1026, status: 'Entregue', valor: 32.50),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Painel de Entregas')),
      body: ListView.builder(
        itemCount: meusPedidos.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(
              Icons.fastfood,
              color: meusPedidos[index].status == 'Entregue'
                  ? Colors.green
                  : Colors.orange,
            ),
            title: Text('Pedido #${meusPedidos[index].numero}'),
            subtitle: Text('Status: ${meusPedidos[index].status}'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              setState(() {
                meusPedidos[index].status = 'Entregue';
              });

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TelaDetalhes(pedido: meusPedidos[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
