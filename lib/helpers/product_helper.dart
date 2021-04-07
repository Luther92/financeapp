import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

final String produtoTabela = "produtoTabela";
final String idProdutoColuna = "idProdutoColuna";
final String descricaoColuna = "descricaoColuna";
final String quantidadeColuna = "quantidadeColuna";
final String unidadeColuna = "unidadeColuna";
final String precoColuna = "precoColuna";
final String totalColuna = "totalColuna";

class ProductHelper {
              //objeto da classe        //contrutor interno
  //static final ProductHelper _instance = ProductHelper().internal();

  //factory ProductHelper() => _instance;

  ProductHelper.internal();

  Database _db;

  ProductHelper(){

  }

  //inicialização do banco
  Future<Database> get db async {
    if(_db != null){
      return _db;
    } else{
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "produtos.db");

    return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async {
      await db.execute(
        "CREATE TABLE $produtoTabela("
            "$idProdutoColuna INTEGER PRIMARY KEY,"
            "$descricaoColuna TEXT,"
            "$quantidadeColuna NUMBER,"
            "$unidadeColuna TEXT,"
            "$precoColuna NUMBER,"
            "$totalColuna NUMBER)"
      );
    });
  }

  Future<Produto> salvaProduto(Produto produto) async {
    Database dbProduto = await db;
    produto.idProduto = await dbProduto.insert(produtoTabela, produto.toMap());
    return produto;
  }

  Future<Produto> consultaProduto(int id) async {
    Database dbProduto = await db;
    List<Map> maps = await dbProduto.query(
      produtoTabela,
      columns: [idProdutoColuna, descricaoColuna, quantidadeColuna, unidadeColuna, precoColuna, totalColuna],
      where: "$idProdutoColuna = ?",
      whereArgs: [id]);

    if(maps.length > 0){ //verifica se realmente foi retornado um produto
      return Produto.fromMap(maps.first); //retorna o produto
    } else {
      return null;
    }
  }

  Future<int> deletaProduto(int id) async {
    Database dbProduto = await db;
    return await dbProduto.delete(
        produtoTabela,
        where: "$idProdutoColuna = ?",
        whereArgs: [id]);
  }

  Future<int> atualizaProduto(Produto produto) async {
    Database dbProduto = await db;
    return await dbProduto.update(
        produtoTabela,
        produto.toMap(),
        where: "$idProdutoColuna = ?",
        whereArgs: [produto.idProduto]);
  }

  Future<List> buscaListaProdutos() async {
    Database dbProduto = await db;
    List listMap = await dbProduto.rawQuery("SELECT * FROM $produtoTabela");
    List<Produto> listaProduto = List();
    for(Map m in listMap) {
      listaProduto.add(Produto.fromMap(m));
    }
    return listaProduto;
  }

  Future<int> consultaQuantidadeProdutos() async {
    Database dbProduto = await db;
    return Sqflite.firstIntValue(await dbProduto.rawQuery("SELECT COUNT(*) FROM $produtoTabela"));
  }

  Future close() async {
    Database dbProduto = await db;
    dbProduto.close();
  }

  ProductHelper internal() {}
}

class Produto {

  int idProduto;
  String descricao;
  num quantidade;
  String unidade;
  num preco;
  num total;

  Produto();

  Produto.fromMap(Map map){
    idProduto = map[idProdutoColuna];
    descricao = map[descricaoColuna];
    quantidade = map[quantidadeColuna];
    unidade = map[unidadeColuna];
    preco = map[precoColuna];
    total = map[totalColuna];
  }

  Map toMap(){
    Map<String, dynamic> map = {
      descricaoColuna: descricao,
      quantidadeColuna: quantidade,
      unidadeColuna: unidade,
      precoColuna: preco,
      totalColuna: total
    };

    if(idProduto != null){
      map[idProdutoColuna] = idProduto;
    }

    return map;
  }

  @override
  String toString() {
    return "Procuto(idProduto: $idProduto, descrição: $descricao, quantidade: $quantidade, unidade: $unidade, preço: $preco, total: $total)";

  }
}