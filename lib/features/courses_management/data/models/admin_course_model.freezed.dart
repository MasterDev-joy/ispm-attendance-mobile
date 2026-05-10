// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_course_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminCourseModel {

 String get id; String get title;@JsonKey(name: 'fieldOfStudy') String get fieldOfStudy; String get professorName; String get professorId; String get startTime; String get endTime; bool get isActive;
/// Create a copy of AdminCourseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminCourseModelCopyWith<AdminCourseModel> get copyWith => _$AdminCourseModelCopyWithImpl<AdminCourseModel>(this as AdminCourseModel, _$identity);

  /// Serializes this AdminCourseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminCourseModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.fieldOfStudy, fieldOfStudy) || other.fieldOfStudy == fieldOfStudy)&&(identical(other.professorName, professorName) || other.professorName == professorName)&&(identical(other.professorId, professorId) || other.professorId == professorId)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,fieldOfStudy,professorName,professorId,startTime,endTime,isActive);

@override
String toString() {
  return 'AdminCourseModel(id: $id, title: $title, fieldOfStudy: $fieldOfStudy, professorName: $professorName, professorId: $professorId, startTime: $startTime, endTime: $endTime, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $AdminCourseModelCopyWith<$Res>  {
  factory $AdminCourseModelCopyWith(AdminCourseModel value, $Res Function(AdminCourseModel) _then) = _$AdminCourseModelCopyWithImpl;
@useResult
$Res call({
 String id, String title,@JsonKey(name: 'fieldOfStudy') String fieldOfStudy, String professorName, String professorId, String startTime, String endTime, bool isActive
});




}
/// @nodoc
class _$AdminCourseModelCopyWithImpl<$Res>
    implements $AdminCourseModelCopyWith<$Res> {
  _$AdminCourseModelCopyWithImpl(this._self, this._then);

  final AdminCourseModel _self;
  final $Res Function(AdminCourseModel) _then;

/// Create a copy of AdminCourseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? fieldOfStudy = null,Object? professorName = null,Object? professorId = null,Object? startTime = null,Object? endTime = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,fieldOfStudy: null == fieldOfStudy ? _self.fieldOfStudy : fieldOfStudy // ignore: cast_nullable_to_non_nullable
as String,professorName: null == professorName ? _self.professorName : professorName // ignore: cast_nullable_to_non_nullable
as String,professorId: null == professorId ? _self.professorId : professorId // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminCourseModel].
extension AdminCourseModelPatterns on AdminCourseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminCourseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminCourseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminCourseModel value)  $default,){
final _that = this;
switch (_that) {
case _AdminCourseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminCourseModel value)?  $default,){
final _that = this;
switch (_that) {
case _AdminCourseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title, @JsonKey(name: 'fieldOfStudy')  String fieldOfStudy,  String professorName,  String professorId,  String startTime,  String endTime,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminCourseModel() when $default != null:
return $default(_that.id,_that.title,_that.fieldOfStudy,_that.professorName,_that.professorId,_that.startTime,_that.endTime,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title, @JsonKey(name: 'fieldOfStudy')  String fieldOfStudy,  String professorName,  String professorId,  String startTime,  String endTime,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _AdminCourseModel():
return $default(_that.id,_that.title,_that.fieldOfStudy,_that.professorName,_that.professorId,_that.startTime,_that.endTime,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title, @JsonKey(name: 'fieldOfStudy')  String fieldOfStudy,  String professorName,  String professorId,  String startTime,  String endTime,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _AdminCourseModel() when $default != null:
return $default(_that.id,_that.title,_that.fieldOfStudy,_that.professorName,_that.professorId,_that.startTime,_that.endTime,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminCourseModel extends AdminCourseModel {
  const _AdminCourseModel({required this.id, required this.title, @JsonKey(name: 'fieldOfStudy') required this.fieldOfStudy, this.professorName = '', this.professorId = '', required this.startTime, required this.endTime, this.isActive = true}): super._();
  factory _AdminCourseModel.fromJson(Map<String, dynamic> json) => _$AdminCourseModelFromJson(json);

@override final  String id;
@override final  String title;
@override@JsonKey(name: 'fieldOfStudy') final  String fieldOfStudy;
@override@JsonKey() final  String professorName;
@override@JsonKey() final  String professorId;
@override final  String startTime;
@override final  String endTime;
@override@JsonKey() final  bool isActive;

/// Create a copy of AdminCourseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminCourseModelCopyWith<_AdminCourseModel> get copyWith => __$AdminCourseModelCopyWithImpl<_AdminCourseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminCourseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminCourseModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.fieldOfStudy, fieldOfStudy) || other.fieldOfStudy == fieldOfStudy)&&(identical(other.professorName, professorName) || other.professorName == professorName)&&(identical(other.professorId, professorId) || other.professorId == professorId)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,fieldOfStudy,professorName,professorId,startTime,endTime,isActive);

@override
String toString() {
  return 'AdminCourseModel(id: $id, title: $title, fieldOfStudy: $fieldOfStudy, professorName: $professorName, professorId: $professorId, startTime: $startTime, endTime: $endTime, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$AdminCourseModelCopyWith<$Res> implements $AdminCourseModelCopyWith<$Res> {
  factory _$AdminCourseModelCopyWith(_AdminCourseModel value, $Res Function(_AdminCourseModel) _then) = __$AdminCourseModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title,@JsonKey(name: 'fieldOfStudy') String fieldOfStudy, String professorName, String professorId, String startTime, String endTime, bool isActive
});




}
/// @nodoc
class __$AdminCourseModelCopyWithImpl<$Res>
    implements _$AdminCourseModelCopyWith<$Res> {
  __$AdminCourseModelCopyWithImpl(this._self, this._then);

  final _AdminCourseModel _self;
  final $Res Function(_AdminCourseModel) _then;

/// Create a copy of AdminCourseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? fieldOfStudy = null,Object? professorName = null,Object? professorId = null,Object? startTime = null,Object? endTime = null,Object? isActive = null,}) {
  return _then(_AdminCourseModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,fieldOfStudy: null == fieldOfStudy ? _self.fieldOfStudy : fieldOfStudy // ignore: cast_nullable_to_non_nullable
as String,professorName: null == professorName ? _self.professorName : professorName // ignore: cast_nullable_to_non_nullable
as String,professorId: null == professorId ? _self.professorId : professorId // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
