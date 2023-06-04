import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../data/boxes.dart';
import '../../generated/l10n.dart';
import '../../models/index.dart' show Address, CartModel, User, UserModel;
import '../../services/index.dart';
import '../index.dart' show BaseScreen;
import 'address_form_screen.dart';

class ManageAddressScreen extends StatefulWidget {
  final void Function(Address?)? callback;

  const ManageAddressScreen({this.callback});

  @override
  BaseScreen<ManageAddressScreen> createState() => _StateChooseAddress();
}

class _StateChooseAddress extends BaseScreen<ManageAddressScreen> {
  List<Address?> listAddress = [];
  User? user;
  bool isLoading = false;
  Address? address;
  int? selectedAddressIndex;


  @override
  void initState() {
    getDataFromLocal();
    // print('local address ============================================= ${SettingsBox().addresses}');
    WidgetsBinding.instance.endOfFrame.then(
            (_) async {
              /// Load saved addresses.
              final addressValue =
              await Provider.of<CartModel>(context, listen: false).getAddress();
              if (addressValue != null) {
                address=addressValue;
                detectSelected();
              }
            });
    super.initState();
  }

  int? detectSelected() {
    if (listAddress.isNotEmpty) {
      for (var index=0;index<listAddress.length;index++) {
        var local = listAddress[index];
        final isExistInLocal = local!.city ==
            address?.city &&
            local.street == address?.street &&
            local.state == address?.state;
        // print('is address exist ==================================== ${isExistInLocal}');
        if (isExistInLocal) {
          setState(() {
            selectedAddressIndex = index;
          });
        }
      }
    }
    // print(
    //     'selected address index ========================================= ${selectedAddressIndex}');
    return selectedAddressIndex;
  }

  // @override
  // void afterFirstLayout(BuildContext context) {
  //   getDataFromLocal();
  //   final loggedIn = Provider.of<UserModel>(context, listen: false).loggedIn;
  //   if (loggedIn) {
  //     getUserInfo().then((_) async {
  //       // await getDataFromNetwork();
  //       if (mounted) {
  //         setState(() {
  //           isLoading = false;
  //         });
  //       }
  //     });
  //   } else {
  //     if (mounted) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   }
  // }

  // Future<void> getUserInfo() async {
  //   final localUser = UserBox().userInfo;
  //   if (localUser != null) {
  //     final user = await Services().api.getUserInfo(localUser.cookie);
  //     if (user != null) {
  //       user.isSocial = localUser.isSocial ?? false;
  //       setState(() {
  //         this.user = user;
  //       });
  //     }
  //   }
  // }

  void getDataFromLocal() {
    var list = List<Address>.from(SettingsBox().addresses ?? <Address>[]);
    listAddress = list;
    setState(() {});
  }

  // Future<void> getDataFromNetwork() async {
  //   try {
  //     var result = await Services().api.getCustomerInfo(user!.id)!;
  //
  //     if (result['billing'] != null) {
  //       listAddress.add(result['billing']);
  //     }
  //   } catch (err) {
  //     printLog(err);
  //   }
  // }

  void removeData(int index) {
    var data = SettingsBox().addresses;
    if (data != null) {
      data.removeAt(index);
      SettingsBox().addresses = data;
    }
    getDataFromLocal();
  }

