import 'package:flutter/material.dart';
import '../model.dart';
import 'model.dart';

/// Signature of window interaction callbacks.
typedef void WindowInteractionCallback();

/// A window container
class Window extends StatefulWidget {
  /// The window's initial position.
  final Offset initialPosition;

  /// The window's initial size.
  final Size initialSize;

  /// Called when the user started interacting with this window.
  final WindowInteractionCallback onWindowInteraction;

  /// Called when the user clicks close button in this window.
  final WindowInteractionCallback onWindowClose;

  /// The window's child.
  final Widget child;

  /// The window's theme color.
  final Color color;

  /// Constructor.
  Window({
    Key key,
    this.onWindowInteraction,
    this.onWindowClose,
    this.initialPosition: Offset.zero,
    this.initialSize: Size.zero,
    @required this.child,
    this.color: Colors.blueAccent,
  }) : super(key: key);

  @override
  WindowState createState() => WindowState();
}

/// The window's mode.
enum WindowMode { NORMAL_MODE, MAXIMIZE_MODE, MINIMIZE_MODE }

class WindowState extends State<Window> {
  /// The window's position.
  Offset _position;

  /// The window's position before maximizing.
  Offset _prePosition;

  /// The window's size.
  Size _size;

  /// The window's size before maximizing.
  Size _preSize;

  /// The windows's current mode.
  WindowMode _windowMode = WindowMode.NORMAL_MODE;

  /// The window's child.
  Widget _child;

  /// The window's color.
  Color _color;

  /// The window's minimum height.
  final double _minHeight = 100.0;

  /// The window's minimum width.
  final double _minWidth = 100.0;

  /// Controls focus on this window.
  final FocusNode _focusNode = new FocusNode();

  /// Control is an illusion so let's make it a big one
  FocusAttachment _focusAttachment;

  @override
  void initState() {
    super.initState();
    _focusAttachment = _focusNode.attach(context);
    _position = widget.initialPosition;
    _size = widget.initialSize;
    _child = widget.child;
    _color = widget.color;
  }

  @override
  void dispose() {
    _focusAttachment.detach();
    _focusNode.dispose();
    super.dispose();
  }

  /// Requests this window to be focused.
  void focus() => _focusNode.requestFocus();

  void _registerInteraction() {
    widget.onWindowInteraction?.call();
    focus();
  }

  void _maximizeWindow() {
    Size deviceSize = MediaQuery.of(context).size;
    setState(() {
      _windowMode = WindowMode.MAXIMIZE_MODE;
      _prePosition = _position;
      _preSize = _size;
      _position = Offset(0, 0);
      _size = Size(deviceSize.width, deviceSize.height - 50);
    });
  }

  void _restoreWindowFromMaximizeMode() {
    setState(() {
      _windowMode = WindowMode.NORMAL_MODE;
      _size = _preSize;
      _position = _prePosition;
    });
  }

  void _closeWindow() {
    widget.onWindowClose?.call();
  }

  @override
  Widget build(BuildContext context) =>
      ScopedModelDescendant<WindowData>(builder: (
        BuildContext context,
        Widget child,
        WindowData model,
      ) {
        // Make sure the focus tree is properly updated.
        _focusAttachment.reparent();
        /*if (model.tabs.length == 1 && model.tabs[0].id == _draggedTabId) {
          // If the lone tab is being dragged, hide this window.
          return new Container();
        }
        final TabData selectedTab = _getCurrentSelection(model);*/
        return Positioned(
          left: _position.dx,
          top: _position.dy,
          child: GestureDetector(
            onTapDown: (_) => _registerInteraction(),
            child:
                /*new RawKeyboardListener(
        focusNode: _focusNode,
        onKey: (RawKeyEvent event) =>
        _handleKeyEvent(event, model, selectedTab.id),
        child: new*/
                RepaintBoundary(
              child: Container(
                width: _size.width,
                height: _size.height,
                constraints: BoxConstraints(
                    minWidth: _minWidth, minHeight: _minHeight), //
               decoration: BoxDecoration(boxShadow: kElevationToShadow[12]),
                child: Column(
                  children: [
                    GestureDetector(
                      onPanUpdate: (DragUpdateDetails details) {
                        setState(() {
                          _position += details.delta;
                          if (_windowMode == WindowMode.MAXIMIZE_MODE) {
                            _windowMode = WindowMode.NORMAL_MODE;
                            _size = _preSize;
                          }
                        });
                      },
                      child: Container(
                          padding: EdgeInsets.all(4.0),
                          height: 35.0,
                          color: _color,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.minimize, color: Colors.white),
                              GestureDetector(
                                  onTap: () =>
                                      _windowMode == WindowMode.NORMAL_MODE
                                          ? _maximizeWindow()
                                          : _restoreWindowFromMaximizeMode(),
                                  child: Icon(Icons.crop_square,
                                      color: Colors.white)),
                              GestureDetector(
                                onTap: () => _closeWindow(),
                                child: Icon(Icons.close, color: Colors.white),
                              )
                            ],
                          )),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onPanUpdate: (DragUpdateDetails details) {
                          setState(() {
                            var _newSize = _size + details.delta;
                            if (_newSize.width >= _minWidth &&
                                _newSize.height >= _minHeight)
                              _size += details.delta;
                          });
                        },
                        child: _child,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
}
