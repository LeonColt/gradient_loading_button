import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class RaisedGradientButton1 extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  final double? width;
  final double? height;
  final ButtonStyle? style;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadows;
  final VoidCallback? onPressed;

  const RaisedGradientButton1({
    Key? key,
    required this.child,
    this.gradient,
    this.style,
    this.width = double.infinity,
    this.height = 60,
    this.borderRadius,
    this.boxShadows,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: borderRadius,
        boxShadow: boxShadows,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onPressed,
            child: Center(
              child: child,
            )),
      ),
    );
  }
}

/// The base [StatefulWidget] class for buttons whose style is defined by a [ButtonStyle] object.
///
/// Concrete subclasses must override [defaultStyleOf] and [themeStyleOf].
///
/// See also:
///
///  * [TextButton], a simple ButtonStyleButton without a shadow.
///  * [ElevatedButton], a filled ButtonStyleButton whose material elevates when pressed.
///  * [OutlinedButton], similar to [TextButton], but with an outline.
class RaisedGradientButton extends StatefulWidget {
  /// Create a [ButtonStyleButton].
  const RaisedGradientButton({
    Key? key,
    required this.onPressed,
    required this.child,
    required this.gradient,
    this.onLongPress,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
  }) : super(key: key);

  /// Called when the button is tapped or otherwise activated.
  ///
  /// If this callback and [onLongPress] are null, then the button will be disabled.
  ///
  /// See also:
  ///
  ///  * [enabled], which is true if the button is enabled.
  final VoidCallback? onPressed;

  /// Called when the button is long-pressed.
  ///
  /// If this callback and [onPressed] are null, then the button will be disabled.
  ///
  /// See also:
  ///
  ///  * [enabled], which is true if the button is enabled.
  final VoidCallback? onLongPress;

  /// Customizes this button's appearance.
  ///
  /// Non-null properties of this style override the corresponding
  /// properties in [themeStyleOf] and [defaultStyleOf]. [MaterialStateProperty]s
  /// that resolve to non-null values will similarly override the corresponding
  /// [MaterialStateProperty]s in [themeStyleOf] and [defaultStyleOf].
  ///
  /// Null by default.
  final ButtonStyle? style;

