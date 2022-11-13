public with sharing class FedexShipmentProvider implements IShipmentProvider {
  public String getStrategy() {
    return 'Fedex';
  }

  public String shipAndGetConfirmation(String orderNumber) {
    return 'Shipped via Fedex';
  }
}
