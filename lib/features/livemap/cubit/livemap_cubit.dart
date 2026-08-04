import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/livemap/livemap_model.dart';
import '../../../data/services/http_services.dart';

part 'livemap_state.dart';

class LiveMapCubit extends Cubit<LiveMapState> {
  LiveMapCubit() : super(LiveMapInitial());

  

  Future<void> getLiveMap() async {
    emit(LiveMapLoading());

    try {
      final data = await HttpServices.getLiveMap();
emit(LiveMapLoaded(data));
    } catch (e) {
      emit(LiveMapError(e.toString()));
    }
  }
}