// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AttendanceResult {

 String get professorName; String get courseTitle; String? get professorPhoto;
/// Create a copy of AttendanceResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceResultCopyWith<AttendanceResult> get copyWith => _$AttendanceResultCopyWithImpl<AttendanceResult>(this as AttendanceResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceResult&&(identical(other.professorName, professorName) || other.professorName == professorName)&&(identical(other.courseTitle, courseTitle) || other.courseTitle == courseTitle)&&(identical(other.professorPhoto, professorPhoto) || other.professorPhoto == professorPhoto));
}


@override
int get hashCode => Object.hash(runtimeType,professorName,courseTitle,professorPhoto);

@override
String toString() {
  return 'AttendanceResult(professorName: $professorName, courseTitle: $courseTitle, professorPhoto: $professorPhoto)';
}


}

/// @nodoc
abstract mixin class $AttendanceResultCopyWith<$Res>  {
  factory $AttendanceResultCopyWith(AttendanceResult value, $Res Function(AttendanceResult) _then) = _$AttendanceResultCopyWithImpl;
@useResult
$Res call({
 String professorName, String courseTitle, String? professorPhoto
});




}
/// @nodoc
class _$AttendanceResultCopyWithImpl<$Res>
    implements $AttendanceResultCopyWith<$Res> {
  _$AttendanceResultCopyWithImpl(this._self, this._then);

  final AttendanceResult _self;
  final $Res Function(AttendanceResult) _then;

/// Create a copy of AttendanceResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? professorName = null,Object? courseTitle = null,Object? professorPhoto = freezed,}) {
  return _then(_self.copyWith(
professorName: null == professorName ? _self.professorName : professorName // ignore: cast_nullable_to_non_nullable
as String,courseTitle: null == courseTitle ? _self.courseTitle : courseTitle // ignore: cast_nullable_to_non_nullable
as String,professorPhoto: freezed == professorPhoto ? _self.professorPhoto : professorPhoto // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceResult].
extension AttendanceResultPatterns on AttendanceResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceResult value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceResult value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String professorName,  String courseTitle,  String? professorPhoto)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceResult() when $default != null:
return $default(_that.professorName,_that.courseTitle,_that.professorPhoto);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String professorName,  String courseTitle,  String? professorPhoto)  $default,) {final _that = this;
switch (_that) {
case _AttendanceResult():
return $default(_that.professorName,_that.courseTitle,_that.professorPhoto);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String professorName,  String courseTitle,  String? professorPhoto)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceResult() when $default != null:
return $default(_that.professorName,_that.courseTitle,_that.professorPhoto);case _:
  return null;

}
}

}

/// @nodoc


class _AttendanceResult implements AttendanceResult {
  const _AttendanceResult({required this.professorName, required this.courseTitle, this.professorPhoto});
  

@override final  String professorName;
@override final  String courseTitle;
@override final  String? professorPhoto;

/// Create a copy of AttendanceResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceResultCopyWith<_AttendanceResult> get copyWith => __$AttendanceResultCopyWithImpl<_AttendanceResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceResult&&(identical(other.professorName, professorName) || other.professorName == professorName)&&(identical(other.courseTitle, courseTitle) || other.courseTitle == courseTitle)&&(identical(other.professorPhoto, professorPhoto) || other.professorPhoto == professorPhoto));
}


@override
int get hashCode => Object.hash(runtimeType,professorName,courseTitle,professorPhoto);

@override
String toString() {
  return 'AttendanceResult(professorName: $professorName, courseTitle: $courseTitle, professorPhoto: $professorPhoto)';
}


}

/// @nodoc
abstract mixin class _$AttendanceResultCopyWith<$Res> implements $AttendanceResultCopyWith<$Res> {
  factory _$AttendanceResultCopyWith(_AttendanceResult value, $Res Function(_AttendanceResult) _then) = __$AttendanceResultCopyWithImpl;
@override @useResult
$Res call({
 String professorName, String courseTitle, String? professorPhoto
});




}
/// @nodoc
class __$AttendanceResultCopyWithImpl<$Res>
    implements _$AttendanceResultCopyWith<$Res> {
  __$AttendanceResultCopyWithImpl(this._self, this._then);

  final _AttendanceResult _self;
  final $Res Function(_AttendanceResult) _then;

/// Create a copy of AttendanceResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? professorName = null,Object? courseTitle = null,Object? professorPhoto = freezed,}) {
  return _then(_AttendanceResult(
professorName: null == professorName ? _self.professorName : professorName // ignore: cast_nullable_to_non_nullable
as String,courseTitle: null == courseTitle ? _self.courseTitle : courseTitle // ignore: cast_nullable_to_non_nullable
as String,professorPhoto: freezed == professorPhoto ? _self.professorPhoto : professorPhoto // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
