import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:quiver/strings.dart';

import '../../data/boxes.dart';
import '../../models/entities/currency.dart';
import '../../models/index.dart' show AddonsOption, Product, User;
import '../config.dart' show kAdvanceConfig;
import '../constants.dart' show printError;

class PriceTools {
  static String? getAddsOnPriceProductValue(
    Product product,
    List<AddonsOption> selectedOptions,
    Map<String, dynamic> rates,
    String? currency, {
    bool? onSale,
  }) {

    var salesPrice = product.salePrice;
    var normalPrice = product.price;

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
    //           // print('detail ======== this is vendedor sales price ====================== ${salesPrice}');
    //           // print('detail ======== this is vendedor normal price ====================== ${normalPrice}');
    //         }else if(role == 'minimarket'){
    //           var regularDiscountPrice = discountMapValue['minimarket'];
    //           var salesDiscountPrice;
    //           if(discountMapValue['salePrice'] !=null){
    //             salesDiscountPrice = discountMapValue['salePrice']['minimarket'];
    //             salesPrice=salesDiscountPrice;
    //           }
    //           normalPrice=regularDiscountPrice;
    //           // print('detail ========  this is minimarket sales price ====================== ${salesPrice}');
    //           // print('detail ========  this is minimarket normal price ====================== ${normalPrice}');
    //         }
    //       }
    //     }
    //   }
    // }

    var price = double.tryParse(onSale == true
        ? (isNotBlank(salesPrice)
        ? salesPrice!
        : normalPrice!)
        : normalPrice!) ??
        0.0;
    price += selectedOptions
        .map((e) => double.tryParse(e.price ?? '0.0') ?? 0.0)
        .reduce((a, b) => a + b);

    return getCurrencyFormatted(price, rates, currency: currency);
  }

  static String? getVariantPriceProductValue(
    product,
    Map<String, dynamic> rates,
    String? currency, {
    bool? onSale,
    List<AddonsOption>? selectedOptions,
  }) {
    var salesPrice = product.salePrice;
    var normalPrice = product.price;

    var userRoles = UserBox().userRole;
    var metaData=product?.metaData;
    // if(metaData!=null && userRoles!=null){
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
    //           // print('detail ======== this is vendedor sales price ====================== ${salesPrice}');
    //           // print('detail ======== this is vendedor normal price ====================== ${normalPrice}');
    //         }else if(role == 'minimarket'){
    //           var regularDiscountPrice = discountMapValue['minimarket'];
    //           var salesDiscountPrice;
    //           if(discountMapValue['salePrice'] !=null){
    //             salesDiscountPrice = discountMapValue['salePrice']['minimarket'];
    //             salesPrice=salesDiscountPrice;
    //           }
    //           normalPrice=regularDiscountPrice;
    //           // print('detail ========  this is minimarket sales price ====================== ${salesPrice}');
    //           // print('detail ========  this is minimarket normal price ====================== ${normalPrice}');
    //         }
    //       }
    //     }
    //   }
    // }

    var price = double.tryParse(
            '${onSale == true ? (isNotBlank(salesPrice) ? salesPrice : normalPrice) : normalPrice}') ??
        0.0;
    if (selectedOptions != null && selectedOptions.isNotEmpty) {
      price += selectedOptions
          .map((e) => double.tryParse(e.price ?? '0.0') ?? 0.0)
          .reduce((a, b) => a + b);
    }
    return getCurrencyFormatted(price, rates, currency: currency);
  }

  static String? getPriceProductValue(Product? product, {bool? onSale}) {
    try {

      var salesPrice = product?.salePrice;
      var normalPrice = product?.price;
      var regularrPrice = product?.regularPrice;

      var userRoles = UserBox().userRole;
      var metaData=product?.metaData;
      // if(metaData!=null && userRoles!=null){
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

      var price = onSale == true
          ? (isNotBlank(salesPrice)
          ? salesPrice ?? '0'
          : normalPrice)
          : (isNotBlank(regularrPrice)
          ? regularrPrice ?? '0'
          : normalPrice);
      // var price = onSale == true
      //     ? (isNotBlank(product!.salePrice)
      //         ? product.salePrice ?? '0'
      //         : product.price)
      //     : (isNotBlank(product!.regularPrice)
      //         ? product.regularPrice ?? '0'
      //         : product.price);
      return price;
    } catch (err, trace) {
      printError(err, trace);
      return '';
    }
  }

