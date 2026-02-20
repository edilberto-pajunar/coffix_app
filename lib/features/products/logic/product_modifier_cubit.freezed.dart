// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_modifier_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductModifierState {

 List<Modifier> get modifiers; double get totalPrice;
/// Create a copy of ProductModifierState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductModifierStateCopyWith<ProductModifierState> get copyWith => _$ProductModifierStateCopyWithImpl<ProductModifierState>(this as ProductModifierState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductModifierState&&const DeepCollectionEquality().equals(other.modifiers, modifiers)&&(identical(other.totalPrice, totalPrice) || other.totalPrice == totalPrice));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(modifiers),totalPrice);

@override
String toString() {
  return 'ProductModifierState(modifiers: $modifiers, totalPrice: $totalPrice)';
}


}

/// @nodoc
abstract mixin class $ProductModifierStateCopyWith<$Res>  {
  factory $ProductModifierStateCopyWith(ProductModifierState value, $Res Function(ProductModifierState) _then) = _$ProductModifierStateCopyWithImpl;
@useResult
$Res call({
 List<Modifier> modifiers, double totalPrice
});




}
/// @nodoc
class _$ProductModifierStateCopyWithImpl<$Res>
    implements $ProductModifierStateCopyWith<$Res> {
  _$ProductModifierStateCopyWithImpl(this._self, this._then);

  final ProductModifierState _self;
  final $Res Function(ProductModifierState) _then;

/// Create a copy of ProductModifierState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? modifiers = null,Object? totalPrice = null,}) {
  return _then(_self.copyWith(
modifiers: null == modifiers ? _self.modifiers : modifiers // ignore: cast_nullable_to_non_nullable
as List<Modifier>,totalPrice: null == totalPrice ? _self.totalPrice : totalPrice // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductModifierState].
extension ProductModifierStatePatterns on ProductModifierState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductModifierState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductModifierState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductModifierState value)  $default,){
final _that = this;
switch (_that) {
case _ProductModifierState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductModifierState value)?  $default,){
final _that = this;
switch (_that) {
case _ProductModifierState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Modifier> modifiers,  double totalPrice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductModifierState() when $default != null:
return $default(_that.modifiers,_that.totalPrice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Modifier> modifiers,  double totalPrice)  $default,) {final _that = this;
switch (_that) {
case _ProductModifierState():
return $default(_that.modifiers,_that.totalPrice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Modifier> modifiers,  double totalPrice)?  $default,) {final _that = this;
switch (_that) {
case _ProductModifierState() when $default != null:
return $default(_that.modifiers,_that.totalPrice);case _:
  return null;

}
}

}

/// @nodoc


class _ProductModifierState implements ProductModifierState {
  const _ProductModifierState({final  List<Modifier> modifiers = const [], this.totalPrice = 0.0}): _modifiers = modifiers;
  

 final  List<Modifier> _modifiers;
@override@JsonKey() List<Modifier> get modifiers {
  if (_modifiers is EqualUnmodifiableListView) return _modifiers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_modifiers);
}

@override@JsonKey() final  double totalPrice;

/// Create a copy of ProductModifierState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductModifierStateCopyWith<_ProductModifierState> get copyWith => __$ProductModifierStateCopyWithImpl<_ProductModifierState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductModifierState&&const DeepCollectionEquality().equals(other._modifiers, _modifiers)&&(identical(other.totalPrice, totalPrice) || other.totalPrice == totalPrice));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_modifiers),totalPrice);

@override
String toString() {
  return 'ProductModifierState(modifiers: $modifiers, totalPrice: $totalPrice)';
}


}

/// @nodoc
abstract mixin class _$ProductModifierStateCopyWith<$Res> implements $ProductModifierStateCopyWith<$Res> {
  factory _$ProductModifierStateCopyWith(_ProductModifierState value, $Res Function(_ProductModifierState) _then) = __$ProductModifierStateCopyWithImpl;
@override @useResult
$Res call({
 List<Modifier> modifiers, double totalPrice
});




}
/// @nodoc
class __$ProductModifierStateCopyWithImpl<$Res>
    implements _$ProductModifierStateCopyWith<$Res> {
  __$ProductModifierStateCopyWithImpl(this._self, this._then);

  final _ProductModifierState _self;
  final $Res Function(_ProductModifierState) _then;

/// Create a copy of ProductModifierState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? modifiers = null,Object? totalPrice = null,}) {
  return _then(_ProductModifierState(
modifiers: null == modifiers ? _self._modifiers : modifiers // ignore: cast_nullable_to_non_nullable
as List<Modifier>,totalPrice: null == totalPrice ? _self.totalPrice : totalPrice // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
