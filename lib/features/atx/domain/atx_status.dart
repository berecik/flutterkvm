import 'package:freezed_annotation/freezed_annotation.dart';

part 'atx_status.freezed.dart';
part 'atx_status.g.dart';

@freezed
class AtxStatus with _$AtxStatus {
  const factory AtxStatus({
    required bool power,
    required bool hdd,
  }) = _AtxStatus;

  factory AtxStatus.fromJson(Map<String, dynamic> json) => _$AtxStatusFromJson(json);
}
