// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SettingsState {

 bool get isCheckingServer; bool get isResetting; ServerStatus? get serverStatus; bool get qrRotationEnabled; int get qrDurationSec; bool get requireBiometrics; bool get maintenanceMode; String? get errorMessage;
/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsStateCopyWith<SettingsState> get copyWith => _$SettingsStateCopyWithImpl<SettingsState>(this as SettingsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsState&&(identical(other.isCheckingServer, isCheckingServer) || other.isCheckingServer == isCheckingServer)&&(identical(other.isResetting, isResetting) || other.isResetting == isResetting)&&(identical(other.serverStatus, serverStatus) || other.serverStatus == serverStatus)&&(identical(other.qrRotationEnabled, qrRotationEnabled) || other.qrRotationEnabled == qrRotationEnabled)&&(identical(other.qrDurationSec, qrDurationSec) || other.qrDurationSec == qrDurationSec)&&(identical(other.requireBiometrics, requireBiometrics) || other.requireBiometrics == requireBiometrics)&&(identical(other.maintenanceMode, maintenanceMode) || other.maintenanceMode == maintenanceMode)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isCheckingServer,isResetting,serverStatus,qrRotationEnabled,qrDurationSec,requireBiometrics,maintenanceMode,errorMessage);

@override
String toString() {
  return 'SettingsState(isCheckingServer: $isCheckingServer, isResetting: $isResetting, serverStatus: $serverStatus, qrRotationEnabled: $qrRotationEnabled, qrDurationSec: $qrDurationSec, requireBiometrics: $requireBiometrics, maintenanceMode: $maintenanceMode, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $SettingsStateCopyWith<$Res>  {
  factory $SettingsStateCopyWith(SettingsState value, $Res Function(SettingsState) _then) = _$SettingsStateCopyWithImpl;
@useResult
$Res call({
 bool isCheckingServer, bool isResetting, ServerStatus? serverStatus, bool qrRotationEnabled, int qrDurationSec, bool requireBiometrics, bool maintenanceMode, String? errorMessage
});


$ServerStatusCopyWith<$Res>? get serverStatus;

}
/// @nodoc
class _$SettingsStateCopyWithImpl<$Res>
    implements $SettingsStateCopyWith<$Res> {
  _$SettingsStateCopyWithImpl(this._self, this._then);

  final SettingsState _self;
  final $Res Function(SettingsState) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isCheckingServer = null,Object? isResetting = null,Object? serverStatus = freezed,Object? qrRotationEnabled = null,Object? qrDurationSec = null,Object? requireBiometrics = null,Object? maintenanceMode = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
isCheckingServer: null == isCheckingServer ? _self.isCheckingServer : isCheckingServer // ignore: cast_nullable_to_non_nullable
as bool,isResetting: null == isResetting ? _self.isResetting : isResetting // ignore: cast_nullable_to_non_nullable
as bool,serverStatus: freezed == serverStatus ? _self.serverStatus : serverStatus // ignore: cast_nullable_to_non_nullable
as ServerStatus?,qrRotationEnabled: null == qrRotationEnabled ? _self.qrRotationEnabled : qrRotationEnabled // ignore: cast_nullable_to_non_nullable
as bool,qrDurationSec: null == qrDurationSec ? _self.qrDurationSec : qrDurationSec // ignore: cast_nullable_to_non_nullable
as int,requireBiometrics: null == requireBiometrics ? _self.requireBiometrics : requireBiometrics // ignore: cast_nullable_to_non_nullable
as bool,maintenanceMode: null == maintenanceMode ? _self.maintenanceMode : maintenanceMode // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServerStatusCopyWith<$Res>? get serverStatus {
    if (_self.serverStatus == null) {
    return null;
  }

  return $ServerStatusCopyWith<$Res>(_self.serverStatus!, (value) {
    return _then(_self.copyWith(serverStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [SettingsState].
extension SettingsStatePatterns on SettingsState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingsState value)  $default,){
final _that = this;
switch (_that) {
case _SettingsState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingsState value)?  $default,){
final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isCheckingServer,  bool isResetting,  ServerStatus? serverStatus,  bool qrRotationEnabled,  int qrDurationSec,  bool requireBiometrics,  bool maintenanceMode,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that.isCheckingServer,_that.isResetting,_that.serverStatus,_that.qrRotationEnabled,_that.qrDurationSec,_that.requireBiometrics,_that.maintenanceMode,_that.errorMessage);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isCheckingServer,  bool isResetting,  ServerStatus? serverStatus,  bool qrRotationEnabled,  int qrDurationSec,  bool requireBiometrics,  bool maintenanceMode,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _SettingsState():
return $default(_that.isCheckingServer,_that.isResetting,_that.serverStatus,_that.qrRotationEnabled,_that.qrDurationSec,_that.requireBiometrics,_that.maintenanceMode,_that.errorMessage);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isCheckingServer,  bool isResetting,  ServerStatus? serverStatus,  bool qrRotationEnabled,  int qrDurationSec,  bool requireBiometrics,  bool maintenanceMode,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that.isCheckingServer,_that.isResetting,_that.serverStatus,_that.qrRotationEnabled,_that.qrDurationSec,_that.requireBiometrics,_that.maintenanceMode,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _SettingsState implements SettingsState {
  const _SettingsState({this.isCheckingServer = false, this.isResetting = false, this.serverStatus, this.qrRotationEnabled = true, this.qrDurationSec = 14, this.requireBiometrics = false, this.maintenanceMode = false, this.errorMessage});
  

@override@JsonKey() final  bool isCheckingServer;
@override@JsonKey() final  bool isResetting;
@override final  ServerStatus? serverStatus;
@override@JsonKey() final  bool qrRotationEnabled;
@override@JsonKey() final  int qrDurationSec;
@override@JsonKey() final  bool requireBiometrics;
@override@JsonKey() final  bool maintenanceMode;
@override final  String? errorMessage;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsStateCopyWith<_SettingsState> get copyWith => __$SettingsStateCopyWithImpl<_SettingsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingsState&&(identical(other.isCheckingServer, isCheckingServer) || other.isCheckingServer == isCheckingServer)&&(identical(other.isResetting, isResetting) || other.isResetting == isResetting)&&(identical(other.serverStatus, serverStatus) || other.serverStatus == serverStatus)&&(identical(other.qrRotationEnabled, qrRotationEnabled) || other.qrRotationEnabled == qrRotationEnabled)&&(identical(other.qrDurationSec, qrDurationSec) || other.qrDurationSec == qrDurationSec)&&(identical(other.requireBiometrics, requireBiometrics) || other.requireBiometrics == requireBiometrics)&&(identical(other.maintenanceMode, maintenanceMode) || other.maintenanceMode == maintenanceMode)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isCheckingServer,isResetting,serverStatus,qrRotationEnabled,qrDurationSec,requireBiometrics,maintenanceMode,errorMessage);

@override
String toString() {
  return 'SettingsState(isCheckingServer: $isCheckingServer, isResetting: $isResetting, serverStatus: $serverStatus, qrRotationEnabled: $qrRotationEnabled, qrDurationSec: $qrDurationSec, requireBiometrics: $requireBiometrics, maintenanceMode: $maintenanceMode, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$SettingsStateCopyWith<$Res> implements $SettingsStateCopyWith<$Res> {
  factory _$SettingsStateCopyWith(_SettingsState value, $Res Function(_SettingsState) _then) = __$SettingsStateCopyWithImpl;
@override @useResult
$Res call({
 bool isCheckingServer, bool isResetting, ServerStatus? serverStatus, bool qrRotationEnabled, int qrDurationSec, bool requireBiometrics, bool maintenanceMode, String? errorMessage
});


@override $ServerStatusCopyWith<$Res>? get serverStatus;

}
/// @nodoc
class __$SettingsStateCopyWithImpl<$Res>
    implements _$SettingsStateCopyWith<$Res> {
  __$SettingsStateCopyWithImpl(this._self, this._then);

  final _SettingsState _self;
  final $Res Function(_SettingsState) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isCheckingServer = null,Object? isResetting = null,Object? serverStatus = freezed,Object? qrRotationEnabled = null,Object? qrDurationSec = null,Object? requireBiometrics = null,Object? maintenanceMode = null,Object? errorMessage = freezed,}) {
  return _then(_SettingsState(
isCheckingServer: null == isCheckingServer ? _self.isCheckingServer : isCheckingServer // ignore: cast_nullable_to_non_nullable
as bool,isResetting: null == isResetting ? _self.isResetting : isResetting // ignore: cast_nullable_to_non_nullable
as bool,serverStatus: freezed == serverStatus ? _self.serverStatus : serverStatus // ignore: cast_nullable_to_non_nullable
as ServerStatus?,qrRotationEnabled: null == qrRotationEnabled ? _self.qrRotationEnabled : qrRotationEnabled // ignore: cast_nullable_to_non_nullable
as bool,qrDurationSec: null == qrDurationSec ? _self.qrDurationSec : qrDurationSec // ignore: cast_nullable_to_non_nullable
as int,requireBiometrics: null == requireBiometrics ? _self.requireBiometrics : requireBiometrics // ignore: cast_nullable_to_non_nullable
as bool,maintenanceMode: null == maintenanceMode ? _self.maintenanceMode : maintenanceMode // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServerStatusCopyWith<$Res>? get serverStatus {
    if (_self.serverStatus == null) {
    return null;
  }

  return $ServerStatusCopyWith<$Res>(_self.serverStatus!, (value) {
    return _then(_self.copyWith(serverStatus: value));
  });
}
}

// dart format on
