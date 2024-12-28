# Flutter On-Screen Logger

[![Pub Package](https://img.shields.io/badge/pub-v1.1.7-blue)](https://pub.dev/packages/flutter_onscreen_logger)
[![Pub Package](https://img.shields.io/badge/flutter-%3E%3D1.17.0-green)](https://flutter.dev/)
[![GitHub Repo stars](https://img.shields.io/github/stars/amm965/flutter_onscreen_logger?style=social)](https://github.com/amm965/flutter_onscreen_logger)

A Flutter package that allows you to display logs on the screen of your app for easier debugging.

![flutter_onscreen_logger](https://i.giphy.com/media/v1.Y2lkPTc5MGI3NjExNTloemZxbjdremRzdG9jNW1od2doajBzZHc3MHNmZ3NubmtvdzVvNiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/VIfJGa3CyELfid6yfC/giphy.gif)

## Features

- Log exceptions and errors in a user-friendly way.
- Easily integrate with Dio for HTTP request logging.
- Simple API for logging custom messages.
- Customizable display options for logs.

## Getting Started

1. Add the package to your `pubspec.yaml` file:

    ```yaml
    dependencies:
      flutter_onscreen_logger: ^1.0.0
    ```

2. Configure your `main.dart` to integrate the library:

    - Wrap your `runApp()` method in `main()` with `runZonedGuarded()` to handle errors globally.
    - In the `onError()` function, call the logger's `onError()` method.

    ```dart
    main() {
      runZonedGuarded(() async {
        WidgetsFlutterBinding.ensureInitialized();

        // No need for .init() anymore, it's handled automatically.

        //...other code...
        
        runApp(MyApp());
      }, (error, stack) {
        OnscreenLogger.onError();
      });
    }
    ```

    - Wrap your `MaterialApp()` widget with a `Stack()` and `Directionality()` widgets.
    - Add `LoggerOverlayWidget()` widget below it.
    - **Note**: You can conditionally show/hide the on-screen logger based on your use case. For example, you can set the widget to only show in debug mode (Recommended).

   ```dart
   Directionality(
      textDirection: TextDirection.ltr, 
      child: Stack(
          children: [
            MaterialApp(
              //...other material app properties...
              home: MyHomePage(title: 'MyApp'),
            ),
            if (BuildConfig.showOnScreenLogger) LoggerOverlayWidget(),
          ],
        ),
    );
   ```

## Usage

You can use the on-screen logger to log your own custom message throughout your project using the
following methods:

### e() - Log Errors

Logs error messages with a red color.

   ```dart
   OnScreenLog.e(
     title: 'Network Error',
     message: 'Unable to fetch data from server.',
   );
   ```
   
### i() - Log Info

Logs info messages with a white color.

   ```dart
   OnScreenLog.i(
     title: 'API Response Received!',
     message: '* API Response:\n$data',
   );
   ```
   
### s() - Log Success

Logs success messages with a green color.

   ```dart
   OnScreenLog.s(
     title: 'Login Successful',
     message: 'User has logged in successfully.',
   );
   ```
   
### w() - Log Warnings

Logs warning messages with a orange color.

   ```dart
   OnScreenLog.w(
     title: 'Low Disk Space',
     message: 'Disk space is running low, consider cleaning up.',
   );
   ```
   
### shareAll() - Share All Logs

Allows you to share all the log entries that have been captured so far. This method will gather the logs and open a sharing interface for the user to share the log messages.

   ```dart
   OnScreenLog.shareAll();
   ```

### clearAll() - Clear All Logs

Clears all log entries currently stored in the logger, effectively resetting the log data. This is useful if you want to start a new logging session or remove sensitive log data.

   ```dart
   OnScreenLog.clearAll();
   ```