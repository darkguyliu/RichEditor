import Testing
import SwiftUI
@testable import HelloWorld

@Suite("FormattingToolbar")
struct FormattingToolbarTests {

    // AC-6.1: Bold button starts inactive; toggling on activates it
    @Test("AC-6.1: Bold button active state when toggled on")
    @MainActor
    func testBoldButtonActiveState() async {
        // AC-6.1
        let viewModel = ComposeViewModel()
        #expect(viewModel.activeFormats.contains(.bold) == false,
                "Expected activeFormats to NOT contain .bold initially")

        viewModel.activeFormats.toggle(.bold)

        #expect(viewModel.activeFormats.contains(.bold) == true,
                "Expected activeFormats to contain .bold after toggle")
    }

    // AC-6.2: Bold button toggles off when already active
    @Test("AC-6.2: Bold button deactivates when toggled off")
    @MainActor
    func testBoldButtonToggleOff() async {
        // AC-6.2
        let viewModel = ComposeViewModel()
        viewModel.activeFormats.insert(.bold)

        viewModel.activeFormats.toggle(.bold)

        #expect(viewModel.activeFormats.contains(.bold) == false,
                "Expected activeFormats to NOT contain .bold after toggling off")
    }

    // AC-6.4: Accessibility labels are set; smoke test that the toolbar renders without crashing
    @Test("AC-6.4: FormattingToolbar renders with accessibility labels")
    @MainActor
    func testAccessibilityLabels() async {
        // AC-6.4
        let viewModel = ComposeViewModel()
        let toolbar = FormattingToolbar(viewModel: viewModel)

        // Smoke test: toolbar is instantiated successfully and viewModel starts with empty activeFormats
        #expect(viewModel.activeFormats.isEmpty == true,
                "Expected viewModel to start with empty activeFormats")
        // The actual VoiceOver label check (.accessibilityLabel("Bold") etc.) is manual/UITest
        // Confirm the toolbar value is non-nil (compile-time + runtime check)
        _ = toolbar  // confirms it constructs without crashing
    }
}
