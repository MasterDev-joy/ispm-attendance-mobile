// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stats_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CourseStats {

 String get courseId; String get courseTitle; String get fieldOfStudy; int get totalSessions; int get presentCount; int get absentCount; PresenceRisk? get riskOverride;
/// Create a copy of CourseStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseStatsCopyWith<CourseStats> get copyWith => _$CourseStatsCopyWithImpl<CourseStats>(this as CourseStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseStats&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.courseTitle, courseTitle) || other.courseTitle == courseTitle)&&(identical(other.fieldOfStudy, fieldOfStudy) || other.fieldOfStudy == fieldOfStudy)&&(identical(other.totalSessions, totalSessions) || other.totalSessions == totalSessions)&&(identical(other.presentCount, presentCount) || other.presentCount == presentCount)&&(identical(other.absentCount, absentCount) || other.absentCount == absentCount)&&(identical(other.riskOverride, riskOverride) || other.riskOverride == riskOverride));
}


@override
int get hashCode => Object.hash(runtimeType,courseId,courseTitle,fieldOfStudy,totalSessions,presentCount,absentCount,riskOverride);

@override
String toString() {
  return 'CourseStats(courseId: $courseId, courseTitle: $courseTitle, fieldOfStudy: $fieldOfStudy, totalSessions: $totalSessions, presentCount: $presentCount, absentCount: $absentCount, riskOverride: $riskOverride)';
}


}

/// @nodoc
abstract mixin class $CourseStatsCopyWith<$Res>  {
  factory $CourseStatsCopyWith(CourseStats value, $Res Function(CourseStats) _then) = _$CourseStatsCopyWithImpl;
@useResult
$Res call({
 String courseId, String courseTitle, String fieldOfStudy, int totalSessions, int presentCount, int absentCount, PresenceRisk? riskOverride
});




}
/// @nodoc
class _$CourseStatsCopyWithImpl<$Res>
    implements $CourseStatsCopyWith<$Res> {
  _$CourseStatsCopyWithImpl(this._self, this._then);

  final CourseStats _self;
  final $Res Function(CourseStats) _then;

/// Create a copy of CourseStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? courseId = null,Object? courseTitle = null,Object? fieldOfStudy = null,Object? totalSessions = null,Object? presentCount = null,Object? absentCount = null,Object? riskOverride = freezed,}) {
  return _then(_self.copyWith(
courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as String,courseTitle: null == courseTitle ? _self.courseTitle : courseTitle // ignore: cast_nullable_to_non_nullable
as String,fieldOfStudy: null == fieldOfStudy ? _self.fieldOfStudy : fieldOfStudy // ignore: cast_nullable_to_non_nullable
as String,totalSessions: null == totalSessions ? _self.totalSessions : totalSessions // ignore: cast_nullable_to_non_nullable
as int,presentCount: null == presentCount ? _self.presentCount : presentCount // ignore: cast_nullable_to_non_nullable
as int,absentCount: null == absentCount ? _self.absentCount : absentCount // ignore: cast_nullable_to_non_nullable
as int,riskOverride: freezed == riskOverride ? _self.riskOverride : riskOverride // ignore: cast_nullable_to_non_nullable
as PresenceRisk?,
  ));
}

}


