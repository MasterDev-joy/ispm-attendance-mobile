// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppNotification {

 String get id; NotificationType get type; NotificationStatus get status; String get title; String get body; String get courseTitle; DateTime get createdAt; String? get courseId;/// Pour scanConfirmed : nom du surveillant
 String? get invigilatorName;/// Pour scanConfirmed : heure du scan
 DateTime? get scanTime;/// Pour announcement : ID de l'annonce
 String? get announcementId;/// Pour announcement : date de la réunion
 DateTime? get meetingDate;/// Pour announcement : lieu de la réunion
 String? get meetingLocation;
/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppNotificationCopyWith<AppNotification> get copyWith => _$AppNotificationCopyWithImpl<AppNotification>(this as AppNotification, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppNotification&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.courseTitle, courseTitle) || other.courseTitle == courseTitle)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.invigilatorName, invigilatorName) || other.invigilatorName == invigilatorName)&&(identical(other.scanTime, scanTime) || other.scanTime == scanTime)&&(identical(other.announcementId, announcementId) || other.announcementId == announcementId)&&(identical(other.meetingDate, meetingDate) || other.meetingDate == meetingDate)&&(identical(other.meetingLocation, meetingLocation) || other.meetingLocation == meetingLocation));
}


@override
int get hashCode => Object.hash(runtimeType,id,type,status,title,body,courseTitle,createdAt,courseId,invigilatorName,scanTime,announcementId,meetingDate,meetingLocation);

@override
String toString() {
  return 'AppNotification(id: $id, type: $type, status: $status, title: $title, body: $body, courseTitle: $courseTitle, createdAt: $createdAt, courseId: $courseId, invigilatorName: $invigilatorName, scanTime: $scanTime, announcementId: $announcementId, meetingDate: $meetingDate, meetingLocation: $meetingLocation)';
}


}

/// @nodoc
abstract mixin class $AppNotificationCopyWith<$Res>  {
  factory $AppNotificationCopyWith(AppNotification value, $Res Function(AppNotification) _then) = _$AppNotificationCopyWithImpl;
@useResult
$Res call({
 String id, NotificationType type, NotificationStatus status, String title, String body, String courseTitle, DateTime createdAt, String? courseId, String? invigilatorName, DateTime? scanTime, String? announcementId, DateTime? meetingDate, String? meetingLocation
});




}
/// @nodoc
class _$AppNotificationCopyWithImpl<$Res>
    implements $AppNotificationCopyWith<$Res> {
  _$AppNotificationCopyWithImpl(this._self, this._then);

  final AppNotification _self;
  final $Res Function(AppNotification) _then;

/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? status = null,Object? title = null,Object? body = null,Object? courseTitle = null,Object? createdAt = null,Object? courseId = freezed,Object? invigilatorName = freezed,Object? scanTime = freezed,Object? announcementId = freezed,Object? meetingDate = freezed,Object? meetingLocation = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as NotificationType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as NotificationStatus,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,courseTitle: null == courseTitle ? _self.courseTitle : courseTitle // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,courseId: freezed == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as String?,invigilatorName: freezed == invigilatorName ? _self.invigilatorName : invigilatorName // ignore: cast_nullable_to_non_nullable
as String?,scanTime: freezed == scanTime ? _self.scanTime : scanTime // ignore: cast_nullable_to_non_nullable
as DateTime?,announcementId: freezed == announcementId ? _self.announcementId : announcementId // ignore: cast_nullable_to_non_nullable
as String?,meetingDate: freezed == meetingDate ? _self.meetingDate : meetingDate // ignore: cast_nullable_to_non_nullable
as DateTime?,meetingLocation: freezed == meetingLocation ? _self.meetingLocation : meetingLocation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppNotification].
extension AppNotificationPatterns on AppNotification {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppNotification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppNotification() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppNotification value)  $default,){
final _that = this;
switch (_that) {
case _AppNotification():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppNotification value)?  $default,){
final _that = this;
switch (_that) {
case _AppNotification() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  NotificationType type,  NotificationStatus status,  String title,  String body,  String courseTitle,  DateTime createdAt,  String? courseId,  String? invigilatorName,  DateTime? scanTime,  String? announcementId,  DateTime? meetingDate,  String? meetingLocation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppNotification() when $default != null:
return $default(_that.id,_that.type,_that.status,_that.title,_that.body,_that.courseTitle,_that.createdAt,_that.courseId,_that.invigilatorName,_that.scanTime,_that.announcementId,_that.meetingDate,_that.meetingLocation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  NotificationType type,  NotificationStatus status,  String title,  String body,  String courseTitle,  DateTime createdAt,  String? courseId,  String? invigilatorName,  DateTime? scanTime,  String? announcementId,  DateTime? meetingDate,  String? meetingLocation)  $default,) {final _that = this;
switch (_that) {
case _AppNotification():
return $default(_that.id,_that.type,_that.status,_that.title,_that.body,_that.courseTitle,_that.createdAt,_that.courseId,_that.invigilatorName,_that.scanTime,_that.announcementId,_that.meetingDate,_that.meetingLocation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  NotificationType type,  NotificationStatus status,  String title,  String body,  String courseTitle,  DateTime createdAt,  String? courseId,  String? invigilatorName,  DateTime? scanTime,  String? announcementId,  DateTime? meetingDate,  String? meetingLocation)?  $default,) {final _that = this;
switch (_that) {
case _AppNotification() when $default != null:
return $default(_that.id,_that.type,_that.status,_that.title,_that.body,_that.courseTitle,_that.createdAt,_that.courseId,_that.invigilatorName,_that.scanTime,_that.announcementId,_that.meetingDate,_that.meetingLocation);case _:
  return null;

}
}

}

/// @nodoc


class _AppNotification implements AppNotification {
  const _AppNotification({required this.id, required this.type, required this.status, required this.title, required this.body, required this.courseTitle, required this.createdAt, this.courseId, this.invigilatorName, this.scanTime, this.announcementId, this.meetingDate, this.meetingLocation});
  

@override final  String id;
@override final  NotificationType type;
@override final  NotificationStatus status;
@override final  String title;
@override final  String body;
@override final  String courseTitle;
@override final  DateTime createdAt;
@override final  String? courseId;
/// Pour scanConfirmed : nom du surveillant
@override final  String? invigilatorName;
/// Pour scanConfirmed : heure du scan
@override final  DateTime? scanTime;
/// Pour announcement : ID de l'annonce
@override final  String? announcementId;
/// Pour announcement : date de la réunion
@override final  DateTime? meetingDate;
/// Pour announcement : lieu de la réunion
@override final  String? meetingLocation;

/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppNotificationCopyWith<_AppNotification> get copyWith => __$AppNotificationCopyWithImpl<_AppNotification>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppNotification&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.courseTitle, courseTitle) || other.courseTitle == courseTitle)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.invigilatorName, invigilatorName) || other.invigilatorName == invigilatorName)&&(identical(other.scanTime, scanTime) || other.scanTime == scanTime)&&(identical(other.announcementId, announcementId) || other.announcementId == announcementId)&&(identical(other.meetingDate, meetingDate) || other.meetingDate == meetingDate)&&(identical(other.meetingLocation, meetingLocation) || other.meetingLocation == meetingLocation));
}


