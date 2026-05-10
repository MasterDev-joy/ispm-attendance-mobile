// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReportEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ReportEvent()';
}


}

/// @nodoc
class $ReportEventCopyWith<$Res>  {
$ReportEventCopyWith(ReportEvent _, $Res Function(ReportEvent) __);
}


/// Adds pattern-matching-related methods to [ReportEvent].
extension ReportEventPatterns on ReportEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Load value)?  load,TResult Function( _ChangePeriod value)?  changePeriod,TResult Function( _Export value)?  export,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Load() when load != null:
return load(_that);case _ChangePeriod() when changePeriod != null:
return changePeriod(_that);case _Export() when export != null:
return export(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Load value)  load,required TResult Function( _ChangePeriod value)  changePeriod,required TResult Function( _Export value)  export,}){
final _that = this;
switch (_that) {
case _Load():
return load(_that);case _ChangePeriod():
return changePeriod(_that);case _Export():
return export(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Load value)?  load,TResult? Function( _ChangePeriod value)?  changePeriod,TResult? Function( _Export value)?  export,}){
final _that = this;
switch (_that) {
case _Load() when load != null:
return load(_that);case _ChangePeriod() when changePeriod != null:
return changePeriod(_that);case _Export() when export != null:
return export(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String period)?  load,TResult Function( String period)?  changePeriod,TResult Function( String format)?  export,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Load() when load != null:
return load(_that.period);case _ChangePeriod() when changePeriod != null:
return changePeriod(_that.period);case _Export() when export != null:
return export(_that.format);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String period)  load,required TResult Function( String period)  changePeriod,required TResult Function( String format)  export,}) {final _that = this;
switch (_that) {
case _Load():
return load(_that.period);case _ChangePeriod():
return changePeriod(_that.period);case _Export():
return export(_that.format);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String period)?  load,TResult? Function( String period)?  changePeriod,TResult? Function( String format)?  export,}) {final _that = this;
switch (_that) {
case _Load() when load != null:
return load(_that.period);case _ChangePeriod() when changePeriod != null:
return changePeriod(_that.period);case _Export() when export != null:
return export(_that.format);case _:
  return null;

}
}

}

/// @nodoc


class _Load implements ReportEvent {
  const _Load({this.period = 'month'});
  

@JsonKey() final  String period;

/// Create a copy of ReportEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadCopyWith<_Load> get copyWith => __$LoadCopyWithImpl<_Load>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Load&&(identical(other.period, period) || other.period == period));
}


@override
int get hashCode => Object.hash(runtimeType,period);

@override
String toString() {
  return 'ReportEvent.load(period: $period)';
}


}

