import 'package:mvc_persistence/app/models/item.model.dart';
import 'package:mvc_persistence/app/repositories/item.repository.dart';

class ItemController {
  List<Item> list = new List<Item>();
  ItemRepository repository = new ItemRepository();

  Future<void> getAll() async {
    try {
      final allList = await repository.getAll();
      list.clear();
      list.addAll(allList);
      sort();
    } catch (e) {
      print("Erro: " + e.toString());
    }
  }

  Future<void> create(Item item) async {
    try {
      list.add(item);
      await repository.create(item);
    } catch (e) {
      print("Erro: " + e.toString());
    }
  }

  Future<void> delete(int id) async {
    try {
      list.removeAt(id);
      await repository.delete(id);
    } catch (e) {
      print("Erro: " + e.toString());
    }
  }

  Future<void> update(Item item) async {
    await repository.update(item);
    await getAll();
  }

  void sort() {
    list.sort((a, b) {
      if (a.concluido && !b.concluido)
        return 1;
      else if (!a.concluido && b.concluido)
        return -1;
      else
        return 0;
    });
  }
}
