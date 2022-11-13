# Discoverable Apex Services

A pattern to dynamically discover implementations for a given interface and strategy. Typically, Custom Metadata or Factory classes are used to store the mappings between a strategy and implementation for a given interface. Thanks to `ApexTypeImplementor (beta)` we can let the implementations themselves announce the strategies they can handle thus making them discoverable.
