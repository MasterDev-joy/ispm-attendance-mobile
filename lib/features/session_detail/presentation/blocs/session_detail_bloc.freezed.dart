// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_detail_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SessionDetailEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionDetailEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SessionDetailEvent()';
}


}

/// @nodoc
class $SessionDetailEventCopyWith<$Res>  {
$SessionDetailEventCopyWith(SessionDetailEvent _, $Res Function(SessionDetailEvent) __);
}


/// Adds pattern-matching-related methods to [SessionDetailEvent].
extension SessionDetailEventPatterns on SessionDetailEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadSessionDetailEvent value)?  loadSessionDetail,TResult Function( ExportPdfEvent value)?  exportPdf,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadSessionDetailEvent() when loadSessionDetail != null:
return loadSessionDetail(_that);case ExportPdfEvent() when exportPdf != null:
return exportPdf(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadSessionDetailEvent value)  loadSessionDetail,required TResult Function( ExportPdfEvent value)  exportPdf,}){
final _that = this;
switch (_that) {
case LoadSessionDetailEvent():
return loadSessionDetail(_that);case ExportPdfEvent():
return exportPdf(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadSessionDetailEvent value)?  loadSessionDetail,TResult? Function( ExportPdfEvent value)?  exportPdf,}){
final _that = this;
switch (_that) {
case LoadSessionDetailEvent() when loadSessionDetail != null:
return loadSessionDetail(_that);case ExportPdfEvent() when exportPdf != null:
return exportPdf(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String sessionId,  String courseTitle,  String fieldOfStudy,  DateTime startTime,  DateTime endTime)?  loadSessionDetail,TResult Function()?  exportPdf,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadSessionDetailEvent() when loadSessionDetail != null:
return loadSessionDetail(_that.sessionId,_that.courseTitle,_that.fieldOfStudy,_that.startTime,_that.endTime);case ExportPdfEvent() when exportPdf != null:
return exportPdf();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String sessionId,  String courseTitle,  String fieldOfStudy,  DateTime startTime,  DateTime endTime)  loadSessionDetail,required TResult Function()  exportPdf,}) {final _that = this;
switch (_that) {
case LoadSessionDetailEvent():
return loadSessionDetail(_that.sessionId,_that.courseTitle,_that.fieldOfStudy,_that.startTime,_that.endTime);case ExportPdfEvent():
return exportPdf();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String sessionId,  String courseTitle,  String fieldOfStudy,  DateTime startTime,  DateTime endTime)?  loadSessionDetail,TResult? Function()?  exportPdf,}) {final _that = this;
switch (_that) {
case LoadSessionDetailEvent() when loadSessionDetail != null:
return loadSessionDetail(_that.sessionId,_that.courseTitle,_that.fieldOfStudy,_that.startTime,_that.endTime);case ExportPdfEvent() when exportPdf != null:
return exportPdf();case _:
  return null;

}
}

}

/// @nodoc


class LoadSessionDetailEvent implements SessionDetailEvent {
  const LoadSessionDetailEvent({required this.sessionId, required this.courseTitle, required this.fieldOfStudy, required this.startTime, required this.endTime});
  

