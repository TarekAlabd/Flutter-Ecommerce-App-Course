# Feature Specification: Dark Mode Toggle

**Feature Branch**: `001-dark-mode-toggle`  
**Created**: 2026-05-10  
**Status**: Draft  

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Toggle Theme Instantly (Priority: P1)

A user is browsing the app in the default light theme. They open the Profile page and see a clearly labeled dark mode switch. Tapping it switches the entire app — every screen, card, button, and background — to dark mode immediately, with no loading delay or visual flash.

**Why this priority**: This is the core feature deliverable. Without this, nothing else matters. It delivers immediate, visible value to users and is the primary interaction point for the feature.

**Independent Test**: Can be fully tested by navigating to Profile, tapping the toggle, and verifying the visual change propagates across all app screens. Delivers the complete dark mode experience.

**Acceptance Scenarios**:

1. **Given** the app is in light mode, **When** the user taps the dark mode toggle on the Profile page, **Then** the entire app immediately switches to dark mode with no loading delay.
2. **Given** the app is in dark mode, **When** the user taps the toggle again, **Then** the entire app immediately returns to light mode.
3. **Given** the toggle is visible on Profile, **When** the user views it, **Then** a clear icon (sun for light / moon for dark) indicates the current state.

---

### User Story 2 - Preference Persists Across Restarts (Priority: P2)

A user enables dark mode and closes the app. When they reopen the app, it starts directly in dark mode — no flash of light theme, no need to toggle again. The preference they set is remembered indefinitely.

**Why this priority**: Without persistence, the toggle is a session-only cosmetic — users would need to re-enable it every launch. Persistence is what makes the feature genuinely useful.

**Independent Test**: Can be tested by enabling dark mode, force-closing the app, relaunching, and verifying dark mode is active from the very first rendered frame.

**Acceptance Scenarios**:

1. **Given** the user has enabled dark mode and closes the app, **When** they reopen the app, **Then** dark mode is active from the first frame with no visible switch from light to dark.
2. **Given** the user has never changed the theme (fresh install or cleared data), **When** they open the app, **Then** it starts in light mode by default.
3. **Given** the user enabled dark mode, closed and reopened the app multiple times, **When** they check the Profile toggle, **Then** it still shows dark mode as active.

---

### User Story 3 - Consistent Dark Visuals Across All Screens (Priority: P3)

When dark mode is active, every screen and component — home carousel, product grid, category tabs, cart, favorites, product details, checkout, location selection, payment, login, register, and profile — renders with an appropriate dark visual style: dark backgrounds, light text, adapted navigation and cards.

**Why this priority**: A partial dark mode (some screens light, some dark) would feel broken and unprofessional. Completeness is required for the feature to be shippable, but it depends on P1 and P2 being done first.

**Independent Test**: Can be tested by enabling dark mode and navigating to every screen in the app, verifying no screen renders a white/light background.

**Acceptance Scenarios**:

1. **Given** dark mode is active, **When** the user navigates to any screen (Home, Cart, Favorites, Product Details, Checkout, Location, Payment, Login, Register, Profile), **Then** all backgrounds, cards, app bars, and navigation bars render in dark colors.
2. **Given** dark mode is active, **When** the user views product images or carousel banners, **Then** images display unchanged (not tinted or filtered).
3. **Given** dark mode is active, **When** the user views text and icons, **Then** they are legible against the dark background with sufficient contrast.

---

### Edge Cases

