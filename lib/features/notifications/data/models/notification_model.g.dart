// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    _NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      courseId: json['courseId'] as String?,
      courseTitle: json['courseTitle'] as String? ?? 'Sans cours',
      createdAt: json['createdAt'] as String,
      isRead: json['isRead'] as bool? ?? false,
      type: json['type'] as String?,
      invigilatorName: json['invigilatorName'] as String?,
      scanTime: json['scanTime'] as String?,
      announcementId: json['announcementId'] as String?,
      announcementData: json['announcement'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$NotificationModelToJson(_NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'courseId': instance.courseId,
      'courseTitle': instance.courseTitle,
      'createdAt': instance.createdAt,
      'isRead': instance.isRead,
      'type': instance.type,
      'invigilatorName': instance.invigilatorName,
      'scanTime': instance.scanTime,
      'announcementId': instance.announcementId,
      'announcement': instance.announcementData,
    };