/// Adds pattern-matching-related methods to [CourseStats].
extension CourseStatsPatterns on CourseStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseStats value)  $default,){
final _that = this;
switch (_that) {
case _CourseStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseStats value)?  $default,){
final _that = this;
switch (_that) {
case _CourseStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String courseId,  String courseTitle,  String fieldOfStudy,  int totalSessions,  int presentCount,  int absentCount,  PresenceRisk? riskOverride)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseStats() when $default != null:
return $default(_that.courseId,_that.courseTitle,_that.fieldOfStudy,_that.totalSessions,_that.presentCount,_that.absentCount,_that.riskOverride);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String courseId,  String courseTitle,  String fieldOfStudy,  int totalSessions,  int presentCount,  int absentCount,  PresenceRisk? riskOverride)  $default,) {final _that = this;
switch (_that) {
case _CourseStats():
return $default(_that.courseId,_that.courseTitle,_that.fieldOfStudy,_that.totalSessions,_that.presentCount,_that.absentCount,_that.riskOverride);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String courseId,  String courseTitle,  String fieldOfStudy,  int totalSessions,  int presentCount,  int absentCount,  PresenceRisk? riskOverride)?  $default,) {final _that = this;
switch (_that) {
case _CourseStats() when $default != null:
return $default(_that.courseId,_that.courseTitle,_that.fieldOfStudy,_that.totalSessions,_that.presentCount,_that.absentCount,_that.riskOverride);case _:
  return null;

}
}

}

/// @nodoc


class _CourseStats extends CourseStats {
  const _CourseStats({required this.courseId, required this.courseTitle, required this.fieldOfStudy, required this.totalSessions, required this.presentCount, required this.absentCount, this.riskOverride}): super._();
  

@override final  String courseId;
@override final  String courseTitle;
@override final  String fieldOfStudy;
@override final  int totalSessions;
@override final  int presentCount;
@override final  int absentCount;
@override final  PresenceRisk? riskOverride;

/// Create a copy of CourseStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseStatsCopyWith<_CourseStats> get copyWith => __$CourseStatsCopyWithImpl<_CourseStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseStats&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.courseTitle, courseTitle) || other.courseTitle == courseTitle)&&(identical(other.fieldOfStudy, fieldOfStudy) || other.fieldOfStudy == fieldOfStudy)&&(identical(other.totalSessions, totalSessions) || other.totalSessions == totalSessions)&&(identical(other.presentCount, presentCount) || other.presentCount == presentCount)&&(identical(other.absentCount, absentCount) || other.absentCount == absentCount)&&(identical(other.riskOverride, riskOverride) || other.riskOverride == riskOverride));
}


@override
int get hashCode => Object.hash(runtimeType,courseId,courseTitle,fieldOfStudy,totalSessions,presentCount,absentCount,riskOverride);

@override
String toString() {
  return 'CourseStats(courseId: $courseId, courseTitle: $courseTitle, fieldOfStudy: $fieldOfStudy, totalSessions: $totalSessions, presentCount: $presentCount, absentCount: $absentCount, riskOverride: $riskOverride)';
}


}

/// @nodoc
abstract mixin class _$CourseStatsCopyWith<$Res> implements $CourseStatsCopyWith<$Res> {
  factory _$CourseStatsCopyWith(_CourseStats value, $Res Function(_CourseStats) _then) = __$CourseStatsCopyWithImpl;
@override @useResult
$Res call({
 String courseId, String courseTitle, String fieldOfStudy, int totalSessions, int presentCount, int absentCount, PresenceRisk? riskOverride
});




}
/// @nodoc
class __$CourseStatsCopyWithImpl<$Res>
    implements _$CourseStatsCopyWith<$Res> {
  __$CourseStatsCopyWithImpl(this._self, this._then);

  final _CourseStats _self;
  final $Res Function(_CourseStats) _then;

/// Create a copy of CourseStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? courseId = null,Object? courseTitle = null,Object? fieldOfStudy = null,Object? totalSessions = null,Object? presentCount = null,Object? absentCount = null,Object? riskOverride = freezed,}) {
  return _then(_CourseStats(
courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as String,courseTitle: null == courseTitle ? _self.courseTitle : courseTitle // ignore: cast_nullable_to_non_nullable
as String,fieldOfStudy: null == fieldOfStudy ? _self.fieldOfStudy : fieldOfStudy // ignore: cast_nullable_to_non_nullable
as String,totalSessions: null == totalSessions ? _self.totalSessions : totalSessions // ignore: cast_nullable_to_non_nullable
as int,presentCount: null == presentCount ? _self.presentCount : presentCount // ignore: cast_nullable_to_non_nullable
as int,absentCount: null == absentCount ? _self.absentCount : absentCount // ignore: cast_nullable_to_non_nullable
as int,riskOverride: freezed == riskOverride ? _self.riskOverride : riskOverride // ignore: cast_nullable_to_non_nullable
as PresenceRisk?,
  ));
}


}

