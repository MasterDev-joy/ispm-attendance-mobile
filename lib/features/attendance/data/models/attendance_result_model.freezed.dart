// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_result_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AttendanceResultModel {

// @JsonKey mappe le nom JSON → le nom Dart
@JsonKey(name: 'professor') String get professorName;@JsonKey(name: 'course') String get courseTitle;@JsonKey(name: 'profilePicture') String? get professorPhoto;// Ces champs existent dans la réponse, autant les capturer
 String? get attendanceId; String? get status; DateTime? get scanTime;
/// Create a copy of AttendanceResultModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceResultModelCopyWith<AttendanceResultModel> get copyWith => _$AttendanceResultModelCopyWithImpl<AttendanceResultModel>(this as AttendanceResultModel, _$identity);

  /// Serializes this AttendanceResultModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceResultModel&&(identical(other.professorName, professorName) || other.professorName == professorName)&&(identical(other.courseTitle, courseTitle) || other.courseTitle == courseTitle)&&(identical(other.professorPhoto, professorPhoto) || other.professorPhoto == professorPhoto)&&(identical(other.attendanceId, attendanceId) || other.attendanceId == attendanceId)&&(identical(other.status, status) || other.status == status)&&(identical(other.scanTime, scanTime) || other.scanTime == scanTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,professorName,courseTitle,professorPhoto,attendanceId,status,scanTime);

@override
String toString() {
  return 'AttendanceResultModel(professorName: $professorName, courseTitle: $courseTitle, professorPhoto: $professorPhoto, attendanceId: $attendanceId, status: $status, scanTime: $scanTime)';
}


}

