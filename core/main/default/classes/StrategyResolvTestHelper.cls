@IsTest
public with sharing class StrategyResolvTestHelper {
  public interface IPaymentProvider extends IDiscoverable {
    String processPayment();
  }

  public class StripeProvider implements IPaymentProvider {
    public String processPayment() {
      return 'Processed by Stripe';
    }

    public String getStrategy() {
      return 'Stripe';
    }
  }

  public class PaypalProvider implements IPaymentProvider {
    public String processPayment() {
      return 'Processed by Paypal';
    }

    public String getStrategy() {
      return 'Paypal';
    }
  }
}
