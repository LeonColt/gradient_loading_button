library gradient_loading_button;

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'raised_gradient_button.dart';

enum ButtonState { idle, loading, success, error }

class LoadingButtonController {
  final _LoadingButtonState _state;
  LoadingButtonController._(this._state);
  Future<void> loading() async => await _state.updateState(ButtonState.loading);
  Future<void> success(
          [final Duration delayBeforeIdle =
              const Duration(seconds: 3)]) async =>
      await _state.updateState(ButtonState.success, delayBeforeIdle);
  Future<void> error(
          [final Duration delayBeforeIdle =
              const Duration(seconds: 3)]) async =>
      await _state.updateState(ButtonState.error, delayBeforeIdle);
}

class LoadingButton extends StatefulWidget {
  ///Style of the button
  final ButtonStyle? style;

  /// The background gradient of the button.
  final Gradient? gradient;

  /// The progress indicator color.
  final Color progressIndicatorColor;

  /// The size of the progress indicator.
  final double progressIndicatorSize;

  /// The duration of the animation.
  final Duration animationDuration;

  /// The stroke width of progress indicator.
  final double strokeWidth;

  /// Function that will be called at the on pressed event.
  ///
  /// This will grant access to its [LoadingButtonController] so
  /// that the animation can be controlled based on the need.
  final Function(LoadingButtonController)? onPressed;

  /// The child to display on the button when idle.
  final Widget child;

  /// The child to display on the button when success.
  final Widget successChild;

  /// The child to display on the button when error.
  final Widget errorChild;

  LoadingButton({
    final Key? key,
    required this.child,
    required this.successChild,
    required this.errorChild,
    this.onPressed,
    this.style,
    this.gradient,
    this.strokeWidth = 2,
    this.progressIndicatorColor = Colors.white,
    this.progressIndicatorSize = 30,
    this.animationDuration = const Duration(milliseconds: 500),
  }) : super(key: key);
  @override
  _LoadingButtonState createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton>
    with TickerProviderStateMixin {
  late LoadingButtonController _controller;
  late AnimationController _animationController;
  ButtonState _state = ButtonState.idle;
  @override
  void initState() {
    super.initState();
    _controller = LoadingButtonController._(this);
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(_) => Center(
        child: LayoutBuilder(builder: _progressAnimatedBuilder),
      );

  Widget _buttonChild() {
    if (_animationController.isAnimating)
      return const SizedBox();
    else if (_animationController.isCompleted) {
      return OverflowBox(
        maxWidth: widget.progressIndicatorSize,
        maxHeight: widget.progressIndicatorSize,
        child: CircularProgressIndicator(
          strokeWidth: widget.strokeWidth,
          valueColor:
              AlwaysStoppedAnimation<Color>(widget.progressIndicatorColor),
        ),
      );
    } else {
      if (_state == ButtonState.success)
        return widget.successChild;
      else if (_state == ButtonState.error)
        return widget.errorChild;
      else
        return widget.child;
    }
  }

  AnimatedBuilder _progressAnimatedBuilder(
      _, final BoxConstraints constraints) {
    final buttonHeight =
        constraints.maxHeight != double.infinity ? constraints.maxHeight : 60.0;
    final widthAnimation = Tween<double>(
      begin: constraints.maxWidth,
      end: buttonHeight,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, child) => new SizedBox(
        height: buttonHeight,
        width: widthAnimation.value,
        child: widget.gradient == null
            ? ElevatedButton(
                style: widget.style,
                child: AnimatedSwitcher(
                  duration: const Duration(
                    milliseconds: 250,
                  ),
                  child: _buttonChild(),
                ),
                onPressed: _onPressed,
              )
            : RaisedGradientButton(
                child: AnimatedSwitcher(
                  duration: const Duration(
                    milliseconds: 250,
                  ),
                  child: _buttonChild(),
                ),
                gradient: widget.gradient,
                style: widget.style,
                onPressed: _onPressed,
              ),
      ),
    );
  }

  Future<void> updateState(final ButtonState state,
      [final Duration delayBeforeIdle = const Duration(seconds: 3)]) async {
    if (_animationController.isAnimating)
      return;
    else if (_animationController.isCompleted &&
        (state == ButtonState.success || state == ButtonState.error)) {
      if (mounted) await _animationController.reverse();
      if (mounted) {
        setState(() => _state = state);
        new Future.delayed(
          delayBeforeIdle,
          () {
            if (mounted) setState(() => _state = ButtonState.idle);
          },
        );
      }
    } else if (mounted && state == ButtonState.loading) {
      if (mounted) setState(() => _state = state);
      if (mounted) await _animationController.forward();
    }
  }

  void _onPressed() {
    if (widget.onPressed != null &&
        _animationController.isDismissed &&
        _state == ButtonState.idle) widget.onPressed!(_controller);
  }
}
