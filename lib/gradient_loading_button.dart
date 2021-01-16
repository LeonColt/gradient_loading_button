library gradient_loading_button;

import 'package:flutter/material.dart';

import 'raised_gradient_button.dart';

enum ButtonState { idle, loading, success, error }

class LoadingButtonController {
  final _LoadingButtonState _state;
  LoadingButtonController._( this._state );
  Future<void> loading() => _state.updateState( ButtonState.loading );
  Future<void> success([ final Duration delayBeforeIdle = const Duration( seconds: 3 ) ]) => _state.updateState( ButtonState.success, delayBeforeIdle );
  Future<void> error([ final Duration delayBeforeIdle = const Duration( seconds: 3 ) ]) => _state.updateState( ButtonState.error, delayBeforeIdle );
}

class LoadingButton extends StatefulWidget {
  /// The background color of the button.
  final Color color;
  /// The background gradient of the button.
  final Gradient gradient;
  /// The progress indicator color.
  final Color progressIndicatorColor;
  /// The size of the progress indicator.
  final double progressIndicatorSize;
  /// The border radius while NOT animating.
  final BorderRadius borderRadius;
  /// The duration of the animation.
  final Duration animationDuration;

  /// The stroke width of progress indicator.
  final double strokeWidth;
  /// Function that will be called at the on pressed event.
  ///
  /// This will grant access to its [LoadingButtonController] so
  /// that the animation can be controlled based on the need.
  final Function(LoadingButtonController) onPressed;
  /// The child to display on the button when idle.
  final Widget child;
  /// The child to display on the button when success.
  final Widget successChild;
  /// The child to display on the button when error.
  final Widget errorChild;

  LoadingButton({
    @required this.child,
    @required this.successChild,
    @required this.errorChild,
    @required this.onPressed,
    this.gradient,
    this.color = Colors.blue,
    this.strokeWidth = 2,
    this.progressIndicatorColor = Colors.white,
    this.progressIndicatorSize = 30,
    this.borderRadius = const BorderRadius.all(Radius.circular(0)),
    this.animationDuration = const Duration(milliseconds: 500),
  });
  @override _LoadingButtonState createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> with TickerProviderStateMixin {
  LoadingButtonController _controller;
  AnimationController _animationController;
  ButtonState _state = ButtonState.idle;
  @override
  void initState() {
    super.initState();
    _controller = LoadingButtonController._( this );
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

  @override Widget build( _ ) => Center( child: LayoutBuilder( builder: _progressAnimatedBuilder ), );

  Widget _buttonChild() {
    if ( _animationController.isAnimating ) return const SizedBox();
    else if ( _animationController.isCompleted ) {
      return OverflowBox(
        maxWidth: widget.progressIndicatorSize,
        maxHeight: widget.progressIndicatorSize,
        child: CircularProgressIndicator(
          strokeWidth: widget.strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(widget.progressIndicatorColor),
        ),
      );
    } else {
      if ( _state == ButtonState.success )
        return widget.successChild;
      else if ( _state == ButtonState.error )
        return widget.errorChild;
      else return widget.child;
    }
  }

  AnimatedBuilder _progressAnimatedBuilder( _, final BoxConstraints constraints) {
    final buttonHeight = constraints.maxHeight != double.infinity ? constraints.maxHeight : 60.0;
    final widthAnimation = Tween<double>(
      begin: constraints.maxWidth,
      end: buttonHeight,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    final borderRadiusAnimation = Tween<BorderRadius>(
      begin: widget.borderRadius,
      end: BorderRadius.all( Radius.circular( buttonHeight / 2.0 ) ),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    return AnimatedBuilder(
      animation: _animationController,
      builder: ( _, child ) => new SizedBox(
        height: buttonHeight,
        width: widthAnimation.value,
        child: widget.gradient == null ? RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: borderRadiusAnimation.value,
          ),
          color: widget.color,
          child: AnimatedSwitcher(
            duration: const Duration( milliseconds: 250, ),
            child: _buttonChild(),
          ),
          onPressed: () {
            if ( _animationController.isDismissed && _state == ButtonState.idle )
              widget.onPressed(_controller);
          },
        ) : RaisedGradientButton(
          child: AnimatedSwitcher(
            duration: const Duration( milliseconds: 250, ),
            child: _buttonChild(),
          ),
          gradient: widget.gradient,
          borderRadius: BorderRadius.only(
            topLeft: borderRadiusAnimation.value.topLeft,
            topRight: borderRadiusAnimation.value.topRight,
            bottomRight: borderRadiusAnimation.value.bottomRight,
            bottomLeft: borderRadiusAnimation.value.bottomLeft,
          ),
          height: buttonHeight,
          width: widthAnimation.value,
          onPressed: () {
            if ( _animationController.isDismissed && _state == ButtonState.idle )
              widget.onPressed(_controller);
          },
        ),
      ),
    );
  }

  Future<void> updateState( final ButtonState state, [ final Duration delayBeforeIdle = const Duration( seconds: 3 ) ] ) async {
    if ( _animationController.isAnimating ) return;
    else if ( _animationController.isCompleted && ( state == ButtonState.success || state == ButtonState.error ) ) {
      await _animationController.reverse();
      if ( mounted ) {
        setState( () => _state = state );
        new Future.delayed(
          delayBeforeIdle,
              () {
            if ( mounted ) setState( () => _state = ButtonState.idle );
          },
        );
      }
    } else if ( mounted && state == ButtonState.loading ) {
      setState( () => _state = state );
      await _animationController.forward();
    }
  }

}
