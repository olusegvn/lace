import 'dart:convert';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;

class StripeTransactionResponse{
  String message;
  bool success;
  StripeTransactionResponse({this.message, this.success});
}

class StripeService{
  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
  static String secret = 'sk_test_ZRcqo5lLbEAMY7L51HJgjgmR00HZqQuD9b';
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeService.secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  static init(){
    StripePayment.setOptions(
        StripeOptions(publishableKey: "pk_test_tlXVPY7xcTJQ0JbssvqOVI9i00UPWoO8zm", merchantId: "Test", androidPayMode: 'test'));
  }

  static Future<StripeTransactionResponse> payViaExistingCard({String amount, String currency, CreditCard card}) async{
    try{
      var paymentMethod = await StripePayment.createPaymentMethod(
        PaymentMethodRequest(card: card)
      );

      var paymentIntent = await StripeService.createPaymentIntent(amount, currency);
      var response = await StripePayment.confirmPaymentIntent(
          PaymentIntent(
              clientSecret: paymentIntent['client_secret'],
              paymentMethodId: paymentMethod.id
          )
      );
      if(response.status == 'succeeded'){
        return new StripeTransactionResponse(
          message: 'Success',
          success: true,
        );
      }
    } catch (err){
      print(err.toString());
      return new StripeTransactionResponse(
          message: "Transaction Failed: ${err.toString()}",
          success: false
      );
    }

  }

  static Future<StripeTransactionResponse> payWithNewCard({String amount, String currency}) async{

    try{
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest()
      );

      var paymentIntent = await StripeService.createPaymentIntent(amount, currency);
      var response = await StripePayment.confirmPaymentIntent(
          PaymentIntent(
            clientSecret: paymentIntent['client_secret'],
            paymentMethodId: paymentMethod.id
          )
      );
      if(response.status == 'succeeded'){
      return new StripeTransactionResponse(
        message: 'Success',
        success: true,
      );
    }
    } catch (err){
      return new StripeTransactionResponse(
        message: "Transaction Failed: ${err.toString()}",
        success: false
      );
    }

  }

  static createPaymentIntent(String amount, String currency) async{
    print(amount);
    try{
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
        StripeService.paymentApiUrl,
        body: body,
        headers: StripeService.headers
      );
      return jsonDecode(response.body);
    }catch(err){
      return null;
    }
  }
}