// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_attendance_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionAttendanceModel {

 String get id;@JsonKey(unknownEnumValue: AttendanceStatus.absent) AttendanceStatus get status; DateTime? get scanTime; SupervisorModel? get supervisor;
/// Create a copy of SessionAttendanceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionAttendanceModelCopyWith<SessionAttendanceModel> get copyWith => _$SessionAttendanceModelCopyWithImpl<SessionAttendanceModel>(this as SessionAttendanceModel, _$identity);

  /// Serializes this SessionAttendanceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionAttendanceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.scanTime, scanTime) || other.scanTime == scanTime)&&(identical(other.supervisor, supervisor) || other.supervisor == supervisor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,scanTime,supervisor);

@override
String toString() {
  return 'SessionAttendanceModel(id: $id, status: $status, scanTime: $scanTime, supervisor: $supervisor)';
}


}

/// @nodoc
abstract mixin class $SessionAttendanceModelCopyWith<$Res>  {
  factory $SessionAttendanceModelCopyWith(SessionAttendanceModel value, $Res Function(SessionAttendanceModel) _then) = _$SessionAttendanceModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(unknownEnumValue: AttendanceStatus.absent) AttendanceStatus status, DateTime? scanTime, SupervisorModel? supervisor
});


$SupervisorModelCopyWith<$Res>? get supervisor;

}
/// @nodoc
class _$SessionAttendanceModelCopyWithImpl<$Res>
    implements $SessionAttendanceModelCopyWith<$Res> {
  _$SessionAttendanceModelCopyWithImpl(this._self, this._then);

  final SessionAttendanceModel _self;
  final $Res Function(SessionAttendanceModel) _then;

/// Create a copy of SessionAttendanceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? scanTime = freezed,Object? supervisor = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AttendanceStatus,scanTime: freezed == scanTime ? _self.scanTime : scanTime // ignore: cast_nullable_to_non_nullable
as DateTime?,supervisor: freezed == supervisor ? _self.supervisor : supervisor // ignore: cast_nullable_to_non_nullable
as SupervisorModel?,
  ));
}
/// Create a copy of SessionAttendanceModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SupervisorModelCopyWith<$Res>? get supervisor {
    if (_self.supervisor == null) {
    return null;
  }

  return $SupervisorModelCopyWith<$Res>(_self.supervisor!, (value) {
    return _then(_self.copyWith(supervisor: value));
  });
}
}


/// Adds pattern-matching-related methods to [SessionAttendanceModel].
extension SessionAttendanceModelPatterns on SessionAttendanceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionAttendanceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionAttendanceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionAttendanceModel value)  $default,){
final _that = this;
switch (_that) {
case _SessionAttendanceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionAttendanceModel value)?  $default,){
final _that = this;
switch (_that) {
case _SessionAttendanceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(unknownEnumValue: AttendanceStatus.absent)  AttendanceStatus status,  DateTime? scanTime,  SupervisorModel? supervisor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionAttendanceModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(unknownEnumValue: AttendanceStatus.absent)  AttendanceStatus status,  DateTime? scanTime,  SupervisorModel? supervisor)  $default,) {final _that = this;
switch (_that) {
case _SessionAttendanceModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(unknownEnumValue: AttendanceStatus.absent)  AttendanceStatus status,  DateTime? scanTime,  SupervisorModel? supervisor)?  $default,) {final _that = this;
switch (_that) {
case _SessionAttendanceModel() when $default != null:
return $default(_that.id,_that.status,_that.scanTime,_that.supervisor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SessionAttendanceModel extends SessionAttendanceModel {
  const _SessionAttendanceModel({required this.id, @JsonKey(unknownEnumValue: AttendanceStatus.absent) required this.status, this.scanTime, this.supervisor}): super._();
  factory _SessionAttendanceModel.fromJson(Map<String, dynamic> json) => _$SessionAttendanceModelFromJson(json);

@override final  String id;
@override@JsonKey(unknownEnumValue: AttendanceStatus.absent) final  AttendanceStatus status;
@override final  DateTime? scanTime;
@override final  SupervisorModel? supervisor;

/// Create a copy of SessionAttendanceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionAttendanceModelCopyWith<_SessionAttendanceModel> get copyWith => __$SessionAttendanceModelCopyWithImpl<_SessionAttendanceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionAttendanceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionAttendanceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.scanTime, scanTime) || other.scanTime == scanTime)&&(identical(other.supervisor, supervisor) || other.supervisor == supervisor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,scanTime,supervisor);

@override
String toString() {
  return 'SessionAttendanceModel(id: $id, status: $status, scanTime: $scanTime, supervisor: $supervisor)';
}


}

/// @nodoc
abstract mixin class _$SessionAttendanceModelCopyWith<$Res> implements $SessionAttendanceModelCopyWith<$Res> {
  factory _$SessionAttendanceModelCopyWith(_SessionAttendanceModel value, $Res Function(_SessionAttendanceModel) _then) = __$SessionAttendanceModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(unknownEnumValue: AttendanceStatus.absent) AttendanceStatus status, DateTime? scanTime, SupervisorModel? supervisor
});


@override $SupervisorModelCopyWith<$Res>? get supervisor;

}
/// @nodoc
class __$SessionAttendanceModelCopyWithImpl<$Res>
    implements _$SessionAttendanceModelCopyWith<$Res> {
  __$SessionAttendanceModelCopyWithImpl(this._self, this._then);

  final _SessionAttendanceModel _self;
  final $Res Function(_SessionAttendanceModel) _then;

/// Create a copy of SessionAttendanceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? scanTime = freezed,Object? supervisor = freezed,}) {
  return _then(_SessionAttendanceModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AttendanceStatus,scanTime: freezed == scanTime ? _self.scanTime : scanTime // ignore: cast_nullable_to_non_nullable
as DateTime?,supervisor: freezed == supervisor ? _self.supervisor : supervisor // ignore: cast_nullable_to_non_nullable
as SupervisorModel?,
  ));
}

