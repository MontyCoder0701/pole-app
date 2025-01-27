import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/poling-record.model.dart';

class PolingRecordNotifier extends Notifier<List<PolingRecord>> {
  @override
  List<PolingRecord> build() => [];

  void add(PolingRecord newRecord) {
    state = [
      ...state,
      newRecord,
    ];
  }

  void remove(PolingRecord target) {
    state = state.where((todo) => todo.id != target.id).toList();
  }
}

final polingRecordProvider =
    NotifierProvider<PolingRecordNotifier, List<PolingRecord>>(
  PolingRecordNotifier.new,
);
