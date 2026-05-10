// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GlobalReport {

 int get totalCourses; int get validatedCourses; int get uncoveredCourses; int get totalProfessors; int get totalSupervisors; double get validationRate; List<ProfReport> get perProfessor;
/// Create a copy of GlobalReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GlobalReportCopyWith<GlobalReport> get copyWith => _$GlobalReportCopyWithImpl<GlobalReport>(this as GlobalReport, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GlobalReport&&(identical(other.totalCourses, totalCourses) || other.totalCourses == totalCourses)&&(identical(other.validatedCourses, validatedCourses) || other.validatedCourses == validatedCourses)&&(identical(other.uncoveredCourses, uncoveredCourses) || other.uncoveredCourses == uncoveredCourses)&&(identical(other.totalProfessors, totalProfessors) || other.totalProfessors == totalProfessors)&&(identical(other.totalSupervisors, totalSupervisors) || other.totalSupervisors == totalSupervisors)&&(identical(other.validationRate, validationRate) || other.validationRate == validationRate)&&const DeepCollectionEquality().equals(other.perProfessor, perProfessor));
}


@override
int get hashCode => Object.hash(runtimeType,totalCourses,validatedCourses,uncoveredCourses,totalProfessors,totalSupervisors,validationRate,const DeepCollectionEquality().hash(perProfessor));

@override
String toString() {
  return 'GlobalReport(totalCourses: $totalCourses, validatedCourses: $validatedCourses, uncoveredCourses: $uncoveredCourses, totalProfessors: $totalProfessors, totalSupervisors: $totalSupervisors, validationRate: $validationRate, perProfessor: $perProfessor)';
}


}

/// @nodoc
abstract mixin class $GlobalReportCopyWith<$Res>  {
  factory $GlobalReportCopyWith(GlobalReport value, $Res Function(GlobalReport) _then) = _$GlobalReportCopyWithImpl;
@useResult
$Res call({
 int totalCourses, int validatedCourses, int uncoveredCourses, int totalProfessors, int totalSupervisors, double validationRate, List<ProfReport> perProfessor
});




}
/// @nodoc
class _$GlobalReportCopyWithImpl<$Res>
    implements $GlobalReportCopyWith<$Res> {
  _$GlobalReportCopyWithImpl(this._self, this._then);

  final GlobalReport _self;
  final $Res Function(GlobalReport) _then;

/// Create a copy of GlobalReport
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
as List<ProfReport>,
  ));
}

}


/// Adds pattern-matching-related methods to [GlobalReport].
extension GlobalReportPatterns on GlobalReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GlobalReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GlobalReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GlobalReport value)  $default,){
final _that = this;
switch (_that) {
case _GlobalReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GlobalReport value)?  $default,){
final _that = this;
switch (_that) {
case _GlobalReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalCourses,  int validatedCourses,  int uncoveredCourses,  int totalProfessors,  int totalSupervisors,  double validationRate,  List<ProfReport> perProfessor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GlobalReport() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalCourses,  int validatedCourses,  int uncoveredCourses,  int totalProfessors,  int totalSupervisors,  double validationRate,  List<ProfReport> perProfessor)  $default,) {final _that = this;
switch (_that) {
case _GlobalReport():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalCourses,  int validatedCourses,  int uncoveredCourses,  int totalProfessors,  int totalSupervisors,  double validationRate,  List<ProfReport> perProfessor)?  $default,) {final _that = this;
switch (_that) {
case _GlobalReport() when $default != null:
return $default(_that.totalCourses,_that.validatedCourses,_that.uncoveredCourses,_that.totalProfessors,_that.totalSupervisors,_that.validationRate,_that.perProfessor);case _:
  return null;

}
}

}

/// @nodoc


class _GlobalReport implements GlobalReport {
  const _GlobalReport({required this.totalCourses, required this.validatedCourses, required this.uncoveredCourses, required this.totalProfessors, required this.totalSupervisors, required this.validationRate, required final  List<ProfReport> perProfessor}): _perProfessor = perProfessor;
  

@override final  int totalCourses;
@override final  int validatedCourses;
@override final  int uncoveredCourses;
@override final  int totalProfessors;
@override final  int totalSupervisors;
@override final  double validationRate;
 final  List<ProfReport> _perProfessor;
@override List<ProfReport> get perProfessor {
  if (_perProfessor is EqualUnmodifiableListView) return _perProfessor;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_perProfessor);
}


/// Create a copy of GlobalReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GlobalReportCopyWith<_GlobalReport> get copyWith => __$GlobalReportCopyWithImpl<_GlobalReport>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GlobalReport&&(identical(other.totalCourses, totalCourses) || other.totalCourses == totalCourses)&&(identical(other.validatedCourses, validatedCourses) || other.validatedCourses == validatedCourses)&&(identical(other.uncoveredCourses, uncoveredCourses) || other.uncoveredCourses == uncoveredCourses)&&(identical(other.totalProfessors, totalProfessors) || other.totalProfessors == totalProfessors)&&(identical(other.totalSupervisors, totalSupervisors) || other.totalSupervisors == totalSupervisors)&&(identical(other.validationRate, validationRate) || other.validationRate == validationRate)&&const DeepCollectionEquality().equals(other._perProfessor, _perProfessor));
}


@override
int get hashCode => Object.hash(runtimeType,totalCourses,validatedCourses,uncoveredCourses,totalProfessors,totalSupervisors,validationRate,const DeepCollectionEquality().hash(_perProfessor));

@override
String toString() {
  return 'GlobalReport(totalCourses: $totalCourses, validatedCourses: $validatedCourses, uncoveredCourses: $uncoveredCourses, totalProfessors: $totalProfessors, totalSupervisors: $totalSupervisors, validationRate: $validationRate, perProfessor: $perProfessor)';
}


}

