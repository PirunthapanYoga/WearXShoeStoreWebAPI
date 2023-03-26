import 'package:flutter/material.dart';
import 'package:mywebstore/Models/cartItem.dart';
import 'package:mywebstore/Views/productPage.dart';
import 'package:mywebstore/Views/user.dart';
import '../Models/products.dart';
import '../Models/store.dart';
import '../Services/get_Data.dart';
import '../theme/fontStyle.dart';
import 'cart.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoaded = false;
  Store? store = Store();
  List<CartItem> cart = <CartItem>[];
  List<Product> product = <Product>[];

  @override
  void initState() {
    super.initState();
    setState(() {
      getData();
    });
  }

  getData() async {
    final store = await GetData().getProduct();

    if (store != null) {
      setState(() {
        product = store.product!;
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: SafeArea(
        child: Visibility(
          replacement: Container(
              height: size.height,
              width: size.width,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  gradient: LinearGradient(
                    colors: [Colors.lightBlueAccent, Colors.lightGreen],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.grey, blurRadius: 10.0)
                  ]),
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                        height: size.height,
                        width: size.height*0.5,
                        top: size.height*0.20,
                        left: size.height*0.10,
                        child: const Text(
                            'Wear X',
                          style: TextStyle(
                            fontSize: 75,
                          ),
                        )
                    ),
                    Positioned(
                        height: size.height,
                        width: size.height*0.5,
                        top: size.height*0.33,
                        left: size.height*0.17,
                        child: const Text('Welcome',
                          style: TextStyle(
                          fontSize: 25,
                        ),)
                    ),
                    Positioned(
                        height: size.height*0.04,
                        width: size.height*0.04,
                        top: size.height*0.60,
                      child: const SizedBox(
                          child: CircularProgressIndicator()
                      ),
                    ),
                  ],
                ),
              )
          ),
          visible: isLoaded,
          child: Column(
            children: [
              Container(
                width: size.width,
                height: size.height*0.06,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                    gradient: LinearGradient(
                      colors: [Colors.lightBlueAccent, Colors.lightGreen],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 10.0
                      )
                    ]
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: size.width * 0.001,
                      top: size.height * 0.005,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UserProfile()));
                        },
                        icon: const Icon(Icons.person_2_outlined, color: Colors.white),
                      ),
                    ),
                    const Center(
                      child: Text(
                        'Welcome to Wear X ',
                        style: titleStyle,
                      ),
                    ),
                    Positioned(
                      left: size.width * 0.88,
                      top: size.width*0.01,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Cart(cart: cart)));
                        },
                        icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: size.height * 0.88,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey[200],
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 10.0
                      )
                    ]
                ),
                child: GridView.builder(
                  padding: const EdgeInsets.all(15),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 200,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 5),
                  itemCount: product.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (Context) => ProductPage(cart: cart, product: product[index])));
                      },
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(10 , 0, 10, 0),
                              alignment: Alignment.topCenter,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10) , topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                color: Colors.white,
                              ),
                              child: Image.network(product[index].mainImage),
                            ),
                          ),
                          Positioned(
                            bottom: size.height * 0.03,
                            left: size.width * 0.05,
                            right: size.width * 0.05,
                            child: Text(
                              product[index].name,
                              style: productNameStyle,
                            ),
                          ),
                          Positioned(
                            top: size.height * 0.21,
                            left: size.width * 0.3,
                            child: Text(
                              "${product[index].price.amount} ${product[index].price.currency}",
                              style: productDetailsStyle,
                            ),
                          ),
                          Positioned(
                            top: size.height * 0.21,
                            left: size.width * 0.05,
                            child: Text(
                              product[index].stockStatus,
                              style: TextStyle(
                                fontSize: 10,
                                color: product[index].stockStatus == 'IN STOCK'
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