/// Create a copy of SessionAttendanceModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SupervisorModelCopyWith<$Res>? get supervisor {
    if (_self.supervisor == null) {
    return null;
  }

  return $SupervisorModelCopyWith<$Res>(_self.supervisor!, (value) {
    return _then(_self.copyWith(supervisor: value));
  });
}
}


/// @nodoc
mixin _$SupervisorModel {

 String get name; String get email;
/// Create a copy of SupervisorModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupervisorModelCopyWith<SupervisorModel> get copyWith => _$SupervisorModelCopyWithImpl<SupervisorModel>(this as SupervisorModel, _$identity);

  /// Serializes this SupervisorModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SupervisorModel&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,email);

@override
String toString() {
  return 'SupervisorModel(name: $name, email: $email)';
}


}

/// @nodoc
abstract mixin class $SupervisorModelCopyWith<$Res>  {
  factory $SupervisorModelCopyWith(SupervisorModel value, $Res Function(SupervisorModel) _then) = _$SupervisorModelCopyWithImpl;
@useResult
$Res call({
 String name, String email
});




}
/// @nodoc
class _$SupervisorModelCopyWithImpl<$Res>
    implements $SupervisorModelCopyWith<$Res> {
  _$SupervisorModelCopyWithImpl(this._self, this._then);

  final SupervisorModel _self;
  final $Res Function(SupervisorModel) _then;

/// Create a copy of SupervisorModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? email = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SupervisorModel].
extension SupervisorModelPatterns on SupervisorModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SupervisorModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SupervisorModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SupervisorModel value)  $default,){
final _that = this;
switch (_that) {
case _SupervisorModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SupervisorModel value)?  $default,){
final _that = this;
switch (_that) {
case _SupervisorModel() when $default != null:
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
case _SupervisorModel() when $default != null:
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
case _SupervisorModel():
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
case _SupervisorModel() when $default != null:
return $default(_that.name,_that.email);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SupervisorModel extends SupervisorModel {
  const _SupervisorModel({required this.name, required this.email}): super._();
  factory _SupervisorModel.fromJson(Map<String, dynamic> json) => _$SupervisorModelFromJson(json);

@override final  String name;
@override final  String email;

/// Create a copy of SupervisorModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SupervisorModelCopyWith<_SupervisorModel> get copyWith => __$SupervisorModelCopyWithImpl<_SupervisorModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SupervisorModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SupervisorModel&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,email);

@override
String toString() {
  return 'SupervisorModel(name: $name, email: $email)';
}


}

/// @nodoc
abstract mixin class _$SupervisorModelCopyWith<$Res> implements $SupervisorModelCopyWith<$Res> {
  factory _$SupervisorModelCopyWith(_SupervisorModel value, $Res Function(_SupervisorModel) _then) = __$SupervisorModelCopyWithImpl;
@override @useResult
$Res call({
 String name, String email
});




}
/// @nodoc
class __$SupervisorModelCopyWithImpl<$Res>
    implements _$SupervisorModelCopyWith<$Res> {
  __$SupervisorModelCopyWithImpl(this._self, this._then);

  final _SupervisorModel _self;
  final $Res Function(_SupervisorModel) _then;

/// Create a copy of SupervisorModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? email = null,}) {
  return _then(_SupervisorModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
