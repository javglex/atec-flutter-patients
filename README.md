flutter_alphatec_javier
-----

Flutter application for ATEC code assesment.

## Getting Started
Clone this repository (main branch) and follow these steps depending on 
your development environment. https://docs.flutter.dev/get-started/test-drive?tab=androidstudio

## Introduction
Two screen app which allows user to add new patients or view existing ones. User can switch between
view using bottom navigation bar.

## Overview
This app is an exercise for ATEC. It showcases the use of uses BLOC architecture, 
themeing, styling, and clean code practices.

Below are the currently supported features:

* Creating a new patient and saving them locally.
* Viewing patients from the local disk and network.
* Themeing for major components.
* Text styling for all text styles.

## Tech Stack (Dependencies)
   * **http** for network api requests
   * **bloc** for network api requests
   * **sqflite** for database
   * **equatable** for efficient object comparison

Highlight folders:

* `lib/patients/data` -- Data layer folder containing repository implementation, patient db api, & patient network api.
* `lib/patients/domain` -- Defines models and interfaces pertaining to patients
* `lib/patients/presentation` -- Presentation logic for entire app
* `lib/patients/presentation/bloc` -- Contains BLOCs which communicate events between data and presentation layer
* `lib/patients/presentation/view/patient_add` -- Page for adding patients, and its view components.
* `lib/patients/presentation/view/patient_list` -- Page for viewing patients, and its view components