@override
int get hashCode => Object.hash(runtimeType,id,type,status,title,body,courseTitle,createdAt,courseId,invigilatorName,scanTime,announcementId,meetingDate,meetingLocation);

@override
String toString() {
  return 'AppNotification(id: $id, type: $type, status: $status, title: $title, body: $body, courseTitle: $courseTitle, createdAt: $createdAt, courseId: $courseId, invigilatorName: $invigilatorName, scanTime: $scanTime, announcementId: $announcementId, meetingDate: $meetingDate, meetingLocation: $meetingLocation)';
}


}

/// @nodoc
abstract mixin class _$AppNotificationCopyWith<$Res> implements $AppNotificationCopyWith<$Res> {
  factory _$AppNotificationCopyWith(_AppNotification value, $Res Function(_AppNotification) _then) = __$AppNotificationCopyWithImpl;
@override @useResult
$Res call({
 String id, NotificationType type, NotificationStatus status, String title, String body, String courseTitle, DateTime createdAt, String? courseId, String? invigilatorName, DateTime? scanTime, String? announcementId, DateTime? meetingDate, String? meetingLocation
});




}
/// @nodoc
class __$AppNotificationCopyWithImpl<$Res>
    implements _$AppNotificationCopyWith<$Res> {
  __$AppNotificationCopyWithImpl(this._self, this._then);

  final _AppNotification _self;
  final $Res Function(_AppNotification) _then;

/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? status = null,Object? title = null,Object? body = null,Object? courseTitle = null,Object? createdAt = null,Object? courseId = freezed,Object? invigilatorName = freezed,Object? scanTime = freezed,Object? announcementId = freezed,Object? meetingDate = freezed,Object? meetingLocation = freezed,}) {
  return _then(_AppNotification(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as NotificationType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as NotificationStatus,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,courseTitle: null == courseTitle ? _self.courseTitle : courseTitle // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,courseId: freezed == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as String?,invigilatorName: freezed == invigilatorName ? _self.invigilatorName : invigilatorName // ignore: cast_nullable_to_non_nullable
as String?,scanTime: freezed == scanTime ? _self.scanTime : scanTime // ignore: cast_nullable_to_non_nullable
as DateTime?,announcementId: freezed == announcementId ? _self.announcementId : announcementId // ignore: cast_nullable_to_non_nullable
as String?,meetingDate: freezed == meetingDate ? _self.meetingDate : meetingDate // ignore: cast_nullable_to_non_nullable
as DateTime?,meetingLocation: freezed == meetingLocation ? _self.meetingLocation : meetingLocation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
