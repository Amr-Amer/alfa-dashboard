import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:alfa_dashboard/core/bloc_observer/bloc_observer.dart';
import 'package:alfa_dashboard/core/di/injection_container.dart';
import 'package:alfa_dashboard/firebase_options.dart';
import 'package:alfa_dashboard/my_app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  BindingBase.debugZoneErrorsAreFatal = true;

  await runZonedGuarded(
        () async {
      WidgetsFlutterBinding.ensureInitialized();

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      FirebaseFirestore.instance.settings = Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );

      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        FlutterError.onError = (FlutterErrorDetails details) {
          if (details.exception.toString().contains('non-platform thread')) {
            return;
          }
          FlutterError.dumpErrorToConsole(details);
          logFlutterError(details);
        };
      }

      Bloc.observer = MyGlobalObserver();
      await initializeDependencies();

      runApp(const MyApp());
    },
        (error, stackTrace) {
      logDartError(error, stackTrace);
      log(stackTrace.toString(), name: 'main');
      // FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
    },
  );
}

void logFlutterError(FlutterErrorDetails details) {
  if (kDebugMode) {
    debugPrint('Flutter Error: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');
  }
}

void logDartError(Object error, StackTrace stackTrace) {
  if (kDebugMode) {
    debugPrint('Dart Error: $error');
    debugPrint('Stack trace: $stackTrace');
  }
}