/// @nodoc
abstract mixin class $AttendanceResultModelCopyWith<$Res>  {
  factory $AttendanceResultModelCopyWith(AttendanceResultModel value, $Res Function(AttendanceResultModel) _then) = _$AttendanceResultModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'professor') String professorName,@JsonKey(name: 'course') String courseTitle,@JsonKey(name: 'profilePicture') String? professorPhoto, String? attendanceId, String? status, DateTime? scanTime
});




}
/// @nodoc
class _$AttendanceResultModelCopyWithImpl<$Res>
    implements $AttendanceResultModelCopyWith<$Res> {
  _$AttendanceResultModelCopyWithImpl(this._self, this._then);

  final AttendanceResultModel _self;
  final $Res Function(AttendanceResultModel) _then;

/// Create a copy of AttendanceResultModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? professorName = null,Object? courseTitle = null,Object? professorPhoto = freezed,Object? attendanceId = freezed,Object? status = freezed,Object? scanTime = freezed,}) {
  return _then(_self.copyWith(
professorName: null == professorName ? _self.professorName : professorName // ignore: cast_nullable_to_non_nullable
as String,courseTitle: null == courseTitle ? _self.courseTitle : courseTitle // ignore: cast_nullable_to_non_nullable
as String,professorPhoto: freezed == professorPhoto ? _self.professorPhoto : professorPhoto // ignore: cast_nullable_to_non_nullable
as String?,attendanceId: freezed == attendanceId ? _self.attendanceId : attendanceId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,scanTime: freezed == scanTime ? _self.scanTime : scanTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceResultModel].
extension AttendanceResultModelPatterns on AttendanceResultModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceResultModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceResultModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceResultModel value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceResultModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceResultModel value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceResultModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'professor')  String professorName, @JsonKey(name: 'course')  String courseTitle, @JsonKey(name: 'profilePicture')  String? professorPhoto,  String? attendanceId,  String? status,  DateTime? scanTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceResultModel() when $default != null:
return $default(_that.professorName,_that.courseTitle,_that.professorPhoto,_that.attendanceId,_that.status,_that.scanTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'professor')  String professorName, @JsonKey(name: 'course')  String courseTitle, @JsonKey(name: 'profilePicture')  String? professorPhoto,  String? attendanceId,  String? status,  DateTime? scanTime)  $default,) {final _that = this;
switch (_that) {
case _AttendanceResultModel():
return $default(_that.professorName,_that.courseTitle,_that.professorPhoto,_that.attendanceId,_that.status,_that.scanTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'professor')  String professorName, @JsonKey(name: 'course')  String courseTitle, @JsonKey(name: 'profilePicture')  String? professorPhoto,  String? attendanceId,  String? status,  DateTime? scanTime)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceResultModel() when $default != null:
return $default(_that.professorName,_that.courseTitle,_that.professorPhoto,_that.attendanceId,_that.status,_that.scanTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttendanceResultModel extends AttendanceResultModel {
  const _AttendanceResultModel({@JsonKey(name: 'professor') required this.professorName, @JsonKey(name: 'course') required this.courseTitle, @JsonKey(name: 'profilePicture') this.professorPhoto, this.attendanceId, this.status, this.scanTime}): super._();
  factory _AttendanceResultModel.fromJson(Map<String, dynamic> json) => _$AttendanceResultModelFromJson(json);

// @JsonKey mappe le nom JSON → le nom Dart
@override@JsonKey(name: 'professor') final  String professorName;
@override@JsonKey(name: 'course') final  String courseTitle;
@override@JsonKey(name: 'profilePicture') final  String? professorPhoto;
// Ces champs existent dans la réponse, autant les capturer
@override final  String? attendanceId;
@override final  String? status;
@override final  DateTime? scanTime;

/// Create a copy of AttendanceResultModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceResultModelCopyWith<_AttendanceResultModel> get copyWith => __$AttendanceResultModelCopyWithImpl<_AttendanceResultModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendanceResultModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceResultModel&&(identical(other.professorName, professorName) || other.professorName == professorName)&&(identical(other.courseTitle, courseTitle) || other.courseTitle == courseTitle)&&(identical(other.professorPhoto, professorPhoto) || other.professorPhoto == professorPhoto)&&(identical(other.attendanceId, attendanceId) || other.attendanceId == attendanceId)&&(identical(other.status, status) || other.status == status)&&(identical(other.scanTime, scanTime) || other.scanTime == scanTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,professorName,courseTitle,professorPhoto,attendanceId,status,scanTime);

@override
String toString() {
  return 'AttendanceResultModel(professorName: $professorName, courseTitle: $courseTitle, professorPhoto: $professorPhoto, attendanceId: $attendanceId, status: $status, scanTime: $scanTime)';
}


}

/// @nodoc
abstract mixin class _$AttendanceResultModelCopyWith<$Res> implements $AttendanceResultModelCopyWith<$Res> {
  factory _$AttendanceResultModelCopyWith(_AttendanceResultModel value, $Res Function(_AttendanceResultModel) _then) = __$AttendanceResultModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'professor') String professorName,@JsonKey(name: 'course') String courseTitle,@JsonKey(name: 'profilePicture') String? professorPhoto, String? attendanceId, String? status, DateTime? scanTime
});




}
/// @nodoc
class __$AttendanceResultModelCopyWithImpl<$Res>
    implements _$AttendanceResultModelCopyWith<$Res> {
  __$AttendanceResultModelCopyWithImpl(this._self, this._then);

  final _AttendanceResultModel _self;
  final $Res Function(_AttendanceResultModel) _then;

/// Create a copy of AttendanceResultModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? professorName = null,Object? courseTitle = null,Object? professorPhoto = freezed,Object? attendanceId = freezed,Object? status = freezed,Object? scanTime = freezed,}) {
  return _then(_AttendanceResultModel(
professorName: null == professorName ? _self.professorName : professorName // ignore: cast_nullable_to_non_nullable
as String,courseTitle: null == courseTitle ? _self.courseTitle : courseTitle // ignore: cast_nullable_to_non_nullable
as String,professorPhoto: freezed == professorPhoto ? _self.professorPhoto : professorPhoto // ignore: cast_nullable_to_non_nullable
as String?,attendanceId: freezed == attendanceId ? _self.attendanceId : attendanceId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,scanTime: freezed == scanTime ? _self.scanTime : scanTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
