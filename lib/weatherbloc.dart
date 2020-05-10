import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'weathermodel.dart';
import 'weathermodel.dart';

class WeatherEvent extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
  
}

class FetchWeather extends WeatherEvent{
  String city;
  FetchWeather(this.city);
   @override
  // TODO: implement props
  List<Object> get props => [city];
}

class ResetWeather extends WeatherEvent{

}

class WeatherState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
  
}

class NotloadingWeather extends WeatherState{

}

class LoadingWeather extends WeatherState{

}

class LoadedWeather extends WeatherState{
  final weather;
  LoadedWeather(this.weather);
   @override
  // TODO: implement props
  List<Object> get props => [weather];
}

class NotloadedWeather extends WeatherState{

}

class WeatherBloc extends Bloc<WeatherEvent,WeatherState>{
  WeatherModel weatherModel;
  WeatherBloc(this.weatherModel);
  @override
  // TODO: implement initialState
  WeatherState get initialState => NotloadingWeather();

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async*{
    // TODO: implement mapEventToState
    if(event is FetchWeather){
      yield LoadingWeather();
      try{
       await weatherModel.getData(event.city);
        yield LoadedWeather(weatherModel);
      }catch(e){
        yield NotloadedWeather();
      }
    }else if(event is ResetWeather){
      yield NotloadingWeather();
    }
  }


}