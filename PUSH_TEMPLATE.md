## Summary

Replaces the hardcoded 50 bar reserve pressure threshold in the dive planner with a user-editable field. The field is unit-aware (bar/psi), validated, localized across all 10 supported languages, and defaults to 50 bar (metric) or 500 psi (imperial) based on the user's pressure unit setting.

## Changes

- Added `reservePressure` field to `DivePlanState` entity with `kDefaultReservePressureBar` constant
- Parameterized reserve threshold in `PlanCalculatorService.calculatePlan` (was hardcoded `50`)
- Added `_ReservePressureInput` widget to plan settings panel alongside altitude input
- Wired reserve pressure through `DivePlanNotifier` with `updateReservePressure` method
- Unit-aware default: 50 bar for metric users, 500 psi (~34.47 bar) for imperial users
- Input validation: rejects zero/negative values and values exceeding tank start pressure
- Empty field resets to default with a non-error info message ("Not entered — assuming 50 bar")
- Added `Semantics` label for screen reader accessibility
- Used `ref.read` (not `ref.watch`) for `pressureUnitProvider` to avoid recreating the notifier on unit change
- Updated `GasResultsPanel` to display user-entered reserve in "below minimum reserve" messages
- Warning message in calculator now includes the threshold value
- Added `divePlanner_label_reserve`, `divePlanner_error_reserveMustBePositive`, `divePlanner_error_reserveExceedsTank`, and `divePlanner_info_reserveDefault` localization keys across all 10 languages
- 6 unit tests for reserve logic in `PlanCalculatorService` (bar and psi paths, boundary conditions)
- 13 widget tests for reserve UI (display, defaults, validation errors, empty field fallback)

## Test Plan

- [ ] `flutter test` passes
- [ ] `flutter analyze` passes
- [ ] Manual testing on: <!-- list platforms tested -->

## Screenshots

<!-- If UI changes, add before/after screenshots. Delete this section if not applicable. -->