/// @nodoc
abstract mixin class _$GlobalReportCopyWith<$Res> implements $GlobalReportCopyWith<$Res> {
  factory _$GlobalReportCopyWith(_GlobalReport value, $Res Function(_GlobalReport) _then) = __$GlobalReportCopyWithImpl;
@override @useResult
$Res call({
 int totalCourses, int validatedCourses, int uncoveredCourses, int totalProfessors, int totalSupervisors, double validationRate, List<ProfReport> perProfessor
});




}
/// @nodoc
class __$GlobalReportCopyWithImpl<$Res>
    implements _$GlobalReportCopyWith<$Res> {
  __$GlobalReportCopyWithImpl(this._self, this._then);

  final _GlobalReport _self;
  final $Res Function(_GlobalReport) _then;

/// Create a copy of GlobalReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalCourses = null,Object? validatedCourses = null,Object? uncoveredCourses = null,Object? totalProfessors = null,Object? totalSupervisors = null,Object? validationRate = null,Object? perProfessor = null,}) {
  return _then(_GlobalReport(
totalCourses: null == totalCourses ? _self.totalCourses : totalCourses // ignore: cast_nullable_to_non_nullable
as int,validatedCourses: null == validatedCourses ? _self.validatedCourses : validatedCourses // ignore: cast_nullable_to_non_nullable
as int,uncoveredCourses: null == uncoveredCourses ? _self.uncoveredCourses : uncoveredCourses // ignore: cast_nullable_to_non_nullable
as int,totalProfessors: null == totalProfessors ? _self.totalProfessors : totalProfessors // ignore: cast_nullable_to_non_nullable
as int,totalSupervisors: null == totalSupervisors ? _self.totalSupervisors : totalSupervisors // ignore: cast_nullable_to_non_nullable
as int,validationRate: null == validationRate ? _self.validationRate : validationRate // ignore: cast_nullable_to_non_nullable
as double,perProfessor: null == perProfessor ? _self._perProfessor : perProfessor // ignore: cast_nullable_to_non_nullable
as List<ProfReport>,
  ));
}


}

/// @nodoc
mixin _$ProfReport {

 String get name; int get courses; int get validated; double get rate;
/// Create a copy of ProfReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfReportCopyWith<ProfReport> get copyWith => _$ProfReportCopyWithImpl<ProfReport>(this as ProfReport, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfReport&&(identical(other.name, name) || other.name == name)&&(identical(other.courses, courses) || other.courses == courses)&&(identical(other.validated, validated) || other.validated == validated)&&(identical(other.rate, rate) || other.rate == rate));
}


@override
int get hashCode => Object.hash(runtimeType,name,courses,validated,rate);

@override
String toString() {
  return 'ProfReport(name: $name, courses: $courses, validated: $validated, rate: $rate)';
}


}

/// @nodoc
abstract mixin class $ProfReportCopyWith<$Res>  {
  factory $ProfReportCopyWith(ProfReport value, $Res Function(ProfReport) _then) = _$ProfReportCopyWithImpl;
@useResult
$Res call({
 String name, int courses, int validated, double rate
});




}
/// @nodoc
class _$ProfReportCopyWithImpl<$Res>
    implements $ProfReportCopyWith<$Res> {
  _$ProfReportCopyWithImpl(this._self, this._then);

  final ProfReport _self;
  final $Res Function(ProfReport) _then;

/// Create a copy of ProfReport
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


/// Adds pattern-matching-related methods to [ProfReport].
extension ProfReportPatterns on ProfReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfReport value)  $default,){
final _that = this;
switch (_that) {
case _ProfReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfReport value)?  $default,){
final _that = this;
switch (_that) {
case _ProfReport() when $default != null:
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
case _ProfReport() when $default != null:
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
case _ProfReport():
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
case _ProfReport() when $default != null:
return $default(_that.name,_that.courses,_that.validated,_that.rate);case _:
  return null;

}
}

}

/// @nodoc


class _ProfReport implements ProfReport {
  const _ProfReport({required this.name, required this.courses, required this.validated, required this.rate});
  

@override final  String name;
@override final  int courses;
@override final  int validated;
@override final  double rate;

/// Create a copy of ProfReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfReportCopyWith<_ProfReport> get copyWith => __$ProfReportCopyWithImpl<_ProfReport>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfReport&&(identical(other.name, name) || other.name == name)&&(identical(other.courses, courses) || other.courses == courses)&&(identical(other.validated, validated) || other.validated == validated)&&(identical(other.rate, rate) || other.rate == rate));
}


@override
int get hashCode => Object.hash(runtimeType,name,courses,validated,rate);

@override
String toString() {
  return 'ProfReport(name: $name, courses: $courses, validated: $validated, rate: $rate)';
}


}

/// @nodoc
abstract mixin class _$ProfReportCopyWith<$Res> implements $ProfReportCopyWith<$Res> {
  factory _$ProfReportCopyWith(_ProfReport value, $Res Function(_ProfReport) _then) = __$ProfReportCopyWithImpl;
@override @useResult
$Res call({
 String name, int courses, int validated, double rate
});




}
/// @nodoc
class __$ProfReportCopyWithImpl<$Res>
    implements _$ProfReportCopyWith<$Res> {
  __$ProfReportCopyWithImpl(this._self, this._then);

  final _ProfReport _self;
  final $Res Function(_ProfReport) _then;

/// Create a copy of ProfReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? courses = null,Object? validated = null,Object? rate = null,}) {
  return _then(_ProfReport(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,courses: null == courses ? _self.courses : courses // ignore: cast_nullable_to_non_nullable
as int,validated: null == validated ? _self.validated : validated // ignore: cast_nullable_to_non_nullable
as int,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
