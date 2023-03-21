@IsTest
private class StrategyResolverTest {
  @IsTest
  private static void itShouldResolveImplForGivenStrategy() {
    String stripeStrategy = 'Stripe';
    /* ApexTypeImplementorSelector.instance = (ApexTypeImplementorSelector) uMock.createStub(); */
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
