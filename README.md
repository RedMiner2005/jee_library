# JEE Library

A library for all things JEE - actually, just the notebooks that I (Pratyush) generated as a result of coaching classes

## The History
This app started as another personal project for me, since I had about 45 notebooks for JEE. I needed to classify them systematically and be able to find which book had the chapter I needed, or which chapters are in a particular book.
At the end, I gave away my books to a certain 'Anay', hence why the name keeps appearing.

## A gist of the app
The app opens up to a home screen with buttons for the three subjects, and a floating action button to scan barcodes (which will be stuck onto every notebook).
The app uses a basic implementation of Google Analytics, because I had to know whether my hard work would go in vain, and it uses Firebase Cloud Firestore to store the books/chapters.

## How do you run this?
You could import this project into Android Studio. Just make sure the the Flutter and Dart plugins are enabled. Then you may connect your Android device through a USB cable (or enable wireless debugging), and run the project. Alternatively, you could use an Android emulator, or use VS Code instead of Android Studio.

## Screenshots
For more screenshots, just check the screenshots directory.

![The app opening up with the splash screen and the home screen animation](/screenshots/open.gif?raw=true "The app opening up with the splash screen and the home screen animation")  ![Scanning a book's barcode](/screenshots/scanAttempt.gif?raw=true "Scanning a book's barcode")
