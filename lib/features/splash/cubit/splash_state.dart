class SplashState {
  SplashState();
}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class VersionSuccess extends SplashState {}

class LowerVersion extends SplashState {}

class GetVersionFailed extends SplashState {
  final String message;
  GetVersionFailed(this.message);
}
