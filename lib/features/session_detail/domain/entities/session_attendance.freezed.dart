// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_attendance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SessionAttendance {

 String get id; AttendanceStatus get status; DateTime? get scanTime; Supervisor? get supervisor;
/// Create a copy of SessionAttendance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionAttendanceCopyWith<SessionAttendance> get copyWith => _$SessionAttendanceCopyWithImpl<SessionAttendance>(this as SessionAttendance, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionAttendance&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.scanTime, scanTime) || other.scanTime == scanTime)&&(identical(other.supervisor, supervisor) || other.supervisor == supervisor));
}


@override
int get hashCode => Object.hash(runtimeType,id,status,scanTime,supervisor);

@override
String toString() {
  return 'SessionAttendance(id: $id, status: $status, scanTime: $scanTime, supervisor: $supervisor)';
}


}

/// @nodoc
abstract mixin class $SessionAttendanceCopyWith<$Res>  {
  factory $SessionAttendanceCopyWith(SessionAttendance value, $Res Function(SessionAttendance) _then) = _$SessionAttendanceCopyWithImpl;
@useResult
$Res call({
 String id, AttendanceStatus status, DateTime? scanTime, Supervisor? supervisor
});


$SupervisorCopyWith<$Res>? get supervisor;

}
/// @nodoc
class _$SessionAttendanceCopyWithImpl<$Res>
    implements $SessionAttendanceCopyWith<$Res> {
  _$SessionAttendanceCopyWithImpl(this._self, this._then);

  final SessionAttendance _self;
  final $Res Function(SessionAttendance) _then;

/// Create a copy of SessionAttendance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? scanTime = freezed,Object? supervisor = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AttendanceStatus,scanTime: freezed == scanTime ? _self.scanTime : scanTime // ignore: cast_nullable_to_non_nullable
as DateTime?,supervisor: freezed == supervisor ? _self.supervisor : supervisor // ignore: cast_nullable_to_non_nullable
as Supervisor?,
  ));
}
/// Create a copy of SessionAttendance
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SupervisorCopyWith<$Res>? get supervisor {
    if (_self.supervisor == null) {
    return null;
  }

  return $SupervisorCopyWith<$Res>(_self.supervisor!, (value) {
    return _then(_self.copyWith(supervisor: value));
  });
}
}


/// Adds pattern-matching-related methods to [SessionAttendance].
extension SessionAttendancePatterns on SessionAttendance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionAttendance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionAttendance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionAttendance value)  $default,){
final _that = this;
switch (_that) {
case _SessionAttendance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionAttendance value)?  $default,){
final _that = this;
switch (_that) {
case _SessionAttendance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  AttendanceStatus status,  DateTime? scanTime,  Supervisor? supervisor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionAttendance() when $default != null:
return $default(_that.id,_that.status,_that.scanTime,_that.supervisor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  AttendanceStatus status,  DateTime? scanTime,  Supervisor? supervisor)  $default,) {final _that = this;
switch (_that) {
case _SessionAttendance():
return $default(_that.id,_that.status,_that.scanTime,_that.supervisor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  AttendanceStatus status,  DateTime? scanTime,  Supervisor? supervisor)?  $default,) {final _that = this;
switch (_that) {
case _SessionAttendance() when $default != null:
return $default(_that.id,_that.status,_that.scanTime,_that.supervisor);case _:
  return null;

}
}

}

/// @nodoc


class _SessionAttendance implements SessionAttendance {
  const _SessionAttendance({required this.id, required this.status, this.scanTime, this.supervisor});
  

@override final  String id;
@override final  AttendanceStatus status;
@override final  DateTime? scanTime;
@override final  Supervisor? supervisor;

/// Create a copy of SessionAttendance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionAttendanceCopyWith<_SessionAttendance> get copyWith => __$SessionAttendanceCopyWithImpl<_SessionAttendance>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionAttendance&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.scanTime, scanTime) || other.scanTime == scanTime)&&(identical(other.supervisor, supervisor) || other.supervisor == supervisor));
}


@override
int get hashCode => Object.hash(runtimeType,id,status,scanTime,supervisor);

@override
String toString() {
  return 'SessionAttendance(id: $id, status: $status, scanTime: $scanTime, supervisor: $supervisor)';
}


}

