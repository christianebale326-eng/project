import 'package:flutter/material.dart';

class NavItem {
  final String label;
  final IconData icon;
  const NavItem(this.label, this.icon);
}

const Map<String, List<NavItem>> navFor = {
  'student': [
    NavItem('Dashboard', Icons.dashboard_outlined),
    NavItem('Capstone Request', Icons.description_outlined),
    NavItem('My Assignment', Icons.workspace_premium_outlined),
    NavItem('Defense Schedule', Icons.event_outlined),
  ],
  'faculty': [
    NavItem('Dashboard', Icons.dashboard_outlined),
    NavItem('My Profile', Icons.manage_accounts_outlined),
    NavItem('Assignments', Icons.assignment_outlined),
    NavItem('Advisees & Panels', Icons.groups_outlined),
  ],
  'coordinator': [
    NavItem('Dashboard', Icons.dashboard_outlined),
    NavItem('Matching Monitor', Icons.monitor_heart_outlined),
    NavItem('Load Balance', Icons.bar_chart_outlined),
    NavItem('Audit Logs', Icons.receipt_long_outlined),
  ],
  'admin': [
    NavItem('Dashboard', Icons.dashboard_outlined),
    NavItem('User Accounts', Icons.people_outline),
    NavItem('Matching Config', Icons.tune_outlined),
    NavItem('System Statistics', Icons.insights_outlined),
  ],
};

class RoleMeta {
  final String label;
  final IconData icon;
  final String name;
  final String sub;
  const RoleMeta(this.label, this.icon, this.name, this.sub);
}

const Map<String, RoleMeta> roleMeta = {
  'student': RoleMeta('Student', Icons.school_outlined, 'Maria Lopez', 'BSIT — 4th Year'),
  'faculty': RoleMeta('Faculty', Icons.work_outline, 'Dr. Elena Marquez', 'Machine Learning & Data Science'),
  'coordinator': RoleMeta('Coordinator', Icons.verified_user_outlined, 'Prof. Jeanie Delos Arcos', 'Department Coordinator'),
  'admin': RoleMeta('Administrator', Icons.admin_panel_settings_outlined, 'System Admin', 'ADSSU — IT Department'),
};

const List<String> roleOrder = ['student', 'faculty', 'coordinator', 'admin'];