/// @nodoc
abstract mixin class _$LoadCopyWith<$Res> implements $ReportEventCopyWith<$Res> {
  factory _$LoadCopyWith(_Load value, $Res Function(_Load) _then) = __$LoadCopyWithImpl;
@useResult
$Res call({
 String period
});




}
/// @nodoc
class __$LoadCopyWithImpl<$Res>
    implements _$LoadCopyWith<$Res> {
  __$LoadCopyWithImpl(this._self, this._then);

  final _Load _self;
  final $Res Function(_Load) _then;

/// Create a copy of ReportEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? period = null,}) {
  return _then(_Load(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ChangePeriod implements ReportEvent {
  const _ChangePeriod(this.period);
  

 final  String period;

/// Create a copy of ReportEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangePeriodCopyWith<_ChangePeriod> get copyWith => __$ChangePeriodCopyWithImpl<_ChangePeriod>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangePeriod&&(identical(other.period, period) || other.period == period));
}


@override
int get hashCode => Object.hash(runtimeType,period);

@override
String toString() {
  return 'ReportEvent.changePeriod(period: $period)';
}


}

/// @nodoc
abstract mixin class _$ChangePeriodCopyWith<$Res> implements $ReportEventCopyWith<$Res> {
  factory _$ChangePeriodCopyWith(_ChangePeriod value, $Res Function(_ChangePeriod) _then) = __$ChangePeriodCopyWithImpl;
@useResult
$Res call({
 String period
});




}
/// @nodoc
class __$ChangePeriodCopyWithImpl<$Res>
    implements _$ChangePeriodCopyWith<$Res> {
  __$ChangePeriodCopyWithImpl(this._self, this._then);

  final _ChangePeriod _self;
  final $Res Function(_ChangePeriod) _then;

/// Create a copy of ReportEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? period = null,}) {
  return _then(_ChangePeriod(
null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Export implements ReportEvent {
  const _Export(this.format);
  

 final  String format;

/// Create a copy of ReportEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExportCopyWith<_Export> get copyWith => __$ExportCopyWithImpl<_Export>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Export&&(identical(other.format, format) || other.format == format));
}


@override
int get hashCode => Object.hash(runtimeType,format);

@override
String toString() {
  return 'ReportEvent.export(format: $format)';
}


}

/// @nodoc
abstract mixin class _$ExportCopyWith<$Res> implements $ReportEventCopyWith<$Res> {
  factory _$ExportCopyWith(_Export value, $Res Function(_Export) _then) = __$ExportCopyWithImpl;
@useResult
$Res call({
 String format
});




}
/// @nodoc
class __$ExportCopyWithImpl<$Res>
    implements _$ExportCopyWith<$Res> {
  __$ExportCopyWithImpl(this._self, this._then);

  final _Export _self;
  final $Res Function(_Export) _then;

/// Create a copy of ReportEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? format = null,}) {
  return _then(_Export(
null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ReportState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ReportState()';
}


}

/// @nodoc
class $ReportStateCopyWith<$Res>  {
$ReportStateCopyWith(ReportState _, $Res Function(ReportState) __);
}


/// Adds pattern-matching-related methods to [ReportState].
extension ReportStatePatterns on ReportState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _Exporting value)?  exporting,TResult Function( _ExportSuccess value)?  exportSuccess,TResult Function( _ExportError value)?  exportError,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Exporting() when exporting != null:
return exporting(_that);case _ExportSuccess() when exportSuccess != null:
return exportSuccess(_that);case _ExportError() when exportError != null:
return exportError(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _Exporting value)  exporting,required TResult Function( _ExportSuccess value)  exportSuccess,required TResult Function( _ExportError value)  exportError,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _Exporting():
return exporting(_that);case _ExportSuccess():
return exportSuccess(_that);case _ExportError():
return exportError(_that);case _Error():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _Exporting value)?  exporting,TResult? Function( _ExportSuccess value)?  exportSuccess,TResult? Function( _ExportError value)?  exportError,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Exporting() when exporting != null:
return exporting(_that);case _ExportSuccess() when exportSuccess != null:
return exportSuccess(_that);case _ExportError() when exportError != null:
return exportError(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( GlobalReport report,  String period)?  loaded,TResult Function( GlobalReport report,  String period)?  exporting,TResult Function( GlobalReport report,  String period,  String format,  String data)?  exportSuccess,TResult Function( GlobalReport report,  String period,  String message)?  exportError,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.report,_that.period);case _Exporting() when exporting != null:
return exporting(_that.report,_that.period);case _ExportSuccess() when exportSuccess != null:
return exportSuccess(_that.report,_that.period,_that.format,_that.data);case _ExportError() when exportError != null:
return exportError(_that.report,_that.period,_that.message);case _Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( GlobalReport report,  String period)  loaded,required TResult Function( GlobalReport report,  String period)  exporting,required TResult Function( GlobalReport report,  String period,  String format,  String data)  exportSuccess,required TResult Function( GlobalReport report,  String period,  String message)  exportError,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.report,_that.period);case _Exporting():
return exporting(_that.report,_that.period);case _ExportSuccess():
return exportSuccess(_that.report,_that.period,_that.format,_that.data);case _ExportError():
return exportError(_that.report,_that.period,_that.message);case _Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( GlobalReport report,  String period)?  loaded,TResult? Function( GlobalReport report,  String period)?  exporting,TResult? Function( GlobalReport report,  String period,  String format,  String data)?  exportSuccess,TResult? Function( GlobalReport report,  String period,  String message)?  exportError,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.report,_that.period);case _Exporting() when exporting != null:
return exporting(_that.report,_that.period);case _ExportSuccess() when exportSuccess != null:
return exportSuccess(_that.report,_that.period,_that.format,_that.data);case _ExportError() when exportError != null:
return exportError(_that.report,_that.period,_that.message);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements ReportState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ReportState.initial()';
}


}




/// @nodoc


class _Loading implements ReportState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ReportState.loading()';
}


}




/// @nodoc


class _Loaded implements ReportState {
  const _Loaded({required this.report, required this.period});
  

 final  GlobalReport report;
 final  String period;

/// Create a copy of ReportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&(identical(other.report, report) || other.report == report)&&(identical(other.period, period) || other.period == period));
}


@override
int get hashCode => Object.hash(runtimeType,report,period);

@override
String toString() {
  return 'ReportState.loaded(report: $report, period: $period)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $ReportStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 GlobalReport report, String period
});


