import 'dart:ffi';

import 'package:flutter/material.dart';
import '../Models/cartItem.dart';
import '../theme/fontStyle.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key, required this.cart}) : super(key: key);
  final List<CartItem> cart;

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  num subTotal = 0;

  void total() {
    subTotal = 0;
    for (CartItem item in widget.cart) {
      subTotal += double.parse(item.price.amount) * item.count;
    }
  }

  void clearCart() {
    setState(() {
      widget.cart.clear();
      subTotal = 0;
      Navigator.of(context).pop();
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Cart(
                cart: widget.cart,
              )));
    });
  }

  Widget sum() {
    total();
    if (subTotal != 0) {
      return Text(
        '$subTotal ${widget.cart[0].price.currency}',
        style: cartSumStyle,
      );
    } else {
      return const Text('');
    }
  }

  Widget cartList(var size) {
    if (widget.cart.isNotEmpty) {
      return Column(
        children: [
          SizedBox(
            height: size.height * 0.82,
            width: size.width,
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 2, right: 2),
              itemCount: widget.cart.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 2.0),
                          blurRadius: 20.0,
                        ),
                      ],
                    ),
                    width: size.width * 0.8,
                    child: SizedBox(
                      height: size.height * 0.1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.network(
                            widget.cart[index].mainImage,
                            width: size.width * 0.3,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(padding: EdgeInsets.all(5)),
                              SizedBox(
                                width: size.width * 0.3,
                                child: Text(
                                  widget.cart[index].name,
                                  style: cartDetailsStyle,
                                ),
                              ),
                              Text(
                                widget.cart[index].brandName,
                                style: cartDetailsStyle,
                              ),
                              Text(
                                'Size: ${widget.cart[index].selectedSizes}',
                                style: cartDetailsStyle,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: size.width * 0.08,
                                height: size.height * 0.04,
                                child: Center(
                                  child: IconButton(
                                      onPressed: () {
                                        if (widget.cart[index].count <= 1 &&
                                            widget.cart.length == 1) {
                                          clearCart();
                                        } else if (widget.cart[index].count <=
                                            1) {
                                          setState(() {
                                            widget.cart.removeAt(index);
                                            total();
                                          });
                                        } else {
                                          setState(() {
                                            widget.cart[index].count =
                                                widget.cart[index].count - 1;
                                            total();
                                          });
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.remove,
                                        size: 15,
                                      )),
                                ),
                              ),
                              SizedBox(
                                child: Center(
                                  child: Text(
                                    widget.cart[index].count.toString(),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: size.width * 0.05,
                                height: size.height * 0.04,
                                child: Center(
                                  child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          widget.cart[index].count =
                                              widget.cart[index].count + 1;
                                          total();
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.add,
                                        size: 15,
                                      )),
                                ),
                              )
                            ],
                          ),
                          const Padding(padding: EdgeInsets.all(10)),
                          Text(
                            '${widget.cart[index].price.amount} ${widget.cart[index].price.currency}',
                            style: cartDetailsStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Padding(padding: EdgeInsets.all(5)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                onPressed: () {
                  clearCart();
                },
                child: Row(
                  children: const [
                    Text('Clear Cart'),
                    Icon(Icons.remove_shopping_cart_outlined),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  conformPurchaseDialog();
                },
                child: Row(
                  children: const [
                    Text('Buy It Now'),
                    Icon(Icons.shopping_cart_checkout),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return SizedBox(
        height: size.height * 0.82,
        width: size.width,
        child: const Center(
          child: Text(
            'Empty Cart',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w200,
            ),
          ),
        ),
      );
    }
  }

  Future openDialog(String size) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Conform Purchase'),
          content: Text(
            'Total Amount : $subTotal',
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Conform Purchase')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel')),
          ],
        ),
      );

  Future conformPurchaseDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Align(
            alignment: Alignment.topLeft,
              child: Text('Purchase Successful')),
          content: Container(
            height: MediaQuery.of(context).size.height*0.3,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width*0.95,
                  height: MediaQuery.of(context).size.width*0.5,
                  child: ListView.builder(
                    itemCount: widget.cart.length,
                      itemBuilder: (context , index){
                        return Text(
                          '${widget.cart[index].name} ${widget.cart[index].selectedSizes} X ${widget.cart[index].count}  ${widget.cart[index].price.amount*widget.cart[index].count} ${widget.cart[index].price.currency}' ,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        );
                      },
                  ),
                ),
                const Padding(padding: EdgeInsets.all(10)),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    'Total Paid =  $subTotal ${widget.cart.first.price.currency}',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                clearCart();
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back ,size: 30, color: Colors.blue,),
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: size.height * 0.98,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 1)),
          width: size.width,
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
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 1.0)],
                ),
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
                        'Cart ',
                        style: titleStyle,
                      ),
                    ),
                    Positioned(
                        left: size.width * 0.78,
                        top: size.height * 0.025,
                        child: sum()),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.all(5)),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 2.0),
                      blurRadius: 20.0,
                    ),
                  ],
                ),
                height: size.height * 0.89,
                width: size.width,
                child: cartList(size),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
