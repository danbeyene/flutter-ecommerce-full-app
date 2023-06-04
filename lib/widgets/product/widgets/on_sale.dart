import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';

import '../../../common/tools.dart';
import '../../../data/boxes.dart';
import '../../../generated/l10n.dart';
import '../../../models/index.dart' show Product;
import '../../../modules/dynamic_layout/config/product_config.dart';

class ProductOnSale extends StatelessWidget {
  final Product product;
  final ProductConfig config;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BoxDecoration? decoration;

  const ProductOnSale({
    Key? key,
    required this.product,
    required this.config,
    this.padding,
    this.margin,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isSale = (product.onSale ?? false) &&
        PriceTools.getPriceProductValue(product, onSale: true) !=
            PriceTools.getPriceProductValue(product, onSale: false);
    double? regularPrice = 0.0;
    var salePercent = 0;

    var salesPrice = isSale? product.salePrice: null;
    var normalPrice = isNotBlank(product.price)? product.price : product.regularPrice;
    var regularrPrice = product.regularPrice != null &&
        product.regularPrice!.isNotEmpty &&
        product.regularPrice != '0.0'? product.regularPrice : null;

    var userRoles = UserBox().userRole;
    var metaData=product.metaData;

    // if(userRoles!=null){
    //   for(var data in metaData){
    //     if(data['key']=='festiUserRolePrices'){
    //       // print('this is discount value ====================== ${jsonDecode(data['value'])}');
    //       // print('this is user roles ====================== ${userRoles}');
    //       Map discountMapValue = jsonDecode(data['value']);
    //       for(var role in userRoles){
    //         if(role == 'vendedor'){
    //           var regularDiscountPrice = discountMapValue['vendedor'];
    //           var salesDiscountPrice;
    //           if(discountMapValue['salePrice'] !=null){
    //             salesDiscountPrice = discountMapValue['salePrice']['vendedor'];
    //             salesPrice=salesDiscountPrice;
    //           }
    //           normalPrice=regularDiscountPrice;
    //           regularrPrice=regularDiscountPrice;
    //           // print('detail ======== this is vendedor sales price ====================== ${salesPrice}');
    //           // print('detail ======== this is vendedor normal price ====================== ${normalPrice}');
    //           // print('detail ======== this is vendedor regular price ====================== ${regularrPrice}');
    //         }else if(role == 'minimarket'){
    //           var regularDiscountPrice = discountMapValue['minimarket'];
    //           var salesDiscountPrice;
    //           if(discountMapValue['salePrice'] !=null){
    //             salesDiscountPrice = discountMapValue['salePrice']['minimarket'];
    //             salesPrice=salesDiscountPrice;
    //           }
    //           normalPrice=regularDiscountPrice;
    //           regularrPrice=regularDiscountPrice;
    //           // print('detail ========  this is minimarket sales price ====================== ${salesPrice}');
    //           // print('detail ========  this is minimarket normal price ====================== ${normalPrice}');
    //           // print('detail ========  this is minimarket regular price ====================== ${regularrPrice}');
    //         }
    //       }
    //     }
    //   }
    // }

    regularPrice =(double.tryParse(regularrPrice.toString()));

    /// Calculate the Sale price
    if (isSale && regularPrice != 0) {
      salePercent = (double.parse(salesPrice!) - regularPrice!) * 100 ~/ regularPrice;
    }

    if (isSale &&
        (regularrPrice?.isNotEmpty ?? false) &&
        regularPrice != null &&
        regularPrice != 0.0 &&
        product.type != 'variable') {
      return Container(
        margin: margin ??
            EdgeInsets.symmetric(
              horizontal: config.hMargin,
              vertical: config.vMargin / 2,
            ),
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: decoration ?? _getSaleDecoration(context, borderRadius: config.borderRadius),
        child: Text(
          '$salePercent%',
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              )
              .apply(fontSizeFactor: 0.9),
        ),
      );
    }

    if (isSale && product.isVariableProduct) {
      return Align(
        alignment: context.isRtl ? Alignment.topRight : Alignment.topLeft,
        child: Container(
          margin: margin ??
              EdgeInsets.symmetric(
                horizontal: config.hMargin,
                vertical: config.vMargin / 2,
              ),
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: _getSaleDecoration(context, borderRadius: config.borderRadius),
          child: Text(
            S.of(context).onSale,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
      );
    }

    return const SizedBox();
  }
}

BoxDecoration _getSaleDecoration(BuildContext context, {double? borderRadius = 0.0}) =>
    BoxDecoration(
      color: Colors.redAccent,
      borderRadius: BorderRadius.only(
        topLeft: context.isRtl ? Radius.zero : Radius.circular(borderRadius ?? 0.0),
        topRight: context.isRtl ? Radius.circular(borderRadius ?? 0.0) : Radius.zero,
        bottomRight: context.isRtl ? Radius.zero : const Radius.circular(12),
        bottomLeft: context.isRtl ? const Radius.circular(12) : Radius.zero,
      ),
    );
