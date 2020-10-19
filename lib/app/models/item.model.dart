class Item {
  String nome;
  bool concluido;
  DateTime dueDate;

  Item({this.nome, this.concluido, this.dueDate});

  Item.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    concluido = json['concluido'];
    dueDate = DateTime.parse(json['dueDate']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['concluido'] = this.concluido;
    data['dueDate'] = this.dueDate.toIso8601String();
    return data;
  }
}
