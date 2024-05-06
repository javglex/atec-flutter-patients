flutter_alphatec_javier
-----

Flutter application for ATEC code assesment.

## Getting Started
Clone this repository (main branch) and follow these steps depending on
your development environment. https://docs.flutter.dev/get-started/test-drive?tab=androidstudio

Before running project make sure to run this command (creates platform specific files):
`flutter create .`

## Introduction
Two screen app which allows user to add new patients or view existing ones. User can switch between
view using bottom navigation bar.

## Overview
This app is an exercise for ATEC. It showcases the use of uses BLOC architecture,
themeing, styling, and clean code practices.

Below are the currently supported features:

* Creating a new patient and saving them locally.
* Viewing patients from the local disk and network (Pagination!).
* Themeing for major components.
* Text styling for all text styles.
* Success modal for patient added succesfully
* Empty list if no patients found
* Simple repository test suite

<img src="https://github.com/javglex/atec-flutter-patients/assets/6698872/68b0960d-e82a-4790-afb3-30031ab4f143" width="240">
<img src="https://github.com/javglex/atec-flutter-patients/assets/6698872/acc22b08-dcd6-4baa-9303-6102948f7f49" width="240">
<img src="https://github.com/javglex/atec-flutter-patients/assets/6698872/6adb8de3-5f42-40f7-8fc8-9604e6490f20" width="240">
<img src="https://github.com/javglex/atec-flutter-patients/assets/6698872/a5d3214f-cfe7-4164-a3f0-4e695e3b0f8c" width="240">
<img src="https://github.com/javglex/atec-flutter-patients/assets/6698872/318c62f0-a6a2-4dab-9d8f-59874c7e712f" width="240">

## Tech Stack (Dependencies)
* **http** for network api requests
* **bloc** for network api requests
* **sqflite** for database
* **equatable** for efficient object comparison
* **mocktail** for unit testing

Highlight folders:

* `lib/patients/data` -- Data layer folder containing repository implementation, patient db api, & patient network api.
* `lib/patients/domain` -- Defines models and interfaces pertaining to patients
* `lib/patients/presentation` -- Presentation logic for entire app
* `lib/patients/presentation/bloc` -- Contains BLOCs which communicate events between data and presentation layer
* `lib/patients/presentation/view/patient_add` -- Page for adding patients, and its view components.
* `lib/patients/presentation/view/patient_list` -- Page for viewing patients, and its view components