 final  String sessionId;
 final  String courseTitle;
// ← passés depuis la page
 final  String fieldOfStudy;
 final  DateTime startTime;
 final  DateTime endTime;

/// Create a copy of SessionDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadSessionDetailEventCopyWith<LoadSessionDetailEvent> get copyWith => _$LoadSessionDetailEventCopyWithImpl<LoadSessionDetailEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadSessionDetailEvent&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.courseTitle, courseTitle) || other.courseTitle == courseTitle)&&(identical(other.fieldOfStudy, fieldOfStudy) || other.fieldOfStudy == fieldOfStudy)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,courseTitle,fieldOfStudy,startTime,endTime);

@override
String toString() {
  return 'SessionDetailEvent.loadSessionDetail(sessionId: $sessionId, courseTitle: $courseTitle, fieldOfStudy: $fieldOfStudy, startTime: $startTime, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class $LoadSessionDetailEventCopyWith<$Res> implements $SessionDetailEventCopyWith<$Res> {
  factory $LoadSessionDetailEventCopyWith(LoadSessionDetailEvent value, $Res Function(LoadSessionDetailEvent) _then) = _$LoadSessionDetailEventCopyWithImpl;
@useResult
$Res call({
 String sessionId, String courseTitle, String fieldOfStudy, DateTime startTime, DateTime endTime
});




}
/// @nodoc
class _$LoadSessionDetailEventCopyWithImpl<$Res>
    implements $LoadSessionDetailEventCopyWith<$Res> {
  _$LoadSessionDetailEventCopyWithImpl(this._self, this._then);

  final LoadSessionDetailEvent _self;
  final $Res Function(LoadSessionDetailEvent) _then;

/// Create a copy of SessionDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? courseTitle = null,Object? fieldOfStudy = null,Object? startTime = null,Object? endTime = null,}) {
  return _then(LoadSessionDetailEvent(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,courseTitle: null == courseTitle ? _self.courseTitle : courseTitle // ignore: cast_nullable_to_non_nullable
as String,fieldOfStudy: null == fieldOfStudy ? _self.fieldOfStudy : fieldOfStudy // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc


class ExportPdfEvent implements SessionDetailEvent {
  const ExportPdfEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportPdfEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SessionDetailEvent.exportPdf()';
}


}




/// @nodoc
mixin _$SessionDetailState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SessionDetailState()';
}


}

/// @nodoc
class $SessionDetailStateCopyWith<$Res>  {
$SessionDetailStateCopyWith(SessionDetailState _, $Res Function(SessionDetailState) __);
}


/// Adds pattern-matching-related methods to [SessionDetailState].
extension SessionDetailStatePatterns on SessionDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _Error():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( String courseTitle,  String fieldOfStudy,  DateTime startTime,  DateTime endTime,  SessionAttendance attendance,  bool isExporting)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.courseTitle,_that.fieldOfStudy,_that.startTime,_that.endTime,_that.attendance,_that.isExporting);case _Error() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( String courseTitle,  String fieldOfStudy,  DateTime startTime,  DateTime endTime,  SessionAttendance attendance,  bool isExporting)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.courseTitle,_that.fieldOfStudy,_that.startTime,_that.endTime,_that.attendance,_that.isExporting);case _Error():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( String courseTitle,  String fieldOfStudy,  DateTime startTime,  DateTime endTime,  SessionAttendance attendance,  bool isExporting)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.courseTitle,_that.fieldOfStudy,_that.startTime,_that.endTime,_that.attendance,_that.isExporting);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements SessionDetailState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SessionDetailState.initial()';
}


}




/// @nodoc


class _Loading implements SessionDetailState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SessionDetailState.loading()';
}


}




/// @nodoc


class _Loaded implements SessionDetailState {
  const _Loaded({required this.courseTitle, required this.fieldOfStudy, required this.startTime, required this.endTime, required this.attendance, this.isExporting = false});
  

 final  String courseTitle;
 final  String fieldOfStudy;
 final  DateTime startTime;
 final  DateTime endTime;
 final  SessionAttendance attendance;
@JsonKey() final  bool isExporting;

/// Create a copy of SessionDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&(identical(other.courseTitle, courseTitle) || other.courseTitle == courseTitle)&&(identical(other.fieldOfStudy, fieldOfStudy) || other.fieldOfStudy == fieldOfStudy)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.attendance, attendance) || other.attendance == attendance)&&(identical(other.isExporting, isExporting) || other.isExporting == isExporting));
}


@override
int get hashCode => Object.hash(runtimeType,courseTitle,fieldOfStudy,startTime,endTime,attendance,isExporting);

@override
String toString() {
  return 'SessionDetailState.loaded(courseTitle: $courseTitle, fieldOfStudy: $fieldOfStudy, startTime: $startTime, endTime: $endTime, attendance: $attendance, isExporting: $isExporting)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $SessionDetailStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 String courseTitle, String fieldOfStudy, DateTime startTime, DateTime endTime, SessionAttendance attendance, bool isExporting
});


$SessionAttendanceCopyWith<$Res> get attendance;

}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of SessionDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? courseTitle = null,Object? fieldOfStudy = null,Object? startTime = null,Object? endTime = null,Object? attendance = null,Object? isExporting = null,}) {
  return _then(_Loaded(
courseTitle: null == courseTitle ? _self.courseTitle : courseTitle // ignore: cast_nullable_to_non_nullable
as String,fieldOfStudy: null == fieldOfStudy ? _self.fieldOfStudy : fieldOfStudy // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime,attendance: null == attendance ? _self.attendance : attendance // ignore: cast_nullable_to_non_nullable
as SessionAttendance,isExporting: null == isExporting ? _self.isExporting : isExporting // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of SessionDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionAttendanceCopyWith<$Res> get attendance {
  
  return $SessionAttendanceCopyWith<$Res>(_self.attendance, (value) {
    return _then(_self.copyWith(attendance: value));
  });
}
}

/// @nodoc


class _Error implements SessionDetailState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of SessionDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'SessionDetailState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $SessionDetailStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of SessionDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
