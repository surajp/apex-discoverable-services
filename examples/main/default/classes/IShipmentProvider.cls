public interface IShipmentProvider extends IDiscoverable {
  String shipAndGetConfirmation(String orderNumber);
}
