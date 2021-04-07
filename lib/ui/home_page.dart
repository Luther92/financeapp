import 'package:crud_banco/helpers/product_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ProductHelper helper;

  //Produto p;

  @override
  void initState() {
    super.initState();


    helper = ProductHelper();
    print(helper);

    Produto p = Produto();
    p.descricao = 'Coca-Cola 2LT';
    p.quantidade = 1;
    p.unidade = "UN";
    p.preco = 5.79;
    p.total = p.quantidade * p.preco;

    print(p);

    helper.salvaProduto(p);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
