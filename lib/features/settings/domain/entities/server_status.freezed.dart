// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ServerStatus {

 bool get isOnline; String get message; String get baseUrl;
/// Create a copy of ServerStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerStatusCopyWith<ServerStatus> get copyWith => _$ServerStatusCopyWithImpl<ServerStatus>(this as ServerStatus, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerStatus&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&(identical(other.message, message) || other.message == message)&&(identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl));
}


@override
int get hashCode => Object.hash(runtimeType,isOnline,message,baseUrl);

@override
String toString() {
  return 'ServerStatus(isOnline: $isOnline, message: $message, baseUrl: $baseUrl)';
}


}

/// @nodoc
abstract mixin class $ServerStatusCopyWith<$Res>  {
  factory $ServerStatusCopyWith(ServerStatus value, $Res Function(ServerStatus) _then) = _$ServerStatusCopyWithImpl;
@useResult
$Res call({
 bool isOnline, String message, String baseUrl
});




}
/// @nodoc
class _$ServerStatusCopyWithImpl<$Res>
    implements $ServerStatusCopyWith<$Res> {
  _$ServerStatusCopyWithImpl(this._self, this._then);

  final ServerStatus _self;
  final $Res Function(ServerStatus) _then;

/// Create a copy of ServerStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isOnline = null,Object? message = null,Object? baseUrl = null,}) {
  return _then(_self.copyWith(
isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,baseUrl: null == baseUrl ? _self.baseUrl : baseUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ServerStatus].
extension ServerStatusPatterns on ServerStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServerStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServerStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServerStatus value)  $default,){
final _that = this;
switch (_that) {
case _ServerStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServerStatus value)?  $default,){
final _that = this;
switch (_that) {
case _ServerStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isOnline,  String message,  String baseUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServerStatus() when $default != null:
return $default(_that.isOnline,_that.message,_that.baseUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isOnline,  String message,  String baseUrl)  $default,) {final _that = this;
switch (_that) {
case _ServerStatus():
return $default(_that.isOnline,_that.message,_that.baseUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isOnline,  String message,  String baseUrl)?  $default,) {final _that = this;
switch (_that) {
case _ServerStatus() when $default != null:
return $default(_that.isOnline,_that.message,_that.baseUrl);case _:
  return null;

}
}

}

/// @nodoc


class _ServerStatus implements ServerStatus {
  const _ServerStatus({required this.isOnline, required this.message, required this.baseUrl});
  

@override final  bool isOnline;
@override final  String message;
@override final  String baseUrl;

/// Create a copy of ServerStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServerStatusCopyWith<_ServerStatus> get copyWith => __$ServerStatusCopyWithImpl<_ServerStatus>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServerStatus&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&(identical(other.message, message) || other.message == message)&&(identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl));
}


@override
int get hashCode => Object.hash(runtimeType,isOnline,message,baseUrl);

@override
String toString() {
  return 'ServerStatus(isOnline: $isOnline, message: $message, baseUrl: $baseUrl)';
}


}

/// @nodoc
abstract mixin class _$ServerStatusCopyWith<$Res> implements $ServerStatusCopyWith<$Res> {
  factory _$ServerStatusCopyWith(_ServerStatus value, $Res Function(_ServerStatus) _then) = __$ServerStatusCopyWithImpl;
@override @useResult
$Res call({
 bool isOnline, String message, String baseUrl
});




}
/// @nodoc
class __$ServerStatusCopyWithImpl<$Res>
    implements _$ServerStatusCopyWith<$Res> {
  __$ServerStatusCopyWithImpl(this._self, this._then);

  final _ServerStatus _self;
  final $Res Function(_ServerStatus) _then;

/// Create a copy of ServerStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isOnline = null,Object? message = null,Object? baseUrl = null,}) {
  return _then(_ServerStatus(
isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,baseUrl: null == baseUrl ? _self.baseUrl : baseUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