  static String? getPriceProduct(
      product, Map<String, dynamic>? rates, String? currency,
      {bool? onSale}) {
    var price = getPriceProductValue(product, onSale: onSale);

    if (price == null || price == '') {
      return '';
    }
    return getCurrencyFormatted(price, rates, currency: currency);
  }

  static String? getCurrencyFormatted(price, Map<String, dynamic>? rates,
      {currency}) {
    if (kAdvanceConfig.defaultCurrency == null) {
      return double.tryParse('$price')?.toStringAsFixed(1);
    }

    var defaultCurrency =
        kAdvanceConfig.defaultCurrency ?? Currency.fromJson({});

    var currencies = kAdvanceConfig.currencies;
    var formatCurrency = NumberFormat.currency(
      // locale: kAdvanceConfig.defaultLanguage,
      locale: 'en_US',
      name: '',
      decimalDigits: defaultCurrency.decimalDigits,
    );

    try {
      if (currency != null && currencies.isNotEmpty) {
        for (var item in currencies) {
          if (item.currencyCode == currency ||
              item.currencyDisplay == currency) {
            defaultCurrency = item;
            formatCurrency = NumberFormat.currency(
              // locale: kAdvanceConfig.defaultLanguage,
              locale: 'en_US',
              name: '',
              decimalDigits: defaultCurrency.decimalDigits,
            );
            break;
          }
        }
      }

      if (rates != null && rates[defaultCurrency.currencyCode] != null) {
        price = getPriceValueByCurrency(
          price,
          defaultCurrency.currencyCode,
          rates,
        );
      }

      String? number = '';
      if (price == null) {
        number = '';
      } else if (price is String) {
        final newString = price.replaceAll(RegExp('[^\\d.,]+'), '');
        number = formatCurrency
            .format(newString.isNotEmpty ? double.parse(newString) : 0);
      } else {
        number = formatCurrency.format(price);
      }

      return defaultCurrency.symbolBeforeTheNumber
          ? defaultCurrency.symbol + number
          : number + defaultCurrency.symbol;
    } catch (err, trace) {
      printError(err, trace);
      return defaultCurrency.symbolBeforeTheNumber
          ? defaultCurrency.symbol + formatCurrency.format(0)
          : formatCurrency.format(0) + defaultCurrency.symbol;
    }
  }

  static double? getPriceByRate(price, Map<String, dynamic>? rates,
      {currency}) {
    if (kAdvanceConfig.defaultCurrency == null) {
      return price;
    }

    var defaultCurrency =
        kAdvanceConfig.defaultCurrency ?? Currency.fromJson({});

    var currencies = kAdvanceConfig.currencies;

    try {
      if (currency != null && currencies.isNotEmpty) {
        for (var item in currencies) {
          if (item.currencyCode == currency ||
              item.currencyDisplay == currency) {
            defaultCurrency = item;
            break;
          }
        }
      }

      if (rates != null && rates[defaultCurrency.currencyCode] != null) {
        price = getPriceValueByCurrency(
          price,
          defaultCurrency.currencyCode,
          rates,
        );
      }

      if (price == null) {
        return 0;
      } else {
        return price;
      }
    } catch (err, trace) {
      printError(err, trace);
      return price;
    }
  }

  static double getPriceValueByCurrency(
      price, String currency, Map<String, dynamic> rates) {
    final currencyVal = currency.toUpperCase();
    double rate = rates[currencyVal] ?? 1.0;

    if (price == '' || price == null) {
      return 0;
    }
    return double.parse(price.toString()) * rate;
  }
}
