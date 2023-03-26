import 'package:flutter/material.dart';
import 'package:mywebstore/Models/cartItem.dart';

import '../Models/products.dart';
import '../theme/fontStyle.dart';
import 'Cart.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key, required this.cart, required this.product})
      : super(key: key);
  final List<CartItem> cart;
  final Product product;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String selectedSize = "8";
  int count = 1;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget buyNowDetails(){
      return Align(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.product.name,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.product.colour[0].toUpperCase()+widget.product.colour.substring(1),
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Size $selectedSize',
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${widget.product.price.amount} ${widget.product.price.currency}',
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(10)),
          ],
        ),
      );
    }

    Future openDialog(String size) => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Select Size'),
            content: Text(
              'Selected Size : $size',
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    bool isUpdated = false;

                    for (CartItem item in widget.cart) {
                      if (widget.product.name == item.name &&
                          selectedSize == item.selectedSizes) {
                        item.count += 1;
                        isUpdated = true;
                        break;
                      }
                    }

                    if (!isUpdated) {
                      CartItem selectedItem = CartItem(
                          count: 1,
                          selectedSizes: selectedSize,
                          id: widget.product.id,
                          sKU: widget.product.sKU,
                          name: widget.product.name,
                          brandName: widget.product.brandName,
                          mainImage: widget.product.mainImage,
                          price: widget.product.price,
                          stockStatus: widget.product.stockStatus,
                          colour: widget.product.colour,
                          description: widget.product.description,
                          sizes: widget.product.sizes);
                      widget.cart.add(selectedItem);
                    }

                    Navigator.of(context).pop();
                  },
                  child: const Text('Add to card')),
            ],
          ),
        );

    Future conformPurchaseDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Align(
            alignment: Alignment.topLeft,
            child: Text('Purchase Successful')),
        content: SizedBox(
          height: MediaQuery.of(context).size.height*0.3,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              buyNowDetails(),
              Text(
                'Number of Items : $count',
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  'Total Paid = ${(double.parse(widget.product.price.amount)*count).toString()} ${widget.product.price.currency}',
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              count=1;
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back ,size: 30, color: Colors.blue,),
          )
        ],
      ),
    );

    Future buyNowDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Align(
            alignment: Alignment.topLeft,
            child: Text('Purchase Conformation')),
        content: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height*0.3,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              buyNowDetails(),
              const Padding(padding: EdgeInsets.all(10)),
              Container(
                padding: EdgeInsets.all(2),
                alignment: Alignment.center,
                width: size.width*0.255,
                child: Row(
                  children: [
                    SizedBox(
                      width: size.width * 0.08,
                      height: size.height * 0.04,
                      child: Center(
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                if(count>1){
                                  Navigator.of(context).pop();
                                  buyNowDialog();
                                  count--;
                                }
                              });
                            },
                            icon: const Icon(
                              Icons.remove,
                              size: 15,
                            )),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.08,
                      height: size.height * 0.04,
                      child: Center(
                        child: Text(
                          '$count',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.08,
                      height: size.height * 0.04,
                      child: Center(
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                count++;
                                Navigator.of(context).pop();
                                buyNowDialog();
                              });
                            },
                            icon: const Icon(
                              Icons.add,
                              size: 15,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.all(20)),
              Text(
                'Total Payable : ${(double.parse(widget.product.price.amount)*count).toString()} ${widget.product.price.currency}'
              ),
            ],
          ),
        ),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back ,size: 30, color: Colors.blue,),
              ),
              Padding(padding: EdgeInsets.only(left: size.width*0.4)),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                 conformPurchaseDialog();
                },
                child: Row(
                  children: const [
                    Text('Conform'),
                    Icon(Icons.shopping_cart_checkout_outlined ,size: 30, color: Colors.blue,),
                  ],
                ),
              ),
            ],
          )

        ],
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: size.width,
              height: size.height * 0.06,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  gradient: LinearGradient(
                    colors: [Colors.lightBlueAccent, Colors.lightGreen],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10.0)]),
              child: Stack(
                children: [
                  Positioned(
                    left: size.width * 0.001,
                    top: size.height * 0.005,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Wear X ',
                      style: titleStyle,
                    ),
                  ),
                  Positioned(
                    left: size.width * 0.88,
                    top: size.width * 0.01,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Cart(cart: widget.cart)));
                      },
                      icon: const Icon(Icons.shopping_cart_outlined,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.all(10)),
            Container(
              height: size.height * 0.3,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                color: Colors.grey,
              ),
              child: Image.network(widget.product.mainImage),
            ),
            Container(
              height: size.height * 0.58,
              width: size.width * 0.95,
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.topCenter,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                color: Colors.white,
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: size.height * 0.02,
                    left: size.width * 0.02,
                    child: SizedBox(
                      width: size.width * 0.9,
                      child: Text(
                        widget.product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.blueGrey,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: size.width * 0.02,
                    top: size.height * 0.12,
                    child: Text(
                      'Brand : ${widget.product.brandName[0].toUpperCase()}${widget.product.brandName.substring(1)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.blueGrey,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  Positioned(
                    left: size.width * 0.02,
                    top: size.height * 0.15,
                    child: Text(
                      'Colour : ${widget.product.colour[0].toUpperCase()}${widget.product.colour.substring(1)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.blueGrey,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  Positioned(
                    left: size.width * 0.52,
                    top: size.height * 0.12,
                    child: Text(
                      "Price : ${widget.product.price.amount} ${widget.product.price.currency}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.blueGrey,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  Positioned(
                    left: size.width * 0.52,
                    top: size.height * 0.15,
                    child: Text(
                      widget.product.stockStatus,
                      style: TextStyle(
                        fontSize: 15,
                        color: widget.product.stockStatus == 'IN STOCK'
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    left: size.width * 0.02,
                    top: size.height * 0.19,
                    child: SizedBox(
                      width: size.width * 0.9,
                      height: size.height * 0.3,
                      child: Text(
                        widget.product.description,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: size.height * 0.42,
                    left: size.width * 0.02,
                    child: SizedBox(
                        width: size.width * 0.8,
                        height: size.height * 0.05,
                        child: const Text(
                          'Size : ',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ),
                  Positioned(
                    top: size.height * 0.405,
                    left: size.width * 0.15,
                    child: SizedBox(
                      width: size.width * 0.12,
                      height: size.height * 0.05,
                      child: DropdownButton(
                        // Initial Value
                        value: selectedSize,

                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),

                        // Array list of items
                        items: widget.product.sizes.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedSize = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                  Positioned(
                      top: size.height * 0.50,
                      left: size.width * 0.15,
                      child: OutlinedButton(
                          onPressed: () {
                            openDialog(selectedSize);
                          },
                          child: Row(
                            children: const [
                              Text('Add To Card'),
                              Icon(Icons.add_shopping_cart),
                            ],
                          ))),
                  Positioned(
                    top: size.height * 0.50,
                    left: size.width * 0.50,
                    child: OutlinedButton(
                      onPressed: () {
                        buyNowDialog();
                      },
                      child: Row(
                        children: const [
                          Text('Buy It Now'),
                          Icon(Icons.shopping_cart_outlined),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
