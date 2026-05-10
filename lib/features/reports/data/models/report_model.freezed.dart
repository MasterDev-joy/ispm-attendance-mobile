// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GlobalReportModel {

 int get totalCourses; int get validatedCourses; int get uncoveredCourses; int get totalProfessors; int get totalSupervisors; double get validationRate; List<ProfReportModel> get perProfessor;
/// Create a copy of GlobalReportModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GlobalReportModelCopyWith<GlobalReportModel> get copyWith => _$GlobalReportModelCopyWithImpl<GlobalReportModel>(this as GlobalReportModel, _$identity);

  /// Serializes this GlobalReportModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GlobalReportModel&&(identical(other.totalCourses, totalCourses) || other.totalCourses == totalCourses)&&(identical(other.validatedCourses, validatedCourses) || other.validatedCourses == validatedCourses)&&(identical(other.uncoveredCourses, uncoveredCourses) || other.uncoveredCourses == uncoveredCourses)&&(identical(other.totalProfessors, totalProfessors) || other.totalProfessors == totalProfessors)&&(identical(other.totalSupervisors, totalSupervisors) || other.totalSupervisors == totalSupervisors)&&(identical(other.validationRate, validationRate) || other.validationRate == validationRate)&&const DeepCollectionEquality().equals(other.perProfessor, perProfessor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalCourses,validatedCourses,uncoveredCourses,totalProfessors,totalSupervisors,validationRate,const DeepCollectionEquality().hash(perProfessor));

@override
String toString() {
  return 'GlobalReportModel(totalCourses: $totalCourses, validatedCourses: $validatedCourses, uncoveredCourses: $uncoveredCourses, totalProfessors: $totalProfessors, totalSupervisors: $totalSupervisors, validationRate: $validationRate, perProfessor: $perProfessor)';
}


}

