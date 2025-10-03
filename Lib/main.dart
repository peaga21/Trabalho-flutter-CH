import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TelaTarefas(),
    );
  }
}

class Tarefa {
  String nome;
  bool concluida;
  
  Tarefa(this.nome, this.concluida);
}

class TelaTarefas extends StatefulWidget {
  @override
  _TelaTarefasState createState() => _TelaTarefasState();
}

class _TelaTarefasState extends State<TelaTarefas> {
  final TextEditingController _controller = TextEditingController();
  final List<Tarefa> _tarefas = [];
  bool _status = false; // false = pendente, true = concluída

  void _adicionarTarefa() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _tarefas.add(Tarefa(_controller.text, _status));
        _controller.clear();
        _status = false;
      });
    }
  }

  void _alternarStatus(int index) {
    setState(() {
      _tarefas[index].concluida = !_tarefas[index].concluida;
    });
  }

  void _removerTarefa(int index) {
    setState(() {
      _tarefas.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Formulário para adicionar tarefas
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Nome da Tarefa',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.task),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text('Status:'),
                    SizedBox(width: 10),
                    DropdownButton<bool>(
                      value: _status,
                      items: [
                        DropdownMenuItem(
                          value: false,
                          child: Row(
                            children: [
                              Icon(Icons.pending, color: Colors.orange),
                              SizedBox(width: 5),
                              Text('Pendente'),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: true,
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green),
                              SizedBox(width: 5),
                              Text('Concluída'),
                            ],
                          ),
                        ),
                      ],
                      onChanged: (bool? novoStatus) {
                        setState(() {
                          _status = novoStatus ?? false;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _adicionarTarefa,
                  child: Text('Adicionar Tarefa'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
          
          // Lista de tarefas
          Expanded(
            child: ListView.builder(
              itemCount: _tarefas.length,
              itemBuilder: (context, index) {
                final tarefa = _tarefas[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  color: tarefa.concluida ? Colors.green[50] : Colors.white,
                  child: ListTile(
                    leading: Icon(
                      tarefa.concluida 
                          ? Icons.check_circle 
                          : Icons.pending_actions,
                      color: tarefa.concluida ? Colors.green : Colors.orange,
                    ),
                    title: Text(
                      tarefa.nome,
                      style: TextStyle(
                        decoration: tarefa.concluida 
                            ? TextDecoration.lineThrough 
                            : TextDecoration.none,
                        fontWeight: tarefa.concluida 
                            ? FontWeight.normal 
                            : FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      tarefa.concluida ? 'Concluída' : 'Pendente',
                      style: TextStyle(
                        color: tarefa.concluida ? Colors.green : Colors.orange,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            tarefa.concluida 
                                ? Icons.undo 
                                : Icons.check,
                            color: tarefa.concluida 
                                ? Colors.orange 
                                : Colors.green,
                          ),
                          onPressed: () => _alternarStatus(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removerTarefa(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}