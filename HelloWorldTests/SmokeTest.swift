import Testing

// AC-1.1: HelloWorld and HelloWorldTests targets build with zero errors
// (Build-time verification — confirmed when this file compiles successfully)

// AC-1.2: Swift Testing smoke test passes
@Test("AC-1.2: Swift Testing smoke test")
func smokeTestPasses() {
    #expect(true)
}
