# Code Context

## Files Retrieved
1. `FE_PLAN.md` (lines 368-410, 414-441, 445-537, 541-586) - intended parent home / child profile / assessment / result flow.
2. `lib/app/modules/parent/shell/parent_shell_view.dart` (lines 13-194, 255-310) - current 4-tab shell and embedded result tab.
3. `lib/app/modules/parent/shell/parent_shell_controller.dart` (lines 6-30) - tab state and result handoff.
4. `lib/app/modules/parent/home/home_view.dart` (lines 13-553) - current parent home UI.
5. `lib/app/modules/parent/home/home_controller.dart` (lines 1-62) - home data loading state.
6. `lib/app/modules/parent/assessment/assessment_view.dart` (lines 8-320) - current assessment UI.
7. `lib/app/modules/parent/assessment/assessment_controller.dart` (lines 37-264) - assessment step/data flow.
8. `lib/app/modules/parent/assessment_result/result_view.dart` (lines 11-310) - standalone result UI.
9. `lib/app/modules/parent/assessment_result/result_controller.dart` (lines 7-38) - result route controller.
10. `lib/app/modules/parent/assessment_result/result_share_view.dart` (lines 1-20) - placeholder share screen.
11. `lib/app/modules/parent/child_profile/child_profile_list_view.dart` (lines 11-187) - child list UI.
12. `lib/app/modules/parent/child_profile/child_profile_form_view.dart` (lines 12-250) - child form UI.
13. `lib/app/modules/parent/child_profile/child_profile_controller.dart` (lines 9-170) - child CRUD logic.
14. `lib/app/routes/app_routes.dart` (lines 5-36) - named route constants.
15. `lib/app/routes/app_pages.dart` (lines 64-171) - route → view/binding map.

## Key Code
- Shell currently owns the main parent tabs and embeds a `Hasil` tab that reads `ParentShellController.latestResult` instead of using the dedicated result route.
- Home controller loads children + latest assessments, but `HomeView` renders mostly static marketing content and never surfaces active-child/risk/history data.
- Assessment controller is a yes/no toggle form; submit writes the result into shell state. No `PageController`, `canProceed`, or anaphylaxis inline warning flow.
- Result route/controller exists, but `ResultController` only supports `goHome`, `goToHistory`, `retakeAssessment`; export/share/bookmark are missing.
- Child profile CRUD exists, but there is no active-child selection API on the controller or in the list UI.
- Routes map `PARENT_HOME` and `PARENT_SHELL` to the same `/parent` path.

## Architecture
Current flow:
`Splash -> Onboarding -> Role/Auth -> ParentShellView`

Inside parent shell:
- Tab 0: `HomeView`
- Tab 1: `AssessmentView`
- Tab 2: embedded result screen from shell state
- Tab 3: article list

Broken/changed vs FE_PLAN:
- FE_PLAN expects Home to be a dashboard with active child switcher, risk summary, history strip, and featured articles.
- FE_PLAN expects Assessment to be a controlled multi-step PageView with validation and anaphylaxis warning.
- FE_PLAN expects Result to be a dedicated screen with PDF/share actions and child/date context.
- FE_PLAN expects child selection to drive assessment entry; current UI can enter assessment with no active child.

## Start Here
Open `lib/app/modules/parent/shell/parent_shell_view.dart` first. It defines the tab model and the result flow, which is the main mismatch with the older FE_PLAN navigation.