/// @nodoc
mixin _$CourseAbsenceSummary {

 String get courseTitle; String get fieldOfStudy; int get absenceCount; int get totalSessions;
/// Create a copy of CourseAbsenceSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseAbsenceSummaryCopyWith<CourseAbsenceSummary> get copyWith => _$CourseAbsenceSummaryCopyWithImpl<CourseAbsenceSummary>(this as CourseAbsenceSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseAbsenceSummary&&(identical(other.courseTitle, courseTitle) || other.courseTitle == courseTitle)&&(identical(other.fieldOfStudy, fieldOfStudy) || other.fieldOfStudy == fieldOfStudy)&&(identical(other.absenceCount, absenceCount) || other.absenceCount == absenceCount)&&(identical(other.totalSessions, totalSessions) || other.totalSessions == totalSessions));
}


@override
int get hashCode => Object.hash(runtimeType,courseTitle,fieldOfStudy,absenceCount,totalSessions);

@override
String toString() {
  return 'CourseAbsenceSummary(courseTitle: $courseTitle, fieldOfStudy: $fieldOfStudy, absenceCount: $absenceCount, totalSessions: $totalSessions)';
}


}

/// @nodoc
abstract mixin class $CourseAbsenceSummaryCopyWith<$Res>  {
  factory $CourseAbsenceSummaryCopyWith(CourseAbsenceSummary value, $Res Function(CourseAbsenceSummary) _then) = _$CourseAbsenceSummaryCopyWithImpl;
@useResult
$Res call({
 String courseTitle, String fieldOfStudy, int absenceCount, int totalSessions
});




}
/// @nodoc
class _$CourseAbsenceSummaryCopyWithImpl<$Res>
    implements $CourseAbsenceSummaryCopyWith<$Res> {
  _$CourseAbsenceSummaryCopyWithImpl(this._self, this._then);

  final CourseAbsenceSummary _self;
  final $Res Function(CourseAbsenceSummary) _then;

/// Create a copy of CourseAbsenceSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? courseTitle = null,Object? fieldOfStudy = null,Object? absenceCount = null,Object? totalSessions = null,}) {
  return _then(_self.copyWith(
courseTitle: null == courseTitle ? _self.courseTitle : courseTitle // ignore: cast_nullable_to_non_nullable
as String,fieldOfStudy: null == fieldOfStudy ? _self.fieldOfStudy : fieldOfStudy // ignore: cast_nullable_to_non_nullable
as String,absenceCount: null == absenceCount ? _self.absenceCount : absenceCount // ignore: cast_nullable_to_non_nullable
as int,totalSessions: null == totalSessions ? _self.totalSessions : totalSessions // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CourseAbsenceSummary].
extension CourseAbsenceSummaryPatterns on CourseAbsenceSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseAbsenceSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseAbsenceSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseAbsenceSummary value)  $default,){
final _that = this;
switch (_that) {
case _CourseAbsenceSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseAbsenceSummary value)?  $default,){
final _that = this;
switch (_that) {
case _CourseAbsenceSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String courseTitle,  String fieldOfStudy,  int absenceCount,  int totalSessions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseAbsenceSummary() when $default != null:
return $default(_that.courseTitle,_that.fieldOfStudy,_that.absenceCount,_that.totalSessions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String courseTitle,  String fieldOfStudy,  int absenceCount,  int totalSessions)  $default,) {final _that = this;
switch (_that) {
case _CourseAbsenceSummary():
return $default(_that.courseTitle,_that.fieldOfStudy,_that.absenceCount,_that.totalSessions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String courseTitle,  String fieldOfStudy,  int absenceCount,  int totalSessions)?  $default,) {final _that = this;
switch (_that) {
case _CourseAbsenceSummary() when $default != null:
return $default(_that.courseTitle,_that.fieldOfStudy,_that.absenceCount,_that.totalSessions);case _:
  return null;

}
}

}

/// @nodoc


class _CourseAbsenceSummary extends CourseAbsenceSummary {
  const _CourseAbsenceSummary({required this.courseTitle, required this.fieldOfStudy, required this.absenceCount, required this.totalSessions}): super._();
  

@override final  String courseTitle;
@override final  String fieldOfStudy;
@override final  int absenceCount;
@override final  int totalSessions;

/// Create a copy of CourseAbsenceSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseAbsenceSummaryCopyWith<_CourseAbsenceSummary> get copyWith => __$CourseAbsenceSummaryCopyWithImpl<_CourseAbsenceSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseAbsenceSummary&&(identical(other.courseTitle, courseTitle) || other.courseTitle == courseTitle)&&(identical(other.fieldOfStudy, fieldOfStudy) || other.fieldOfStudy == fieldOfStudy)&&(identical(other.absenceCount, absenceCount) || other.absenceCount == absenceCount)&&(identical(other.totalSessions, totalSessions) || other.totalSessions == totalSessions));
}


@override
int get hashCode => Object.hash(runtimeType,courseTitle,fieldOfStudy,absenceCount,totalSessions);

@override
String toString() {
  return 'CourseAbsenceSummary(courseTitle: $courseTitle, fieldOfStudy: $fieldOfStudy, absenceCount: $absenceCount, totalSessions: $totalSessions)';
}


}

/// @nodoc
abstract mixin class _$CourseAbsenceSummaryCopyWith<$Res> implements $CourseAbsenceSummaryCopyWith<$Res> {
  factory _$CourseAbsenceSummaryCopyWith(_CourseAbsenceSummary value, $Res Function(_CourseAbsenceSummary) _then) = __$CourseAbsenceSummaryCopyWithImpl;
@override @useResult
$Res call({
 String courseTitle, String fieldOfStudy, int absenceCount, int totalSessions
});




}
/// @nodoc
class __$CourseAbsenceSummaryCopyWithImpl<$Res>
    implements _$CourseAbsenceSummaryCopyWith<$Res> {
  __$CourseAbsenceSummaryCopyWithImpl(this._self, this._then);

  final _CourseAbsenceSummary _self;
  final $Res Function(_CourseAbsenceSummary) _then;

/// Create a copy of CourseAbsenceSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? courseTitle = null,Object? fieldOfStudy = null,Object? absenceCount = null,Object? totalSessions = null,}) {
  return _then(_CourseAbsenceSummary(
courseTitle: null == courseTitle ? _self.courseTitle : courseTitle // ignore: cast_nullable_to_non_nullable
as String,fieldOfStudy: null == fieldOfStudy ? _self.fieldOfStudy : fieldOfStudy // ignore: cast_nullable_to_non_nullable
as String,absenceCount: null == absenceCount ? _self.absenceCount : absenceCount // ignore: cast_nullable_to_non_nullable
as int,totalSessions: null == totalSessions ? _self.totalSessions : totalSessions // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$GlobalStats {

 int get totalSessions; int get presentCount; int get absentCount; double get globalPresenceRate; List<CourseStats> get perCourse; List<CourseAbsenceSummary> get mostMissed;
/// Create a copy of GlobalStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GlobalStatsCopyWith<GlobalStats> get copyWith => _$GlobalStatsCopyWithImpl<GlobalStats>(this as GlobalStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GlobalStats&&(identical(other.totalSessions, totalSessions) || other.totalSessions == totalSessions)&&(identical(other.presentCount, presentCount) || other.presentCount == presentCount)&&(identical(other.absentCount, absentCount) || other.absentCount == absentCount)&&(identical(other.globalPresenceRate, globalPresenceRate) || other.globalPresenceRate == globalPresenceRate)&&const DeepCollectionEquality().equals(other.perCourse, perCourse)&&const DeepCollectionEquality().equals(other.mostMissed, mostMissed));
}


@override
int get hashCode => Object.hash(runtimeType,totalSessions,presentCount,absentCount,globalPresenceRate,const DeepCollectionEquality().hash(perCourse),const DeepCollectionEquality().hash(mostMissed));

@override
String toString() {
  return 'GlobalStats(totalSessions: $totalSessions, presentCount: $presentCount, absentCount: $absentCount, globalPresenceRate: $globalPresenceRate, perCourse: $perCourse, mostMissed: $mostMissed)';
}


}

/// @nodoc
abstract mixin class $GlobalStatsCopyWith<$Res>  {
  factory $GlobalStatsCopyWith(GlobalStats value, $Res Function(GlobalStats) _then) = _$GlobalStatsCopyWithImpl;
@useResult
$Res call({
 int totalSessions, int presentCount, int absentCount, double globalPresenceRate, List<CourseStats> perCourse, List<CourseAbsenceSummary> mostMissed
});




}
/// @nodoc
class _$GlobalStatsCopyWithImpl<$Res>
    implements $GlobalStatsCopyWith<$Res> {
  _$GlobalStatsCopyWithImpl(this._self, this._then);

  final GlobalStats _self;
  final $Res Function(GlobalStats) _then;

/// Create a copy of GlobalStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalSessions = null,Object? presentCount = null,Object? absentCount = null,Object? globalPresenceRate = null,Object? perCourse = null,Object? mostMissed = null,}) {
  return _then(_self.copyWith(
totalSessions: null == totalSessions ? _self.totalSessions : totalSessions // ignore: cast_nullable_to_non_nullable
as int,presentCount: null == presentCount ? _self.presentCount : presentCount // ignore: cast_nullable_to_non_nullable
as int,absentCount: null == absentCount ? _self.absentCount : absentCount // ignore: cast_nullable_to_non_nullable
as int,globalPresenceRate: null == globalPresenceRate ? _self.globalPresenceRate : globalPresenceRate // ignore: cast_nullable_to_non_nullable
as double,perCourse: null == perCourse ? _self.perCourse : perCourse // ignore: cast_nullable_to_non_nullable
as List<CourseStats>,mostMissed: null == mostMissed ? _self.mostMissed : mostMissed // ignore: cast_nullable_to_non_nullable
as List<CourseAbsenceSummary>,
  ));
}

}


/// Adds pattern-matching-related methods to [GlobalStats].
extension GlobalStatsPatterns on GlobalStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GlobalStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GlobalStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GlobalStats value)  $default,){
final _that = this;
switch (_that) {
case _GlobalStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GlobalStats value)?  $default,){
final _that = this;
switch (_that) {
case _GlobalStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalSessions,  int presentCount,  int absentCount,  double globalPresenceRate,  List<CourseStats> perCourse,  List<CourseAbsenceSummary> mostMissed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GlobalStats() when $default != null:
return $default(_that.totalSessions,_that.presentCount,_that.absentCount,_that.globalPresenceRate,_that.perCourse,_that.mostMissed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalSessions,  int presentCount,  int absentCount,  double globalPresenceRate,  List<CourseStats> perCourse,  List<CourseAbsenceSummary> mostMissed)  $default,) {final _that = this;
switch (_that) {
case _GlobalStats():
return $default(_that.totalSessions,_that.presentCount,_that.absentCount,_that.globalPresenceRate,_that.perCourse,_that.mostMissed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalSessions,  int presentCount,  int absentCount,  double globalPresenceRate,  List<CourseStats> perCourse,  List<CourseAbsenceSummary> mostMissed)?  $default,) {final _that = this;
switch (_that) {
case _GlobalStats() when $default != null:
return $default(_that.totalSessions,_that.presentCount,_that.absentCount,_that.globalPresenceRate,_that.perCourse,_that.mostMissed);case _:
  return null;

}
}

}

/// @nodoc


class _GlobalStats implements GlobalStats {
  const _GlobalStats({required this.totalSessions, required this.presentCount, required this.absentCount, required this.globalPresenceRate, required final  List<CourseStats> perCourse, required final  List<CourseAbsenceSummary> mostMissed}): _perCourse = perCourse,_mostMissed = mostMissed;
  

@override final  int totalSessions;
@override final  int presentCount;
@override final  int absentCount;
@override final  double globalPresenceRate;
 final  List<CourseStats> _perCourse;
@override List<CourseStats> get perCourse {
  if (_perCourse is EqualUnmodifiableListView) return _perCourse;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_perCourse);
}

 final  List<CourseAbsenceSummary> _mostMissed;
@override List<CourseAbsenceSummary> get mostMissed {
  if (_mostMissed is EqualUnmodifiableListView) return _mostMissed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mostMissed);
}