  ///Customized gradient button color
  ///Null by default
  final Gradient? gradient;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.none], and must not be null.
  final Clip clipBehavior;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// Typically the button's label.
  final Widget? child;

  /// Whether the button is enabled or disabled.
  ///
  /// Buttons are disabled by default. To enable a button, set its [onPressed]
  /// or [onLongPress] properties to a non-null value.
  bool get enabled => onPressed != null || onLongPress != null;

  @override
  _RaisedGradientButtonState createState() => _RaisedGradientButtonState();

  /// Returns null if [value] is null, otherwise `MaterialStateProperty.all<T>(value)`.
  ///
  /// A convenience method for subclasses.
  static MaterialStateProperty<T>? allOrNull<T>(T? value) =>
      value == null ? null : MaterialStateProperty.all<T>(value);

  /// Returns an interpolated value based on the [textScaleFactor] parameter:
  ///
  ///  * 0 - 1 [geometry1x]
  ///  * 1 - 2 lerp([geometry1x], [geometry2x], [textScaleFactor] - 1)
  ///  * 2 - 3 lerp([geometry2x], [geometry3x], [textScaleFactor] - 2)
  ///  * otherwise [geometry3x]
  ///
  /// A convenience method for subclasses.
  static EdgeInsetsGeometry scaledPadding(
    EdgeInsetsGeometry geometry1x,
    EdgeInsetsGeometry geometry2x,
    EdgeInsetsGeometry geometry3x,
    double textScaleFactor,
  ) {
    if (textScaleFactor <= 1) {
      return geometry1x;
    } else if (textScaleFactor >= 3) {
      return geometry3x;
    } else if (textScaleFactor <= 2) {
      return EdgeInsetsGeometry.lerp(
          geometry1x, geometry2x, textScaleFactor - 1)!;
    }
    return EdgeInsetsGeometry.lerp(
        geometry2x, geometry3x, textScaleFactor - 2)!;
  }

  /// A static convenience method that constructs an elevated button
  /// [ButtonStyle] given simple values.
  ///
  /// The [onPrimary], and [onSurface] colors are used to to create a
  /// [MaterialStateProperty] [ButtonStyle.foregroundColor] value in the same
  /// way that [defaultStyleOf] uses the [ColorScheme] colors with the same
  /// names. Specify a value for [onPrimary] to specify the color of the
  /// button's text and icons as well as the overlay colors used to indicate the
  /// hover, focus, and pressed states. Use [primary] for the button's background
  /// fill color and [onSurface] to specify the button's disabled text, icon,
  /// and fill color.
  ///
  /// The button's elevations are defined relative to the [elevation]
  /// parameter. The disabled elevation is the same as the parameter
  /// value, [elevation] + 2 is used when the button is hovered
  /// or focused, and elevation + 6 is used when the button is pressed.
  ///
  /// Similarly, the [enabledMouseCursor] and [disabledMouseCursor]
  /// parameters are used to construct [ButtonStyle].mouseCursor.
  ///
  /// All of the other parameters are either used directly or used to
  /// create a [MaterialStateProperty] with a single value for all
  /// states.
  ///
  /// All parameters default to null, by default this method returns
  /// a [ButtonStyle] that doesn't override anything.
  ///
  /// For example, to override the default text and icon colors for a
  /// [ElevatedButton], as well as its overlay color, with all of the
  /// standard opacity adjustments for the pressed, focused, and
  /// hovered states, one could write:
  ///
  /// ```dart
  /// ElevatedButton(
  ///   style: ElevatedButton.styleFrom(primary: Colors.green),
  /// )
  /// ```
  static ButtonStyle styleFrom({
    Color? primary,
    Color? onPrimary,
    Color? onSurface,
    Color? shadowColor,
    double? elevation,
    TextStyle? textStyle,
    EdgeInsetsGeometry? padding,
    Size? minimumSize,
    BorderSide? side,
    OutlinedBorder? shape,
    MouseCursor? enabledMouseCursor,
    MouseCursor? disabledMouseCursor,
    VisualDensity? visualDensity,
    MaterialTapTargetSize? tapTargetSize,
    Duration? animationDuration,
    bool? enableFeedback,
    AlignmentGeometry? alignment,
  }) {
    final MaterialStateProperty<Color?>? backgroundColor =
        (onSurface == null && primary == null)
            ? null
            : _ElevatedButtonDefaultBackground(primary, onSurface);
    final MaterialStateProperty<Color?>? foregroundColor =
        (onSurface == null && onPrimary == null)
            ? null
            : _ElevatedButtonDefaultForeground(onPrimary, onSurface);
    final MaterialStateProperty<Color?>? overlayColor =
        (onPrimary == null) ? null : _ElevatedButtonDefaultOverlay(onPrimary);
    final MaterialStateProperty<double>? elevationValue =
        (elevation == null) ? null : _ElevatedButtonDefaultElevation(elevation);
    final MaterialStateProperty<MouseCursor?>? mouseCursor =
        (enabledMouseCursor == null && disabledMouseCursor == null)
            ? null
            : _ElevatedButtonDefaultMouseCursor(
                enabledMouseCursor, disabledMouseCursor);

    return ButtonStyle(
      textStyle: MaterialStateProperty.all<TextStyle?>(textStyle),
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      overlayColor: overlayColor,
      shadowColor: ButtonStyleButton.allOrNull<Color>(shadowColor),
      elevation: elevationValue,
      padding: ButtonStyleButton.allOrNull<EdgeInsetsGeometry>(padding),
      minimumSize: ButtonStyleButton.allOrNull<Size>(minimumSize),
      side: ButtonStyleButton.allOrNull<BorderSide>(side),
      shape: ButtonStyleButton.allOrNull<OutlinedBorder>(shape),
      mouseCursor: mouseCursor,
      visualDensity: visualDensity,
      tapTargetSize: tapTargetSize,
      animationDuration: animationDuration,
      enableFeedback: enableFeedback,
      alignment: alignment,
    );
  }

  /// Defines the button's default appearance.
  ///
  /// The button [child]'s [Text] and [Icon] widgets are rendered with
  /// the [ButtonStyle]'s foreground color. The button's [InkWell] adds
  /// the style's overlay color when the button is focused, hovered
  /// or pressed. The button's background color becomes its [Material]
  /// color.
  ///
  /// All of the ButtonStyle's defaults appear below. In this list
  /// "Theme.foo" is shorthand for `Theme.of(context).foo`. Color
  /// scheme values like "onSurface(0.38)" are shorthand for
  /// `onSurface.withOpacity(0.38)`. [MaterialStateProperty] valued
  /// properties that are not followed by by a sublist have the same
  /// value for all states, otherwise the values are as specified for
  /// each state, and "others" means all other states.
  ///
  /// The `textScaleFactor` is the value of
  /// `MediaQuery.of(context).textScaleFactor` and the names of the
  /// EdgeInsets constructors and `EdgeInsetsGeometry.lerp` have been
  /// abbreviated for readability.
  ///
  /// The color of the [ButtonStyle.textStyle] is not used, the
  /// [ButtonStyle.foregroundColor] color is used instead.
  ///
  /// * `textStyle` - Theme.textTheme.button
  /// * `backgroundColor`
  ///   * disabled - Theme.colorScheme.onSurface(0.12)
  ///   * others - Theme.colorScheme.primary
  /// * `foregroundColor`
  ///   * disabled - Theme.colorScheme.onSurface(0.38)
  ///   * others - Theme.colorScheme.onPrimary
  /// * `overlayColor`
  ///   * hovered - Theme.colorScheme.onPrimary(0.08)
  ///   * focused or pressed - Theme.colorScheme.onPrimary(0.24)
  /// * `shadowColor` - Theme.shadowColor
  /// * `elevation`
  ///   * disabled - 0
  ///   * default - 2
  ///   * hovered or focused - 4
  ///   * pressed - 8
  /// * `padding`
  ///   * textScaleFactor <= 1 - horizontal(16)
  ///   * `1 < textScaleFactor <= 2` - lerp(horizontal(16), horizontal(8))
  ///   * `2 < textScaleFactor <= 3` - lerp(horizontal(8), horizontal(4))
  ///   * `3 < textScaleFactor` - horizontal(4)
  /// * `minimumSize` - Size(64, 36)
  /// * `side` - null
  /// * `shape` - RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))
  /// * `mouseCursor`
  ///   * disabled - SystemMouseCursors.forbidden
  ///   * others - SystemMouseCursors.click
  /// * `visualDensity` - theme.visualDensity
  /// * `tapTargetSize` - theme.materialTapTargetSize
  /// * `animationDuration` - kThemeChangeDuration
  /// * `enableFeedback` - true
  /// * `alignment` - Alignment.center
  ///
  /// The default padding values for the [ElevatedButton.icon] factory are slightly different:
  ///
  /// * `padding`
  ///   * `textScaleFactor <= 1` - start(12) end(16)
  ///   * `1 < textScaleFactor <= 2` - lerp(start(12) end(16), horizontal(8))
  ///   * `2 < textScaleFactor <= 3` - lerp(horizontal(8), horizontal(4))
  ///   * `3 < textScaleFactor` - horizontal(4)
  ///
  /// The default value for `side`, which defines the appearance of the button's
  /// outline, is null. That means that the outline is defined by the button
  /// shape's [OutlinedBorder.side]. Typically the default value of an
  /// [OutlinedBorder]'s side is [BorderSide.none], so an outline is not drawn.
  ButtonStyle defaultStyleOf(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final EdgeInsetsGeometry scaledPadding = ButtonStyleButton.scaledPadding(
      const EdgeInsets.symmetric(horizontal: 16),
      const EdgeInsets.symmetric(horizontal: 8),
      const EdgeInsets.symmetric(horizontal: 4),
      MediaQuery.maybeOf(context)?.textScaleFactor ?? 1,
    );

    return styleFrom(
      primary: colorScheme.primary,
      onPrimary: colorScheme.onPrimary,
      onSurface: colorScheme.onSurface,
      shadowColor: theme.shadowColor,
      elevation: 2,
      textStyle: theme.textTheme.button,
      padding: scaledPadding,
      minimumSize: const Size(64, 36),
      side: null,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4))),
      enabledMouseCursor: SystemMouseCursors.click,
      disabledMouseCursor: SystemMouseCursors.forbidden,
      visualDensity: theme.visualDensity,
      tapTargetSize: theme.materialTapTargetSize,
      animationDuration: kThemeChangeDuration,
      enableFeedback: true,
      alignment: Alignment.center,
    );
  }

  /// Returns the [ElevatedButtonThemeData.style] of the closest
  /// [ElevatedButtonTheme] ancestor.
  ButtonStyle? themeStyleOf(BuildContext context) {
    return ElevatedButtonTheme.of(context).style;
  }
}

