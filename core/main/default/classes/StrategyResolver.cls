/************************************************************

*** @author Suraj Pillai
*** @date 11/2022
*** @description Given an interface and a strategy, get the implementation that can handle the strategy. Relies on the implementations being discoverable by declaring the strategy they can handle.
*** 
**/
public with sharing class StrategyResolver {
  private static Map<Type, Map<String, IDiscoverable>> intfToImplMap = new Map<Type, Map<String, IDiscoverable>>();
  private static ApexTypeImplementorSelector implSelector = ApexTypeImplementorSelector.getInstance();
  private static List<Id> discoverableClassIds = getAllDiscoverables();

  public static Object getImplementationForStrategy(
    Type intfcType,
    String strategy
  ) {
    if (!intfToImplMap.containsKey(intfcType)) {
      initMapForIntf(intfcType);
    }
    return intfToImplMap.get(intfcType).get(strategy);
  }

  private static void initMapForIntf(Type intfcType) {
    String fullIntfName = intfcType.getName();
    String intfcNameStr, intfcNamespace;
    Map<String, IDiscoverable> stratToImplMap = new Map<String, IDiscoverable>();
    if (fullIntfName.indexOf('__') == -1) {
      intfcNameStr = fullIntfName;
      intfcNamespace = null;
    } else {
      intfcNamespace = fullIntfName.substringBefore('__');
      intfcNameStr = fullIntfName.substringAfter('__');
    }
    for (
      ApexTypeImplementor impl : implSelector.getImplementorsForInterface(
        intfcNameStr,
        intfcNamespace,
        discoverableClassIds
      )
    ) {
      IDiscoverable discoverableImpl = (IDiscoverable) Type.forName(
          impl.ClassNamespacePrefix,
          impl.ClassName
        )
        .newInstance();
      stratToImplMap.put(discoverableImpl.getStrategy(), discoverableImpl);
    }
    intfToImplMap.put(intfcType, stratToImplMap);
  }

  private static List<Id> getAllDiscoverables() {
    List<Id> classIds = new List<Id>();
    for (
      ApexTypeImplementor impl : implSelector.getImplementorsForInterface(
        'IDiscoverable',
        null
      )
    ) {
      classIds.add(impl.ApexClassId);
    }
    return classIds;
  }
}
