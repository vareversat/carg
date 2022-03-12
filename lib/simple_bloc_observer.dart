import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    developer.log('[CHANGED] : ${bloc.runtimeType} $change', name: 'carg.bloc-observer');
    super.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    developer.log('[TRANSITION] ${bloc.runtimeType} $transition', name: 'carg.bloc-observer');
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    developer.log('[ERROR] ${bloc.runtimeType} $error $stackTrace', name: 'carg.bloc-observer');
    super.onError(bloc, error, stackTrace);
  }
}