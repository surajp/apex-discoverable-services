public with sharing class ApexTypeImplementorSelector {
  @TestVisible
  private static ApexTypeImplementorSelector instance = null;

  public static ApexTypeImplementorSelector getInstance() {
    if (instance == null) {
      instance = new ApexTypeImplementorSelector();
    }
    return instance;
  }

  public List<ApexTypeImplementor> getImplementorsForInterface(
    String intfcName,
    String intfcNamespace
  ) {
    return [
      SELECT ApexClassId
      FROM ApexTypeImplementor
      WHERE
        InterfaceName = :intfcName
        AND InterfaceNamespacePrefix = :intfcNamespace
    ];
  }

  /****
   ** Given a list of class ids, return the Apextypeimplementor records for classes that implement a given interface
   ** @param intfcName Name of the interface
   ** @param intfcNamespace Namespace prefix of the interface
   ** @param classIds List of class ids to be filtered based on the given interface name
   ** @return list of ApexTypeImplementor records for the given class ids that implement the given interface
   **/
  public List<ApexTypeImplementor> getImplementorsForInterface(
    String intfcName,
    String intfcNamespace,
    List<Id> classIds
  ) {
    return [
      SELECT ClassName, ClassNamespacePrefix
      FROM ApexTypeImplementor
      WHERE
        InterfaceName = :intfcName
        AND InterfaceNamespacePrefix = :intfcNamespace
        AND IsConcrete = TRUE
        AND ApexClassId IN :classIds
    ];
  }
}
