// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'atx_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AtxStatus _$AtxStatusFromJson(Map<String, dynamic> json) {
  return _AtxStatus.fromJson(json);
}

/// @nodoc
mixin _$AtxStatus {
  bool get power => throw _privateConstructorUsedError;
  bool get hdd => throw _privateConstructorUsedError;

  /// Serializes this AtxStatus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AtxStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AtxStatusCopyWith<AtxStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AtxStatusCopyWith<$Res> {
  factory $AtxStatusCopyWith(AtxStatus value, $Res Function(AtxStatus) then) =
      _$AtxStatusCopyWithImpl<$Res, AtxStatus>;
  @useResult
  $Res call({bool power, bool hdd});
}

/// @nodoc
class _$AtxStatusCopyWithImpl<$Res, $Val extends AtxStatus>
    implements $AtxStatusCopyWith<$Res> {
  _$AtxStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AtxStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? power = null, Object? hdd = null}) {
    return _then(
      _value.copyWith(
            power: null == power
                ? _value.power
                : power // ignore: cast_nullable_to_non_nullable
                      as bool,
            hdd: null == hdd
                ? _value.hdd
                : hdd // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AtxStatusImplCopyWith<$Res>
    implements $AtxStatusCopyWith<$Res> {
  factory _$$AtxStatusImplCopyWith(
    _$AtxStatusImpl value,
    $Res Function(_$AtxStatusImpl) then,
  ) = __$$AtxStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool power, bool hdd});
}

/// @nodoc
class __$$AtxStatusImplCopyWithImpl<$Res>
    extends _$AtxStatusCopyWithImpl<$Res, _$AtxStatusImpl>
    implements _$$AtxStatusImplCopyWith<$Res> {
  __$$AtxStatusImplCopyWithImpl(
    _$AtxStatusImpl _value,
    $Res Function(_$AtxStatusImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AtxStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? power = null, Object? hdd = null}) {
    return _then(
      _$AtxStatusImpl(
        power: null == power
            ? _value.power
            : power // ignore: cast_nullable_to_non_nullable
                  as bool,
        hdd: null == hdd
            ? _value.hdd
            : hdd // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AtxStatusImpl implements _AtxStatus {
  const _$AtxStatusImpl({required this.power, required this.hdd});

  factory _$AtxStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$AtxStatusImplFromJson(json);

  @override
  final bool power;
  @override
  final bool hdd;

  @override
  String toString() {
    return 'AtxStatus(power: $power, hdd: $hdd)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AtxStatusImpl &&
            (identical(other.power, power) || other.power == power) &&
            (identical(other.hdd, hdd) || other.hdd == hdd));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, power, hdd);

  /// Create a copy of AtxStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AtxStatusImplCopyWith<_$AtxStatusImpl> get copyWith =>
      __$$AtxStatusImplCopyWithImpl<_$AtxStatusImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AtxStatusImplToJson(this);
  }
}

abstract class _AtxStatus implements AtxStatus {
  const factory _AtxStatus({
    required final bool power,
    required final bool hdd,
  }) = _$AtxStatusImpl;

  factory _AtxStatus.fromJson(Map<String, dynamic> json) =
      _$AtxStatusImpl.fromJson;

  @override
  bool get power;
  @override
  bool get hdd;

  /// Create a copy of AtxStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AtxStatusImplCopyWith<_$AtxStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
