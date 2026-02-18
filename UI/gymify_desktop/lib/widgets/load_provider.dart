import 'package:flutter/widgets.dart';

class LoadOnce extends StatefulWidget {
  final Future<void> Function() load;
  final Widget child;

  const LoadOnce({super.key, required this.load, required this.child});

  @override
  State<LoadOnce> createState() => _LoadOnceState();
}

class _LoadOnceState extends State<LoadOnce> {
  bool _done = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_done) return;
    _done = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await widget.load();
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
