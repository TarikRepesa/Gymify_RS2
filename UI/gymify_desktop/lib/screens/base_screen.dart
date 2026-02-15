import 'package:flutter/material.dart';
import 'package:gymify_desktop/widgets/member_widget.dart';
import 'package:gymify_desktop/widgets/membership_widget.dart';
import 'package:gymify_desktop/widgets/notification_widget.dart';
import 'package:gymify_desktop/widgets/report_widget.dart';
import 'package:gymify_desktop/widgets/review_widget.dart';
import 'package:gymify_desktop/widgets/staff_widget.dart';
import 'package:gymify_desktop/widgets/training_widget.dart'; 

class BaseScreen extends StatefulWidget { 
  String? title; 
  BaseScreen({super.key, this.title}); 

  @override 
  State<BaseScreen> createState() => _BaseScreenState(); 
} 

class _BaseScreenState extends State<BaseScreen> { 
  String _activeItem = 'Osoblje'; 
  late Widget _bodyWidget; 

  @override 
  void initState() { 
    super.initState(); 
    _bodyWidget = _getWidgetForMenu(_activeItem); 
  } 

  Widget _getWidgetForMenu(String menu) {
  switch(menu){
    case 'Osoblje':
      return StaffWidget(); 
    case 'Članovi':
      return MemberWidget(); 
    case 'Treninzi':
      return TrainingWidget(); 
    case 'Članarine':
      return MembershipWidget(); 
    case 'Obavijesti':
      return NotificationWidget(); 
    case 'Recenzije':
      return ReviewWidget(); 
    case 'Izvještaj':
      return ReportWidget(); 
    default:
      return Center(child: Text('Nije pronađen menu'));
  }
}


  void _onMenuTap(String menu) { 
    setState(() { 
      _activeItem = menu; 
      _bodyWidget = _getWidgetForMenu(menu); 
    }); 
  } 

  Widget _menuItem(String text) { 
    bool isActive = _activeItem == text; 
    return MouseRegion( 
      cursor: SystemMouseCursors.click, 
      child: GestureDetector( 
        onTap: () => _onMenuTap(text), 
        child: AnimatedContainer( 
          duration: const Duration(milliseconds: 200), 
          width: double.infinity, 
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20), 
          decoration: BoxDecoration(color: isActive ? const Color(0xFFFFC107) : Colors.transparent), 
          child: Text(text, style: TextStyle(color: isActive ? Colors.black : Colors.white, fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 1)), 
        ), 
      ), 
    ); 
  } 

  Widget _buildSidebar() { 
    return Container( 
      width: 250, 
      height: double.infinity, 
      color: const Color(0xFF387EFF), 
      child: Column(children: [ 
        const SizedBox(height: 40), 
        SizedBox(height: 120, child: Image.asset('assets/images/gymify_logo.png', fit: BoxFit.contain)), 
        const SizedBox(height: 40), 
        _menuItem("Osoblje"), 
        _menuItem("Članovi"), 
        _menuItem("Treninzi"), 
        _menuItem("Članarine"), 
        _menuItem("Obavijesti"), 
        _menuItem("Recenzije"), 
        _menuItem("Izvještaj"), 
      ]), 
    ); 
  } 

  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      body: Row(children: [ 
        _buildSidebar(), 
        Expanded(child: _bodyWidget), 
      ]), 
    ); 
  } 
}