- What happens if local storage is unavailable or corrupted on a device? → App defaults to light mode and proceeds normally without crashing.
- What happens if the user rapidly toggles the switch many times? → Each toggle triggers an immediate full-app switch; the final state is what persists.
- What happens on first launch with no stored preference? → App defaults to light mode as specified.
- How does the bottom navigation bar behave in dark mode? → Background and icon colors adapt to the dark theme, maintaining legibility.
- What happens to status bar icon colors in dark mode? → Status bar switches to light icons so they remain visible on dark backgrounds.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST provide a toggle switch on the Profile page, positioned above the logout button, rendered as a labeled row: a sun/moon icon, a "Dark mode" text label, and a Switch widget. The row switches the app between light mode and dark mode.
- **FR-002**: The toggle MUST display the sun/moon visual indicator specified in FR-001 showing the currently active theme.
- **FR-003**: When the user activates the toggle, the entire app MUST switch themes instantly with no loading state or visual delay.
- **FR-004**: The theme preference MUST be saved to local device storage whenever the user changes it.
- **FR-005**: On app launch, the system MUST read the stored theme preference and apply it before the first frame is rendered, preventing any flash of the wrong theme.
- **FR-006**: If no stored preference exists (fresh install), the app MUST default to light mode.
- **FR-007**: All app screens — Home, Cart, Favorites, Product Details, Checkout, Choose Location, Add New Card, Login, Register, and Profile — MUST visually adapt to the active theme (dark or light).
- **FR-008**: The following UI elements MUST adapt to dark mode: scaffold backgrounds, app bars, bottom navigation bar, product cards, cart items, checkout sections, text, input fields, buttons, dialogs, snackbars, status bar icons, and dividers/borders.
- **FR-009**: Product images, carousel banners, and user avatars MUST NOT be altered or filtered by the theme change.
- **FR-010**: The primary brand color (deep purple) MUST remain recognizable in both themes, adapted for appropriate contrast.
- **FR-011**: Theme switching MUST be controlled exclusively by the in-app toggle; the device system theme setting MUST NOT influence the app's theme.
- **FR-012**: Theme preference storage MUST use local device storage only — no network calls, no Firebase/backend involvement.
- **FR-013**: The dark mode toggle MUST include accessibility semantics: a label of "Dark mode" and a programmatic toggled value ("on"/"off") so that screen readers (VoiceOver on iOS, TalkBack on Android) announce the control and its current state correctly.

### Key Entities

- **Theme Preference**: Represents the user's chosen display mode (light or dark). Has a single attribute: `isDarkMode` (boolean). Stored locally on the device. Persists across sessions.
- **Theme State**: The in-memory representation of the current active theme, managed as application-level state. Derived from the stored preference on startup; updated when the user toggles.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can switch between light and dark mode in under 1 second from tapping the toggle to full-app visual change.
- **SC-002**: The stored theme preference is applied before the first visible Flutter frame on every app launch — zero users experience a flash of the wrong theme within the app on relaunch. Note: the native platform splash screen is a known limitation and is out of scope.
- **SC-003**: 100% of app screens (10+) render correctly in dark mode with no white/light-background regressions.
- **SC-004**: All text in dark mode meets a minimum contrast ratio of 4.5:1 (normal text) and 3:1 (large text and icons) per WCAG AA. Verifiable during QA using a contrast checker tool against the defined dark theme color values.
- **SC-005**: The feature requires zero backend calls — network traffic is unchanged between a session with and without toggling dark mode.
- **SC-006**: The toggle state accurately reflects the current theme 100% of the time (no desync between toggle position and actual app theme).

## Clarifications

### Session 2026-05-10

- Q: Should adapting the native splash screen to dark mode be in scope? → A: Out of scope — SC-002 ("zero flash of wrong theme") applies to in-app frames only; the native platform splash screen is a known limitation and not covered by this feature.
- Q: Should the dark mode toggle include accessibility semantics? → A: Yes — full semantics: a label ("Dark mode") plus a programmatic toggled value ("on"/"off") so screen readers (VoiceOver, TalkBack) announce the control correctly.
- Q: What minimum contrast ratio should text in dark mode meet? → A: WCAG AA — 4.5:1 for normal text, 3:1 for large text and icons.
- Q: Should theme toggle events be tracked in analytics? → A: No — out of scope; analytics instrumentation is a separate concern and can be added independently if needed.
- Q: Where on the Profile page should the dark mode toggle be placed? → A: Above the logout button, as a labeled row (sun/moon icon + "Dark mode" label + switch widget).

## Assumptions

- All users have access to the Profile page (no role-based restrictions on the toggle).
- The device has writable local storage available for persisting the preference; edge cases where storage is unavailable result in a graceful fallback to light mode.
- `shared_preferences` (or an equivalent local key-value store already available or easily addable to the project) is used for persistence — no new major dependencies are introduced.
- The app's existing BLoC/Cubit state management infrastructure is used to manage theme state at the application level, consistent with how `AuthCubit` and `FavoriteCubit` are handled.
- Widgets currently using hardcoded colors will be updated to use theme-aware references; this is considered in-scope cleanup required for the feature.
- Animated theme transitions (e.g., circular reveal) are out of scope; the switch is instant.
- Scheduled or system-following dark mode is out of scope — the toggle is the sole control.
- Per-screen theme overrides and additional color themes (blue, green, etc.) are out of scope.
- Analytics tracking of toggle events is out of scope and can be added as a separate task if needed.