/// The base [State] class for buttons whose style is defined by a [ButtonStyle] object.
///
/// See also:
///
///  * [ButtonStyleButton], the [StatefulWidget] subclass for which this class is the [State].
///  * [TextButton], a simple button without a shadow.
///  * [ElevatedButton], a filled button whose material elevates when pressed.
///  * [OutlinedButton], similar to [TextButton], but with an outline.
class _RaisedGradientButtonState extends State<RaisedGradientButton>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  double? _elevation;
  Color? _backgroundColor;
  final Set<MaterialState> _states = <MaterialState>{};

  bool get _hovered => _states.contains(MaterialState.hovered);
  bool get _focused => _states.contains(MaterialState.focused);
  bool get _pressed => _states.contains(MaterialState.pressed);
  bool get _disabled => _states.contains(MaterialState.disabled);

  void _updateState(MaterialState state, bool value) {
    value ? _states.add(state) : _states.remove(state);
  }

  void _handleHighlightChanged(bool value) {
    if (_pressed != value) {
      setState(() {
        _updateState(MaterialState.pressed, value);
      });
    }
  }

  void _handleHoveredChanged(bool value) {
    if (_hovered != value) {
      setState(() {
        _updateState(MaterialState.hovered, value);
      });
    }
  }

  void _handleFocusedChanged(bool value) {
    if (_focused != value) {
      setState(() {
        _updateState(MaterialState.focused, value);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _updateState(MaterialState.disabled, !widget.enabled);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(RaisedGradientButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateState(MaterialState.disabled, !widget.enabled);
    // If the button is disabled while a press gesture is currently ongoing,
    // InkWell makes a call to handleHighlightChanged. This causes an exception
    // because it calls setState in the middle of a build. To preempt this, we
    // manually update pressed to false when this situation occurs.
    if (_disabled && _pressed) {
      _handleHighlightChanged(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle? widgetStyle = widget.style;
    // ignore: invalid_use_of_protected_member
    final ButtonStyle? themeStyle = widget.themeStyleOf(context);
    // ignore: invalid_use_of_protected_member
    final ButtonStyle defaultStyle = widget.defaultStyleOf(context);

    T? effectiveValue<T>(T? Function(ButtonStyle? style) getProperty) {
      final T? widgetValue = getProperty(widgetStyle);
      final T? themeValue = getProperty(themeStyle);
      final T? defaultValue = getProperty(defaultStyle);
      return widgetValue ?? themeValue ?? defaultValue;
    }

    T? resolve<T>(
        MaterialStateProperty<T>? Function(ButtonStyle? style) getProperty) {
      return effectiveValue(
        (ButtonStyle? style) => getProperty(style)?.resolve(_states),
      );
    }

    final double? resolvedElevation =
        resolve<double?>((ButtonStyle? style) => style?.elevation);
    final TextStyle? resolvedTextStyle =
        resolve<TextStyle?>((ButtonStyle? style) => style?.textStyle);
    Color? resolvedBackgroundColor =
        resolve<Color?>((ButtonStyle? style) => style?.backgroundColor);
    final Color? resolvedForegroundColor =
        resolve<Color?>((ButtonStyle? style) => style?.foregroundColor);
    final Color? resolvedShadowColor =
        resolve<Color?>((ButtonStyle? style) => style?.shadowColor);
    final EdgeInsetsGeometry? resolvedPadding =
        resolve<EdgeInsetsGeometry?>((ButtonStyle? style) => style?.padding);
    final Size? resolvedMinimumSize =
        resolve<Size?>((ButtonStyle? style) => style?.minimumSize);
    final BorderSide? resolvedSide =
        resolve<BorderSide?>((ButtonStyle? style) => style?.side);
    final OutlinedBorder? resolvedShape =
        resolve<OutlinedBorder?>((ButtonStyle? style) => style?.shape);

    final MaterialStateMouseCursor resolvedMouseCursor = _MouseCursor(
      (Set<MaterialState> states) => effectiveValue(
          (ButtonStyle? style) => style?.mouseCursor?.resolve(states)),
    );

    final MaterialStateProperty<Color?> overlayColor =
        MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) => effectiveValue(
          (ButtonStyle? style) => style?.overlayColor?.resolve(states)),
    );

    final VisualDensity? resolvedVisualDensity =
        effectiveValue((ButtonStyle? style) => style?.visualDensity);
    final MaterialTapTargetSize? resolvedTapTargetSize =
        effectiveValue((ButtonStyle? style) => style?.tapTargetSize);
    final Duration? resolvedAnimationDuration =
        effectiveValue((ButtonStyle? style) => style?.animationDuration);
    final bool? resolvedEnableFeedback =
        effectiveValue((ButtonStyle? style) => style?.enableFeedback);
    final AlignmentGeometry? resolvedAlignment =
        effectiveValue((ButtonStyle? style) => style?.alignment);
    final Offset densityAdjustment = resolvedVisualDensity!.baseSizeAdjustment;
    final BoxConstraints effectiveConstraints =
        resolvedVisualDensity.effectiveConstraints(
      BoxConstraints(
        minWidth: resolvedMinimumSize!.width,
        minHeight: resolvedMinimumSize.height,
      ),
    );
    final EdgeInsetsGeometry padding = resolvedPadding!
        .add(
          EdgeInsets.only(
            left: densityAdjustment.dx,
            top: densityAdjustment.dy,
            right: densityAdjustment.dx,
            bottom: densityAdjustment.dy,
          ),
        )
        .clamp(EdgeInsets.zero, EdgeInsetsGeometry.infinity);

    // If an opaque button's background is becoming translucent while its
    // elevation is changing, change the elevation first. Material implicitly
    // animates its elevation but not its color. SKIA renders non-zero
    // elevations as a shadow colored fill behind the Material's background.
    if (resolvedAnimationDuration! > Duration.zero &&
        _elevation != null &&
        _backgroundColor != null &&
        _elevation != resolvedElevation &&
        _backgroundColor!.value != resolvedBackgroundColor!.value &&
        _backgroundColor!.opacity == 1 &&
        resolvedBackgroundColor.opacity < 1 &&
        resolvedElevation == 0) {
      if (_controller?.duration != resolvedAnimationDuration) {
        _controller?.dispose();
        _controller = AnimationController(
          duration: resolvedAnimationDuration,
          vsync: this,
        )..addStatusListener((AnimationStatus status) {
            if (status == AnimationStatus.completed) {
              setState(() {}); // Rebuild with the final background color.
            }
          });
      }
      resolvedBackgroundColor =
          _backgroundColor; // Defer changing the background color.
      _controller!.value = 0;
      _controller!.forward();
    }
    _elevation = resolvedElevation;
    _backgroundColor = resolvedBackgroundColor;

    BorderRadiusGeometry? borderRadius;

    if (resolvedShape is RoundedRectangleBorder)
      borderRadius = resolvedShape.borderRadius;
    else if (resolvedShape is ContinuousRectangleBorder)
      borderRadius = resolvedShape.borderRadius;
    else if (resolvedShape is BeveledRectangleBorder)
      borderRadius = resolvedShape.borderRadius;

    final Widget result = ConstrainedBox(
      constraints: effectiveConstraints,
      child: Material(
        elevation: resolvedElevation!,
        textStyle: resolvedTextStyle?.copyWith(color: resolvedForegroundColor),
        shape: resolvedShape!.copyWith(side: resolvedSide),
        color: Colors.transparent,
        shadowColor: resolvedShadowColor,
        type: resolvedBackgroundColor == null
            ? MaterialType.transparency
            : MaterialType.button,
        animationDuration: resolvedAnimationDuration,
        clipBehavior: widget.clipBehavior,
        child: Ink(
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: borderRadius,
          ),
          child: InkWell(
            onTap: widget.onPressed,
            onLongPress: widget.onLongPress,
            onHighlightChanged: _handleHighlightChanged,
            onHover: _handleHoveredChanged,
            mouseCursor: resolvedMouseCursor,
            enableFeedback: resolvedEnableFeedback,
            focusNode: widget.focusNode,
            canRequestFocus: widget.enabled,
            onFocusChange: _handleFocusedChanged,
            autofocus: widget.autofocus,
            splashFactory: InkRipple.splashFactory,
            overlayColor: overlayColor,
            highlightColor: Colors.transparent,
            customBorder: resolvedShape,
            child: IconTheme.merge(
              data: IconThemeData(color: resolvedForegroundColor),
              child: Padding(
                padding: padding,
                child: Align(
                  alignment: resolvedAlignment!,
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final Size minSize;
    switch (resolvedTapTargetSize!) {
      case MaterialTapTargetSize.padded:
        minSize = Size(
          kMinInteractiveDimension + densityAdjustment.dx,
          kMinInteractiveDimension + densityAdjustment.dy,
        );
        assert(minSize.width >= 0.0);
        assert(minSize.height >= 0.0);
        break;
      case MaterialTapTargetSize.shrinkWrap:
        minSize = Size.zero;
        break;
    }

    return Semantics(
      container: true,
      button: true,
      enabled: widget.enabled,
      child: _InputPadding(
        minSize: minSize,
        child: result,
      ),
    );
  }
}

class _MouseCursor extends MaterialStateMouseCursor {
  const _MouseCursor(this.resolveCallback);

  final MaterialPropertyResolver<MouseCursor?> resolveCallback;

  @override
  MouseCursor resolve(Set<MaterialState> states) => resolveCallback(states)!;

  @override
  String get debugDescription => 'ButtonStyleButton_MouseCursor';
}

/// A widget to pad the area around a [MaterialButton]'s inner [Material].
///
/// Redirect taps that occur in the padded area around the child to the center
/// of the child. This increases the size of the button and the button's
/// "tap target", but not its material or its ink splashes.
class _InputPadding extends SingleChildRenderObjectWidget {
  const _InputPadding({
    Key? key,
    Widget? child,
    required this.minSize,
  }) : super(key: key, child: child);

  final Size minSize;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderInputPadding(minSize);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant _RenderInputPadding renderObject) {
    renderObject.minSize = minSize;
  }
}

class _RenderInputPadding extends RenderShiftedBox {
  _RenderInputPadding(this._minSize, [RenderBox? child]) : super(child);

  Size get minSize => _minSize;
  Size _minSize;
  set minSize(Size value) {
    if (_minSize == value) return;
    _minSize = value;
    markNeedsLayout();
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    if (child != null)
      return math.max(child!.getMinIntrinsicWidth(height), minSize.width);
    return 0.0;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    if (child != null)
      return math.max(child!.getMinIntrinsicHeight(width), minSize.height);
    return 0.0;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    if (child != null)
      return math.max(child!.getMaxIntrinsicWidth(height), minSize.width);
    return 0.0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    if (child != null)
      return math.max(child!.getMaxIntrinsicHeight(width), minSize.height);
    return 0.0;
  }

  Size _computeSize(
      {required BoxConstraints constraints,
      required ChildLayouter layoutChild}) {
    if (child != null) {
      final Size childSize = layoutChild(child!, constraints);
      final double height = math.max(childSize.width, minSize.width);
      final double width = math.max(childSize.height, minSize.height);
      return constraints.constrain(Size(height, width));
    }
    return Size.zero;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return _computeSize(
      constraints: constraints,
      layoutChild: ChildLayoutHelper.dryLayoutChild,
    );
  }

  @override
  void performLayout() {
    size = _computeSize(
      constraints: constraints,
      layoutChild: ChildLayoutHelper.layoutChild,
    );
    if (child != null) {
      final BoxParentData childParentData = child!.parentData! as BoxParentData;
      childParentData.offset =
          Alignment.center.alongOffset(size - child!.size as Offset);
    }
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (super.hitTest(result, position: position)) {
      return true;
    }
    final Offset center = child!.size.center(Offset.zero);
    return result.addWithRawTransform(
      transform: MatrixUtils.forceToPoint(center),
      position: center,
      hitTest: (BoxHitTestResult result, Offset? position) {
        assert(position == center);
        return child!.hitTest(result, position: center);
      },
    );
  }
}

@immutable
class _ElevatedButtonDefaultBackground extends MaterialStateProperty<Color?>
    with Diagnosticable {
  _ElevatedButtonDefaultBackground(this.primary, this.onSurface);

  final Color? primary;
  final Color? onSurface;

  @override
  Color? resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled))
      return onSurface?.withOpacity(0.12);
    return primary;
  }
}

@immutable
class _ElevatedButtonDefaultForeground extends MaterialStateProperty<Color?>
    with Diagnosticable {
  _ElevatedButtonDefaultForeground(this.onPrimary, this.onSurface);

  final Color? onPrimary;
  final Color? onSurface;

  @override
  Color? resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled))
      return onSurface?.withOpacity(0.38);
    return onPrimary;
  }
}

@immutable
class _ElevatedButtonDefaultOverlay extends MaterialStateProperty<Color?>
    with Diagnosticable {
  _ElevatedButtonDefaultOverlay(this.onPrimary);

  final Color onPrimary;

  @override
  Color? resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.hovered))
      return onPrimary.withOpacity(0.08);
    if (states.contains(MaterialState.focused) ||
        states.contains(MaterialState.pressed))
      return onPrimary.withOpacity(0.24);
    return null;
  }
}

@immutable
class _ElevatedButtonDefaultElevation extends MaterialStateProperty<double>
    with Diagnosticable {
  _ElevatedButtonDefaultElevation(this.elevation);

  final double elevation;

  @override
  double resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) return 0;
    if (states.contains(MaterialState.hovered)) return elevation + 2;
    if (states.contains(MaterialState.focused)) return elevation + 2;
    if (states.contains(MaterialState.pressed)) return elevation + 6;
    return elevation;
  }
}

@immutable
class _ElevatedButtonDefaultMouseCursor
    extends MaterialStateProperty<MouseCursor?> with Diagnosticable {
  _ElevatedButtonDefaultMouseCursor(this.enabledCursor, this.disabledCursor);

  final MouseCursor? enabledCursor;
  final MouseCursor? disabledCursor;

  @override
  MouseCursor? resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) return disabledCursor;
    return enabledCursor;
  }
}
