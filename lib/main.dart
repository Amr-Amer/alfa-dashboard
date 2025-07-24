import 'package:alfa_dashboard/core/bloc_observer/bloc_observer.dart';
import 'package:alfa_dashboard/core/di/injection_container.dart';
import 'package:alfa_dashboard/firebase_options.dart';
import 'package:alfa_dashboard/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {

  Bloc.observer = MyGlobalObserver();
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.windows,
  );
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDependencies();

  runApp(const MyApp());
}

