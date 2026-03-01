# Changelog

All notable changes to this project will be documented in this file.

The format is inspired by Keep a Changelog, with entries derived from the git tag history and the current unreleased work in this repository.

## [0.3.0] - 2026-03-01

### Added
- Added `shared_config` support to the `Nursery` macro so shared child configuration can be resolved once per boot.
- Added unary `config` and `spec` callbacks that receive the resolved shared config.
- Added tests covering shared-config precedence, callback-based child config, and once-only shared-config evaluation.

### Changed
- Refactored child-spec materialization to separate environment filtering from config/spec resolution.
- Updated the README examples and usage notes to document shared config and child precedence rules.

## [0.2.1] - 2025-08-23

### Changed
- Improved test coverage with reusable generators and broader test refactors.
- Refreshed coverage reporting configuration.

## [0.2.0] - 2025-08-22

### Added
- Added support for custom child specs via the `:spec` option.
- Added macro-level tests, property-based tests, and test support modules.
- Added Coveralls configuration for coverage reporting.

### Changed
- Expanded README documentation around the new child spec format.
- Polished module documentation and minor wording fixes.

## [0.1.3] - 2025-08-20

### Fixed
- Corrected the `filter_by_env/2` return type specification.

### Changed
- Refreshed README documentation.

## [0.1.2] - 2025-08-20

### Added
- Added support for `:all` appearing as a member of the `envs` list.
- Added Credo and Dialyzer tooling and checks.

### Changed
- Expanded tests around environment filtering behavior.
- Refreshed README documentation.

## [0.1.1] - 2025-08-19

### Fixed
- Added the missing `ex_doc` dependency for documentation generation.

## [0.1.0] - 2025-08-19

### Added
- Initial packaged release of Nursery.
- Introduced the environment-aware supervisor macro and base README documentation.
