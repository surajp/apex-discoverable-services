@IsTest
private class StrategyResolverTest {
  private static ApextypeImplementor createMockImpl(
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
  private static void itShouldResolveImplForGivenStrategy() {
    String stripeProviderClassName = 'StrategyResolvTestHelper.StripeProvider';
    String paypalProviderClassName = 'StrategyResolvTestHelper.PaypalProvider';
    String methodName = 'getImplementorsForInterface';
    String stripeStrategy = 'Stripe';
    UniversalMocker uMock = UniversalMocker.mock(
      ApexTypeImplementorSelector.class
    );
    List<ApexTypeImplementor> implList = new List<ApexTypeImplementor>();
    implList.add(createMockImpl(stripeProviderClassName, null));
    implList.add(createMockImpl(paypalProviderClassName, null));
    uMock.when(methodName).thenReturn(implList);
    ApexTypeImplementorSelector.instance = (ApexTypeImplementorSelector) uMock.createStub();
    StrategyResolvTestHelper.IPaymentProvider impl = (StrategyResolvTestHelper.IPaymentProvider) StrategyResolver.getImplementationForStrategy(
      StrategyResolvTestHelper.IPaymentProvider.class,
      stripeStrategy
    );
    System.assertEquals(
      new StrategyResolvTestHelper.StripeProvider().processPayment(),
      impl.processPayment(),
      'Expected payment provider to be Stripe'
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