/// @nodoc
abstract mixin class $GlobalReportModelCopyWith<$Res>  {
  factory $GlobalReportModelCopyWith(GlobalReportModel value, $Res Function(GlobalReportModel) _then) = _$GlobalReportModelCopyWithImpl;
@useResult
$Res call({
 int totalCourses, int validatedCourses, int uncoveredCourses, int totalProfessors, int totalSupervisors, double validationRate, List<ProfReportModel> perProfessor
});




}
/// @nodoc
class _$GlobalReportModelCopyWithImpl<$Res>
    implements $GlobalReportModelCopyWith<$Res> {
  _$GlobalReportModelCopyWithImpl(this._self, this._then);

  final GlobalReportModel _self;
  final $Res Function(GlobalReportModel) _then;

/// Create a copy of GlobalReportModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalCourses = null,Object? validatedCourses = null,Object? uncoveredCourses = null,Object? totalProfessors = null,Object? totalSupervisors = null,Object? validationRate = null,Object? perProfessor = null,}) {
  return _then(_self.copyWith(
totalCourses: null == totalCourses ? _self.totalCourses : totalCourses // ignore: cast_nullable_to_non_nullable
as int,validatedCourses: null == validatedCourses ? _self.validatedCourses : validatedCourses // ignore: cast_nullable_to_non_nullable
as int,uncoveredCourses: null == uncoveredCourses ? _self.uncoveredCourses : uncoveredCourses // ignore: cast_nullable_to_non_nullable
as int,totalProfessors: null == totalProfessors ? _self.totalProfessors : totalProfessors // ignore: cast_nullable_to_non_nullable
as int,totalSupervisors: null == totalSupervisors ? _self.totalSupervisors : totalSupervisors // ignore: cast_nullable_to_non_nullable
as int,validationRate: null == validationRate ? _self.validationRate : validationRate // ignore: cast_nullable_to_non_nullable
as double,perProfessor: null == perProfessor ? _self.perProfessor : perProfessor // ignore: cast_nullable_to_non_nullable
as List<ProfReportModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [GlobalReportModel].
extension GlobalReportModelPatterns on GlobalReportModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GlobalReportModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GlobalReportModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GlobalReportModel value)  $default,){
final _that = this;
switch (_that) {
case _GlobalReportModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GlobalReportModel value)?  $default,){
final _that = this;
switch (_that) {
case _GlobalReportModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalCourses,  int validatedCourses,  int uncoveredCourses,  int totalProfessors,  int totalSupervisors,  double validationRate,  List<ProfReportModel> perProfessor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GlobalReportModel() when $default != null:
return $default(_that.totalCourses,_that.validatedCourses,_that.uncoveredCourses,_that.totalProfessors,_that.totalSupervisors,_that.validationRate,_that.perProfessor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalCourses,  int validatedCourses,  int uncoveredCourses,  int totalProfessors,  int totalSupervisors,  double validationRate,  List<ProfReportModel> perProfessor)  $default,) {final _that = this;
switch (_that) {
case _GlobalReportModel():
return $default(_that.totalCourses,_that.validatedCourses,_that.uncoveredCourses,_that.totalProfessors,_that.totalSupervisors,_that.validationRate,_that.perProfessor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalCourses,  int validatedCourses,  int uncoveredCourses,  int totalProfessors,  int totalSupervisors,  double validationRate,  List<ProfReportModel> perProfessor)?  $default,) {final _that = this;
switch (_that) {
case _GlobalReportModel() when $default != null:
return $default(_that.totalCourses,_that.validatedCourses,_that.uncoveredCourses,_that.totalProfessors,_that.totalSupervisors,_that.validationRate,_that.perProfessor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GlobalReportModel extends GlobalReportModel {
  const _GlobalReportModel({this.totalCourses = 0, this.validatedCourses = 0, this.uncoveredCourses = 0, this.totalProfessors = 0, this.totalSupervisors = 0, this.validationRate = 0.0, final  List<ProfReportModel> perProfessor = const []}): _perProfessor = perProfessor,super._();
  factory _GlobalReportModel.fromJson(Map<String, dynamic> json) => _$GlobalReportModelFromJson(json);

@override@JsonKey() final  int totalCourses;
@override@JsonKey() final  int validatedCourses;
@override@JsonKey() final  int uncoveredCourses;
@override@JsonKey() final  int totalProfessors;
@override@JsonKey() final  int totalSupervisors;
@override@JsonKey() final  double validationRate;
 final  List<ProfReportModel> _perProfessor;
@override@JsonKey() List<ProfReportModel> get perProfessor {
  if (_perProfessor is EqualUnmodifiableListView) return _perProfessor;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_perProfessor);
}


/// Create a copy of GlobalReportModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GlobalReportModelCopyWith<_GlobalReportModel> get copyWith => __$GlobalReportModelCopyWithImpl<_GlobalReportModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GlobalReportModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GlobalReportModel&&(identical(other.totalCourses, totalCourses) || other.totalCourses == totalCourses)&&(identical(other.validatedCourses, validatedCourses) || other.validatedCourses == validatedCourses)&&(identical(other.uncoveredCourses, uncoveredCourses) || other.uncoveredCourses == uncoveredCourses)&&(identical(other.totalProfessors, totalProfessors) || other.totalProfessors == totalProfessors)&&(identical(other.totalSupervisors, totalSupervisors) || other.totalSupervisors == totalSupervisors)&&(identical(other.validationRate, validationRate) || other.validationRate == validationRate)&&const DeepCollectionEquality().equals(other._perProfessor, _perProfessor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalCourses,validatedCourses,uncoveredCourses,totalProfessors,totalSupervisors,validationRate,const DeepCollectionEquality().hash(_perProfessor));

@override
String toString() {
  return 'GlobalReportModel(totalCourses: $totalCourses, validatedCourses: $validatedCourses, uncoveredCourses: $uncoveredCourses, totalProfessors: $totalProfessors, totalSupervisors: $totalSupervisors, validationRate: $validationRate, perProfessor: $perProfessor)';
}


}

/// @nodoc
abstract mixin class _$GlobalReportModelCopyWith<$Res> implements $GlobalReportModelCopyWith<$Res> {
  factory _$GlobalReportModelCopyWith(_GlobalReportModel value, $Res Function(_GlobalReportModel) _then) = __$GlobalReportModelCopyWithImpl;
@override @useResult
$Res call({
 int totalCourses, int validatedCourses, int uncoveredCourses, int totalProfessors, int totalSupervisors, double validationRate, List<ProfReportModel> perProfessor
});




}
/// @nodoc
class __$GlobalReportModelCopyWithImpl<$Res>
    implements _$GlobalReportModelCopyWith<$Res> {
  __$GlobalReportModelCopyWithImpl(this._self, this._then);

  final _GlobalReportModel _self;
  final $Res Function(_GlobalReportModel) _then;

/// Create a copy of GlobalReportModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalCourses = null,Object? validatedCourses = null,Object? uncoveredCourses = null,Object? totalProfessors = null,Object? totalSupervisors = null,Object? validationRate = null,Object? perProfessor = null,}) {
  return _then(_GlobalReportModel(
totalCourses: null == totalCourses ? _self.totalCourses : totalCourses // ignore: cast_nullable_to_non_nullable
as int,validatedCourses: null == validatedCourses ? _self.validatedCourses : validatedCourses // ignore: cast_nullable_to_non_nullable
as int,uncoveredCourses: null == uncoveredCourses ? _self.uncoveredCourses : uncoveredCourses // ignore: cast_nullable_to_non_nullable
as int,totalProfessors: null == totalProfessors ? _self.totalProfessors : totalProfessors // ignore: cast_nullable_to_non_nullable
as int,totalSupervisors: null == totalSupervisors ? _self.totalSupervisors : totalSupervisors // ignore: cast_nullable_to_non_nullable
as int,validationRate: null == validationRate ? _self.validationRate : validationRate // ignore: cast_nullable_to_non_nullable
as double,perProfessor: null == perProfessor ? _self._perProfessor : perProfessor // ignore: cast_nullable_to_non_nullable
as List<ProfReportModel>,
  ));
}


}


/// @nodoc
mixin _$ProfReportModel {

 String get name; int get courses; int get validated; double get rate;
/// Create a copy of ProfReportModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfReportModelCopyWith<ProfReportModel> get copyWith => _$ProfReportModelCopyWithImpl<ProfReportModel>(this as ProfReportModel, _$identity);

  /// Serializes this ProfReportModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfReportModel&&(identical(other.name, name) || other.name == name)&&(identical(other.courses, courses) || other.courses == courses)&&(identical(other.validated, validated) || other.validated == validated)&&(identical(other.rate, rate) || other.rate == rate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,courses,validated,rate);

@override
String toString() {
  return 'ProfReportModel(name: $name, courses: $courses, validated: $validated, rate: $rate)';
}


}

/// @nodoc
abstract mixin class $ProfReportModelCopyWith<$Res>  {
  factory $ProfReportModelCopyWith(ProfReportModel value, $Res Function(ProfReportModel) _then) = _$ProfReportModelCopyWithImpl;
@useResult
$Res call({
 String name, int courses, int validated, double rate
});




}
/// @nodoc
class _$ProfReportModelCopyWithImpl<$Res>
    implements $ProfReportModelCopyWith<$Res> {
  _$ProfReportModelCopyWithImpl(this._self, this._then);

  final ProfReportModel _self;
  final $Res Function(ProfReportModel) _then;

/// Create a copy of ProfReportModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? courses = null,Object? validated = null,Object? rate = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,courses: null == courses ? _self.courses : courses // ignore: cast_nullable_to_non_nullable
as int,validated: null == validated ? _self.validated : validated // ignore: cast_nullable_to_non_nullable
as int,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfReportModel].
extension ProfReportModelPatterns on ProfReportModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfReportModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfReportModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfReportModel value)  $default,){
final _that = this;
switch (_that) {
case _ProfReportModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfReportModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProfReportModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int courses,  int validated,  double rate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfReportModel() when $default != null:
return $default(_that.name,_that.courses,_that.validated,_that.rate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int courses,  int validated,  double rate)  $default,) {final _that = this;
switch (_that) {
case _ProfReportModel():
return $default(_that.name,_that.courses,_that.validated,_that.rate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int courses,  int validated,  double rate)?  $default,) {final _that = this;
switch (_that) {
case _ProfReportModel() when $default != null:
return $default(_that.name,_that.courses,_that.validated,_that.rate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfReportModel extends ProfReportModel {
  const _ProfReportModel({this.name = '', this.courses = 0, this.validated = 0, this.rate = 0.0}): super._();
  factory _ProfReportModel.fromJson(Map<String, dynamic> json) => _$ProfReportModelFromJson(json);

@override@JsonKey() final  String name;
@override@JsonKey() final  int courses;
@override@JsonKey() final  int validated;
@override@JsonKey() final  double rate;

/// Create a copy of ProfReportModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfReportModelCopyWith<_ProfReportModel> get copyWith => __$ProfReportModelCopyWithImpl<_ProfReportModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfReportModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfReportModel&&(identical(other.name, name) || other.name == name)&&(identical(other.courses, courses) || other.courses == courses)&&(identical(other.validated, validated) || other.validated == validated)&&(identical(other.rate, rate) || other.rate == rate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,courses,validated,rate);

@override
String toString() {
  return 'ProfReportModel(name: $name, courses: $courses, validated: $validated, rate: $rate)';
}


}

/// @nodoc
abstract mixin class _$ProfReportModelCopyWith<$Res> implements $ProfReportModelCopyWith<$Res> {
  factory _$ProfReportModelCopyWith(_ProfReportModel value, $Res Function(_ProfReportModel) _then) = __$ProfReportModelCopyWithImpl;
@override @useResult
$Res call({
 String name, int courses, int validated, double rate
});




}
/// @nodoc
class __$ProfReportModelCopyWithImpl<$Res>
    implements _$ProfReportModelCopyWith<$Res> {
  __$ProfReportModelCopyWithImpl(this._self, this._then);

  final _ProfReportModel _self;
  final $Res Function(_ProfReportModel) _then;

/// Create a copy of ProfReportModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? courses = null,Object? validated = null,Object? rate = null,}) {
  return _then(_ProfReportModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,courses: null == courses ? _self.courses : courses // ignore: cast_nullable_to_non_nullable
as int,validated: null == validated ? _self.validated : validated // ignore: cast_nullable_to_non_nullable
as int,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