$GlobalReportCopyWith<$Res> get report;

}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of ReportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? report = null,Object? period = null,}) {
  return _then(_Loaded(
report: null == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as GlobalReport,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of ReportState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GlobalReportCopyWith<$Res> get report {
  
  return $GlobalReportCopyWith<$Res>(_self.report, (value) {
    return _then(_self.copyWith(report: value));
  });
}
}

/// @nodoc


class _Exporting implements ReportState {
  const _Exporting({required this.report, required this.period});
  

 final  GlobalReport report;
 final  String period;

/// Create a copy of ReportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExportingCopyWith<_Exporting> get copyWith => __$ExportingCopyWithImpl<_Exporting>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Exporting&&(identical(other.report, report) || other.report == report)&&(identical(other.period, period) || other.period == period));
}


@override
int get hashCode => Object.hash(runtimeType,report,period);

@override
String toString() {
  return 'ReportState.exporting(report: $report, period: $period)';
}


}

/// @nodoc
abstract mixin class _$ExportingCopyWith<$Res> implements $ReportStateCopyWith<$Res> {
  factory _$ExportingCopyWith(_Exporting value, $Res Function(_Exporting) _then) = __$ExportingCopyWithImpl;
@useResult
$Res call({
 GlobalReport report, String period
});


$GlobalReportCopyWith<$Res> get report;

}
/// @nodoc
class __$ExportingCopyWithImpl<$Res>
    implements _$ExportingCopyWith<$Res> {
  __$ExportingCopyWithImpl(this._self, this._then);

  final _Exporting _self;
  final $Res Function(_Exporting) _then;

/// Create a copy of ReportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? report = null,Object? period = null,}) {
  return _then(_Exporting(
report: null == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as GlobalReport,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of ReportState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GlobalReportCopyWith<$Res> get report {
  
  return $GlobalReportCopyWith<$Res>(_self.report, (value) {
    return _then(_self.copyWith(report: value));
  });
}
}

/// @nodoc


class _ExportSuccess implements ReportState {
  const _ExportSuccess({required this.report, required this.period, required this.format, required this.data});
  

 final  GlobalReport report;
 final  String period;
 final  String format;
 final  String data;

/// Create a copy of ReportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExportSuccessCopyWith<_ExportSuccess> get copyWith => __$ExportSuccessCopyWithImpl<_ExportSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExportSuccess&&(identical(other.report, report) || other.report == report)&&(identical(other.period, period) || other.period == period)&&(identical(other.format, format) || other.format == format)&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,report,period,format,data);

@override
String toString() {
  return 'ReportState.exportSuccess(report: $report, period: $period, format: $format, data: $data)';
}


}

/// @nodoc
abstract mixin class _$ExportSuccessCopyWith<$Res> implements $ReportStateCopyWith<$Res> {
  factory _$ExportSuccessCopyWith(_ExportSuccess value, $Res Function(_ExportSuccess) _then) = __$ExportSuccessCopyWithImpl;
@useResult
$Res call({
 GlobalReport report, String period, String format, String data
});


$GlobalReportCopyWith<$Res> get report;

}
/// @nodoc
class __$ExportSuccessCopyWithImpl<$Res>
    implements _$ExportSuccessCopyWith<$Res> {
  __$ExportSuccessCopyWithImpl(this._self, this._then);

  final _ExportSuccess _self;
  final $Res Function(_ExportSuccess) _then;

/// Create a copy of ReportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? report = null,Object? period = null,Object? format = null,Object? data = null,}) {
  return _then(_ExportSuccess(
report: null == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as GlobalReport,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of ReportState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GlobalReportCopyWith<$Res> get report {
  
  return $GlobalReportCopyWith<$Res>(_self.report, (value) {
    return _then(_self.copyWith(report: value));
  });
}
}

/// @nodoc


class _ExportError implements ReportState {
  const _ExportError({required this.report, required this.period, required this.message});
  

 final  GlobalReport report;
 final  String period;
 final  String message;

/// Create a copy of ReportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExportErrorCopyWith<_ExportError> get copyWith => __$ExportErrorCopyWithImpl<_ExportError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExportError&&(identical(other.report, report) || other.report == report)&&(identical(other.period, period) || other.period == period)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,report,period,message);

@override
String toString() {
  return 'ReportState.exportError(report: $report, period: $period, message: $message)';
}


}

/// @nodoc
abstract mixin class _$ExportErrorCopyWith<$Res> implements $ReportStateCopyWith<$Res> {
  factory _$ExportErrorCopyWith(_ExportError value, $Res Function(_ExportError) _then) = __$ExportErrorCopyWithImpl;
@useResult
$Res call({
 GlobalReport report, String period, String message
});


$GlobalReportCopyWith<$Res> get report;

}
/// @nodoc
class __$ExportErrorCopyWithImpl<$Res>
    implements _$ExportErrorCopyWith<$Res> {
  __$ExportErrorCopyWithImpl(this._self, this._then);

  final _ExportError _self;
  final $Res Function(_ExportError) _then;

/// Create a copy of ReportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? report = null,Object? period = null,Object? message = null,}) {
  return _then(_ExportError(
report: null == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as GlobalReport,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of ReportState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GlobalReportCopyWith<$Res> get report {
  
  return $GlobalReportCopyWith<$Res>(_self.report, (value) {
    return _then(_self.copyWith(report: value));
  });
}
}

/// @nodoc


class _Error implements ReportState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of ReportState
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
  return 'ReportState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $ReportStateCopyWith<$Res> {
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

/// Create a copy of ReportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
