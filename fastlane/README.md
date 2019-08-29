fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios tests
```
fastlane ios tests
```
Run Test
### ios ui_tests
```
fastlane ios ui_tests
```
Run UI Test
### ios all_tests
```
fastlane ios all_tests
```
Run All Test
### ios clear_keychain
```
fastlane ios clear_keychain
```
Get Dev Certs
### ios development_certs
```
fastlane ios development_certs
```
Get Dev Certs
### ios adhoc_certs
```
fastlane ios adhoc_certs
```
Get AdHoc Certs
### ios enteprise_certs
```
fastlane ios enteprise_certs
```
Get Enterprise Certs
### ios app_store_certs
```
fastlane ios app_store_certs
```
Get App Store Certs
### ios gen_development_certs
```
fastlane ios gen_development_certs
```
Gen Dev Certs
### ios gen_adhoc_certs
```
fastlane ios gen_adhoc_certs
```
Gen AdHoc Certs
### ios gen_enteprise_certs
```
fastlane ios gen_enteprise_certs
```
Gen Enterprise Certs
### ios gen_app_store_certs
```
fastlane ios gen_app_store_certs
```
Gen App Store Certs
### ios build_debug
```
fastlane ios build_debug
```
Building Adhoc Debug
### ios build_enterprise_debug
```
fastlane ios build_enterprise_debug
```
Building Enterprise Debug
### ios beta
```
fastlane ios beta
```
Push a new beta build to TestFlight

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
