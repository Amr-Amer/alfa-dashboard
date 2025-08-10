import 'dart:async';
import 'dart:developer';
import 'package:alfa_dashboard/core/bloc_observer/bloc_observer.dart';
import 'package:alfa_dashboard/core/di/injection_container.dart';
import 'package:alfa_dashboard/firebase_options.dart';
import 'package:alfa_dashboard/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  BindingBase.debugZoneErrorsAreFatal = true;

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    logFlutterError(details);
  };

  Bloc.observer = MyGlobalObserver();

  await runZonedGuarded(
        () async {
      WidgetsFlutterBinding.ensureInitialized();

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.windows,
      );
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
    debugPrint('A.B.O.N.A.G.E.H Flutter Error: ${details.exception}');
    debugPrint('A.B.O.N.A.G.E.H Stack trace: ${details.stack}');
  }
}

void logDartError(Object error, StackTrace stackTrace) {
  if (kDebugMode) {
    debugPrint('A.B.O.N.A.G.E.H Dart Error: $error');
    debugPrint('A.B.O.N.A.G.E.H Stack trace: $stackTrace');
  }
}