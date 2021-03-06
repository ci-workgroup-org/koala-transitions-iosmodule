import Foundation

#if canImport(Darwin) && !SWIFT_PACKAGE
    @objcMembers
    public class _ExampleMetadataBase: NSObject {}
#else
    public class _ExampleMetadataBase: NSObject {}
#endif

/**
 A class that encapsulates information about an example,
 including the index at which the example was executed, as
 well as the example itself.
 */
public final class ExampleMetadata: _ExampleMetadataBase {
    /**
     The example for which this metadata was collected.
     */
    public let example: Example

    /**
     The index at which this example was executed in the
     test suite.
     */
    public let exampleIndex: Int

    internal init(example: Example, exampleIndex: Int) {
        self.example = example
        self.exampleIndex = exampleIndex
    }
}