  Widget convertToCard(BuildContext context, Address address) {
    final s = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 10.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${s.streetName}:  ',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            Flexible(
              child: Column(
                children: <Widget>[Text(address.street.toString())],
              ),
            )
          ],
        ),
        const SizedBox(height: 4.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${s.city}:  ',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            Flexible(
              child: Column(
                children: <Widget>[Text(address.city.toString())],
              ),
            )
          ],
        ),
        const SizedBox(height: 4.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${s.stateProvince}:  ',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            Flexible(
              child: Column(
                children: <Widget>[Text(address.state.toString())],
              ),
            )
          ],
        ),
        const SizedBox(height: 4.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${s.country}:  ',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            Flexible(
              child: Column(
                children: <Widget>[Text(address.country.toString())],
              ),
            )
          ],
        ),
        // const SizedBox(height: 4.0),
        // Row(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: <Widget>[
        //     Text(
        //       '${s.zipCode}:  ',
        //       style: TextStyle(color: Theme.of(context).primaryColor),
        //     ),
        //     Flexible(
        //       child: Column(
        //         children: <Widget>[Text(address.zipCode.toString())],
        //       ),
        //     )
        //   ],
        // ),
        const SizedBox(height: 10.0),
      ],
    );
  }

  // Widget _renderBillingAddress() {
  //   if (user == null || user!.billing == null) {
  //     return const SizedBox();
  //   }
  //   final userFullName =
  //   '${user!.billing!.firstName ?? ''} ${user!.billing!.lastName ?? ''}'
  //       .trim();
  //   return GestureDetector(
  //     onTap: () {
  //       final add = Address(
  //           firstName: (user!.billing!.firstName?.isNotEmpty ?? false)
  //               ? user!.billing!.firstName
  //               : user!.firstName,
  //           lastName: (user!.billing!.lastName?.isNotEmpty ?? false)
  //               ? user!.billing!.lastName
  //               : user!.lastName,
  //           email: (user!.billing!.email?.isNotEmpty ?? false)
  //               ? user!.billing!.email
  //               : user!.email,
  //           street: user!.billing!.address1,
  //           country: user!.billing!.country,
  //           state: user!.billing!.state,
  //           phoneNumber: user!.billing!.phone,
  //           city: user!.billing!.city,
  //           zipCode: user!.billing!.postCode);
  //       Provider.of<CartModel>(context, listen: false).setAddress(add);
  //       Navigator.of(context).pop();
  //       // widget.callback(add);
  //     },
  //     child: Container(
  //       decoration: BoxDecoration(
  //           color: Theme.of(context).primaryColorLight,
  //           borderRadius: BorderRadius.circular(10)),
  //       width: MediaQuery.of(context).size.width,
  //       padding: const EdgeInsets.all(15),
  //       margin: const EdgeInsets.all(10),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: <Widget>[
  //           Text(
  //             S.of(context).billingAddress,
  //             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
  //           ),
  //           const SizedBox(height: 10),
  //           Text(userFullName),
  //           Text(user!.billing!.phone ?? ''),
  //           Text(user!.billing!.email ?? ''),
  //           Text(user!.billing!.address1 ?? ''),
  //           Text(user!.billing!.city ?? ''),
  //           Text(user!.billing!.postCode ?? '')
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _renderShippingAddress() {
  //   if (user == null || user!.shipping == null) return const SizedBox();
  //   final userFullName =
  //   '${user!.billing!.firstName ?? ''} ${user!.billing!.lastName ?? ''}'
  //       .trim();
  //   return GestureDetector(
  //     onTap: () {
  //       final add = Address(
  //         firstName: (user!.shipping!.firstName?.isNotEmpty ?? false)
  //             ? user!.shipping!.firstName
  //             : user!.firstName,
  //         lastName: (user!.shipping!.lastName?.isNotEmpty ?? false)
  //             ? user!.shipping!.lastName
  //             : user!.lastName,
  //         email: user!.email,
  //         street: user!.shipping!.address1,
  //         country: user!.shipping!.country,
  //         state: user!.shipping!.state,
  //         city: user!.shipping!.city,
  //         zipCode: user!.shipping!.postCode,
  //         phoneNumber: user!.shipping!.phone,
  //       );
  //       Provider.of<CartModel>(context, listen: false).setAddress(add);
  //       Navigator.of(context).pop();
  //       // widget.callback(add);
  //     },
  //     child: Container(
  //       decoration: BoxDecoration(
  //           color: Theme.of(context).primaryColorLight,
  //           borderRadius: BorderRadius.circular(10)),
  //       width: MediaQuery.of(context).size.width,
  //       padding: const EdgeInsets.all(15),
  //       margin: const EdgeInsets.all(10),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: <Widget>[
  //           Text(
  //             S.of(context).shippingAddress,
  //             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
  //           ),
  //           const SizedBox(height: 10),
  //           Text(userFullName),
  //           Text(user!.shipping!.address1 ?? ''),
  //           Text(user!.shipping!.city ?? ''),
  //           Text(user!.shipping!.postCode ?? '')
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // print(
    //     'selected address index inside widget ========================================= ${selectedAddressIndex}');
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorLight,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          // S.of(context).selectAddress,
          'Direcciones',
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context, rootNavigator: true).pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>
                  const AddressFormScreen(isFromEdit: false,),
                ),
              );
            },
            child: Icon(
              Icons.add,
              size: 35,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(width: 30),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // _renderBillingAddress(),
            // _renderShippingAddress(),
            Column(
              children: [
                if (listAddress.isEmpty && !isLoading)
                  Center(
                    child: Image.asset(
                      kEmptySearch,
                      width: 120,
                      height: 120,
                    ),
                  ),
                if (listAddress.isEmpty && isLoading)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: kLoadingWidget(context),
                  ),
                ...List.generate(listAddress.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: GestureDetector(
                        onTap: () {
                          Provider.of<CartModel>(context, listen: false)
                              .setAddress(listAddress[index]);
                          Navigator.of(context).pop();
                          // widget.callback(listAddress[index]);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              // color: Theme.of(context).primaryColorLight
                              color: selectedAddressIndex==index?Theme.of(context).primaryColorDark.withOpacity(0.1):Theme.of(context).primaryColorLight
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Icon(
                                    Icons.home,
                                    color: Theme.of(context).primaryColor,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: convertToCard(
                                      context, listAddress[index]!),
                                ),
                                const SizedBox(width: 10,),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context, rootNavigator: true).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                        AddressFormScreen(isFromEdit: true,editAddressIndex: index,),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Icon(
                                      Icons.edit,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    removeData(index);
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                })
              ],
            ),
          ],
        ),
      ),
    );
  }
}