/// Create a copy of GlobalStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GlobalStatsCopyWith<_GlobalStats> get copyWith => __$GlobalStatsCopyWithImpl<_GlobalStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GlobalStats&&(identical(other.totalSessions, totalSessions) || other.totalSessions == totalSessions)&&(identical(other.presentCount, presentCount) || other.presentCount == presentCount)&&(identical(other.absentCount, absentCount) || other.absentCount == absentCount)&&(identical(other.globalPresenceRate, globalPresenceRate) || other.globalPresenceRate == globalPresenceRate)&&const DeepCollectionEquality().equals(other._perCourse, _perCourse)&&const DeepCollectionEquality().equals(other._mostMissed, _mostMissed));
}


@override
int get hashCode => Object.hash(runtimeType,totalSessions,presentCount,absentCount,globalPresenceRate,const DeepCollectionEquality().hash(_perCourse),const DeepCollectionEquality().hash(_mostMissed));

@override
String toString() {
  return 'GlobalStats(totalSessions: $totalSessions, presentCount: $presentCount, absentCount: $absentCount, globalPresenceRate: $globalPresenceRate, perCourse: $perCourse, mostMissed: $mostMissed)';
}


}

/// @nodoc
abstract mixin class _$GlobalStatsCopyWith<$Res> implements $GlobalStatsCopyWith<$Res> {
  factory _$GlobalStatsCopyWith(_GlobalStats value, $Res Function(_GlobalStats) _then) = __$GlobalStatsCopyWithImpl;
@override @useResult
$Res call({
 int totalSessions, int presentCount, int absentCount, double globalPresenceRate, List<CourseStats> perCourse, List<CourseAbsenceSummary> mostMissed
});




}
/// @nodoc
class __$GlobalStatsCopyWithImpl<$Res>
    implements _$GlobalStatsCopyWith<$Res> {
  __$GlobalStatsCopyWithImpl(this._self, this._then);

  final _GlobalStats _self;
  final $Res Function(_GlobalStats) _then;

/// Create a copy of GlobalStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalSessions = null,Object? presentCount = null,Object? absentCount = null,Object? globalPresenceRate = null,Object? perCourse = null,Object? mostMissed = null,}) {
  return _then(_GlobalStats(
totalSessions: null == totalSessions ? _self.totalSessions : totalSessions // ignore: cast_nullable_to_non_nullable
as int,presentCount: null == presentCount ? _self.presentCount : presentCount // ignore: cast_nullable_to_non_nullable
as int,absentCount: null == absentCount ? _self.absentCount : absentCount // ignore: cast_nullable_to_non_nullable
as int,globalPresenceRate: null == globalPresenceRate ? _self.globalPresenceRate : globalPresenceRate // ignore: cast_nullable_to_non_nullable
as double,perCourse: null == perCourse ? _self._perCourse : perCourse // ignore: cast_nullable_to_non_nullable
as List<CourseStats>,mostMissed: null == mostMissed ? _self._mostMissed : mostMissed // ignore: cast_nullable_to_non_nullable
as List<CourseAbsenceSummary>,
  ));
}


}

// dart format on
