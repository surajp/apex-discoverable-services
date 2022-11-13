public with sharing class UPSShipmentProvider implements IShipmentProvider {
  public String getStrategy() {
    return 'UPS';
  }

  public String shipAndGetConfirmation(String orderNumber) {
    return 'Shipped via UPS';
  }
}
