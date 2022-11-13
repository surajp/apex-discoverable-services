@IsTest
public with sharing class StrategyResolverTest {
  private static Apextypeimplementor createMockImpl(
    String className,
    String classNamespacePrefix
  ) {
    Map<String, String> propMap = new Map<String, String>();
    propMap.put('ClassName', className);
    propMap.put('ClassNamespacePrefix', classNamespacePrefix);
    return (ApexTypeImplementor) JSON.deserialize(
      JSON.serialize(propMap),
      ApexTypeImplementor.class
    );
  }

  @IsTest
  private static void itShouldResolveImplForGivenStrategyInner() {
    UniversalMocker uMock = UniversalMocker.mock(
      ApexTypeImplementorSelector.class
    );
    List<ApexTypeImplementor> implList = new List<ApexTypeImplementor>();
    implList.add(
      createMockImpl('StrategyResolvTestHelper.StripeProvider', null)
    );
    implList.add(
      createMockImpl('StrategyResolvTestHelper.PaypalProvider', null)
    );
    uMock.when('getImplementorsForInterface').thenReturn(implList);
    ApexTypeImplementorSelector.instance = (ApexTypeImplementorSelector) uMock.createStub();
    String stripeStrategy = 'Stripe';
    StrategyResolvTestHelper.IPaymentProvider impl = (StrategyResolvTestHelper.IPaymentProvider) StrategyResolver.getImplementationForStrategy(
      StrategyResolvTestHelper.IPaymentProvider.class,
      stripeStrategy
    );
    System.assertEquals(
      'Processed by Stripe',
      impl.processPayment(),
      'Expected payment provider to be Stripe'
    );
  }

  @IsTest
  private static void itShouldResolveImplForGivenStrategy() {
    String fedexStrategy = 'Fedex';
    IShipmentProvider impl = (IShipmentProvider) StrategyResolver.getImplementationForStrategy(
      IShipmentProvider.class,
      fedexStrategy
    );
    System.assertEquals(
      'Shipped via Fedex',
      impl.shipAndGetConfirmation(''),
      'Expected shipment provider to be Fedex'
    );
  }

  @IsTest
  private static void noDuplicateImplementations() {
    Set<String> strategies = new Set<String>();
    for (ApexTypeImplementor impl : [
      SELECT ClassName, ClassNamespacePrefix
      FROM ApexTypeImplementor
      WHERE InterfaceName = 'IDiscoverable'
    ]) {
      IDiscoverable disc = (IDiscoverable) Type.forName(
          impl.ClassNamespacePrefix,
          impl.ClassName
        )
        .newInstance();
      String currStrat = disc.getStrategy();
      System.assert(
        !strategies.contains(currStrat),
        'Strategy ' +
        currStrat +
        ' has been multiple implementations'
      );
      strategies.add(disc.getStrategy());
    }
  }
}
