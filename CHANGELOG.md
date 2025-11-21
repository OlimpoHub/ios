# Changelog

## [0.1.0] – 20/11/2025

### Added

 - Added support for public IP handling to improve external connectivity.

### Fixed

 - Corrected button rendering issues on iOS 18.5 for consistent UI behavior.
 - Improved navigation bar feedback responsiveness.
 - Implemented a hotfix targeted for the project presentation.

## [0.1.0] – 19/11/2025

### Added

 - Introduced full notification list, entry button, and detail view.
 - Added a return button to improve navigation within notifications.
 - Added an application icon to finalize branding.

### Fixed

 - Unified main page naming and adjusted styles for workshop and beneficiary actions.
 - Corrected sizing issues for home and workshop buttons.
 - Adjusted view logic to correctly use the session’s userID and polished layout.
 - Repaired navigation stack inconsistencies on the beneficiary view.
 - Adjusted calendar daily recurrence logic for accurate date handling.
 - Fixed an issue preventing descriptions from displaying and updated card styling.
 - Ensured user ID persistence is stored and retrieved reliably.

## [0.1.0] – 18/11/2025

### Added

 - Implemented basic notification logic (placeholder users).
 - Added complete flow for first login and password reset via email.

### Updated

 - Updated multiple calendar-related files to match database structure changes.

### Fixed

 - Corrected calendar logic to properly use user ID obtained from authentication token.

## [0.1.0] – 17/11/2025

### Added

 - Redirect to the homepage after a successful attendance registration.

### Fixed

 - Corrected the redirect flow after bug patching in buttons.
 - Resolved issue where an unwanted back button appeared during view transitions.
 - Fixed beneficiary list route to ensure proper data retrieval.

## [0.1.0] – 15/11/2025

### Added

 - Implemented all required files for login with an existing account.
 - Added QR reading capability to support scanning processes.

### Fixed

 - Migrated navigation from FlowStacks to TabView for greater stability.
 - Updated IP configuration to allow testing on physical devices.

## [0.1.0] – 13/11/2025

### Added

 - Implemented the Beneficiaries ViewModel to support the module’s logic.

## [0.1.0] – 12/11/2025

### Added

 - Added offline calendar file support.
 - Implemented the Core Data calendar model for local storage.

### Fixed

 - Updated the workshop detail view to match the removal of `HorarioTaller` in the DB.

## [0.1.0] – 10/11/2025

### Added

 - Added backend integration for retrieving individual workshop details.

### Updated

 - Updated calendar files and cleaned duplicated folders to reflect DB structural changes.

### Fixed

 - Created a base API configuration and network service to stabilize API usage.

## [0.1.0] – 06/11/2025

### Added

 - Integrated the Alamofire networking package.
 - Added a complete Coordinator & Collaborator navigation menu.

### Changed

 - Renamed the WorkshopNetworkAPIService to follow naming conventions.

### Fixed

 - Corrected spacing issues inside the coordinator view.

## [0.1.0] – 05/11/2025

### Added

 - Implemented workshop data retrieval with frontend view integration.
 - Added foundational view-navigation logic across the app.
 - Added modal support for enhanced UI flow.
 - Added the required files for API connectivity.
 - Added primary menu button and initial main page layout.

## [0.1.0] – 04/11/2025

### Added

 - Added bold font styling to improve UI hierarchy.
 - Added base files for day-based calendar listing.

## [0.1.0] – 03/11/2025

### Added

 - Matched the calendar’s styling to the project’s Figma design.

## [0.1.0] – 02/11/2025

### Added

 - Added initial login view files.

## [0.1.0] – 01/11/2025

### Added

 - Introduced the first calendar view implementation.
 - Added NavBar elements and icon button components.
 - Implemented calendar ViewModel logic.

### Fixed

 - Adjusted button visuals and spacing issues.
 - Restored the correct Bundle Identifier after accidental modification.
 - Fixed button padding behavior for consistent touch areas.

## [0.0.0] – 31/10/2025 → 27/10/2025

### Added

 - Added support for file inputs within forms.
 - Implemented buttons and error message handling in date-input components.
 - Added number and date input types with improved tap-zone handling.
 - Created basic input atoms and removed `.DS_Store` from tracking.
 - Added default background and text theme colors.
 - Created text components for typography consistency.
 - Added core button atoms to shape the design system.

### Fixed

 - Corrected button sizing and alignment issues.

### Deleted

 - Removed `.DS_Store` from version control.

## [0.0.0] – 24/10/2025 → 20/10/2025

### Added

 - Added text atoms to begin building the UI foundations.
 - Created foundational Swift project files and base architecture.

### Changed / Updated

 - Updated PR template and coding standards.
 - Fixed minor template typos and links.

## [0.0.0] – 13/10/2025 → 09/10/2025

### Added

 - Added initial changelog file and repository documentation.
 - Created the base Pull Request template.
 - Project initialized with the first set of tracked files.