/// @nodoc
abstract mixin class _$SessionAttendanceCopyWith<$Res> implements $SessionAttendanceCopyWith<$Res> {
  factory _$SessionAttendanceCopyWith(_SessionAttendance value, $Res Function(_SessionAttendance) _then) = __$SessionAttendanceCopyWithImpl;
@override @useResult
$Res call({
 String id, AttendanceStatus status, DateTime? scanTime, Supervisor? supervisor
});


@override $SupervisorCopyWith<$Res>? get supervisor;

}
/// @nodoc
class __$SessionAttendanceCopyWithImpl<$Res>
    implements _$SessionAttendanceCopyWith<$Res> {
  __$SessionAttendanceCopyWithImpl(this._self, this._then);

  final _SessionAttendance _self;
  final $Res Function(_SessionAttendance) _then;

/// Create a copy of SessionAttendance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? scanTime = freezed,Object? supervisor = freezed,}) {
  return _then(_SessionAttendance(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AttendanceStatus,scanTime: freezed == scanTime ? _self.scanTime : scanTime // ignore: cast_nullable_to_non_nullable
as DateTime?,supervisor: freezed == supervisor ? _self.supervisor : supervisor // ignore: cast_nullable_to_non_nullable
as Supervisor?,
  ));
}

/// Create a copy of SessionAttendance
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SupervisorCopyWith<$Res>? get supervisor {
    if (_self.supervisor == null) {
    return null;
  }

  return $SupervisorCopyWith<$Res>(_self.supervisor!, (value) {
    return _then(_self.copyWith(supervisor: value));
  });
}
}

/// @nodoc
mixin _$Supervisor {

 String get name; String get email;
/// Create a copy of Supervisor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupervisorCopyWith<Supervisor> get copyWith => _$SupervisorCopyWithImpl<Supervisor>(this as Supervisor, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Supervisor&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode => Object.hash(runtimeType,name,email);

@override
String toString() {
  return 'Supervisor(name: $name, email: $email)';
}


}

/// @nodoc
abstract mixin class $SupervisorCopyWith<$Res>  {
  factory $SupervisorCopyWith(Supervisor value, $Res Function(Supervisor) _then) = _$SupervisorCopyWithImpl;
@useResult
$Res call({
 String name, String email
});




}
/// @nodoc
class _$SupervisorCopyWithImpl<$Res>
    implements $SupervisorCopyWith<$Res> {
  _$SupervisorCopyWithImpl(this._self, this._then);

  final Supervisor _self;
  final $Res Function(Supervisor) _then;

/// Create a copy of Supervisor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? email = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Supervisor].
extension SupervisorPatterns on Supervisor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Supervisor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Supervisor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Supervisor value)  $default,){
final _that = this;
switch (_that) {
case _Supervisor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Supervisor value)?  $default,){
final _that = this;
switch (_that) {
case _Supervisor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String email)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Supervisor() when $default != null:
return $default(_that.name,_that.email);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String email)  $default,) {final _that = this;
switch (_that) {
case _Supervisor():
return $default(_that.name,_that.email);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String email)?  $default,) {final _that = this;
switch (_that) {
case _Supervisor() when $default != null:
return $default(_that.name,_that.email);case _:
  return null;

}
}

}

/// @nodoc


class _Supervisor implements Supervisor {
  const _Supervisor({required this.name, required this.email});
  

@override final  String name;
@override final  String email;

/// Create a copy of Supervisor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SupervisorCopyWith<_Supervisor> get copyWith => __$SupervisorCopyWithImpl<_Supervisor>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Supervisor&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode => Object.hash(runtimeType,name,email);

@override
String toString() {
  return 'Supervisor(name: $name, email: $email)';
}


}

/// @nodoc
abstract mixin class _$SupervisorCopyWith<$Res> implements $SupervisorCopyWith<$Res> {
  factory _$SupervisorCopyWith(_Supervisor value, $Res Function(_Supervisor) _then) = __$SupervisorCopyWithImpl;
@override @useResult
$Res call({
 String name, String email
});




}
/// @nodoc
class __$SupervisorCopyWithImpl<$Res>
    implements _$SupervisorCopyWith<$Res> {
  __$SupervisorCopyWithImpl(this._self, this._then);

  final _Supervisor _self;
  final $Res Function(_Supervisor) _then;

/// Create a copy of Supervisor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? email = null,}) {
  return _then(_Supervisor(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
