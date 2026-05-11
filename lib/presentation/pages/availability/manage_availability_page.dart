import 'package:flutter/material.dart';
import '../../../theme/colors.dart';

class ManageAvailabilityPage extends StatelessWidget {
  const ManageAvailabilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Manage Availability', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Save', style: TextStyle(color: AppColors.primaryRed, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.withOpacity(0.3)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, color: Colors.orange, size: 16),
                        SizedBox(width: 8),
                        Text('Simulated Data', style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  _buildDaySelector(),
                  const SizedBox(height: 32),
                  const Text('TIME DETAILS', style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 2)),
                  const SizedBox(height: 12),
                  _buildTimeSection(),
                  const SizedBox(height: 32),
                  const Text('QUICK PRESETS', style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 2)),
                  const SizedBox(height: 12),
                  _buildQuickPresets(),
                  const SizedBox(height: 32),
                  _buildSettingsSection(),
                  const SizedBox(height: 32),
                  const Text('INTERNAL NOTE', style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 2)),
                  const SizedBox(height: 12),
                  _buildNoteInput(),
                  const SizedBox(height: 24),
                  _buildConflictWarning(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          _buildBottomCTA(),
        ],
      ),
    );
  }

  Widget _buildDaySelector() {
    return SizedBox(
      height: 84,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildDayItem('Mon', '12', false),
          const SizedBox(width: 10),
          _buildDayItem('Tue', '13', true),
          const SizedBox(width: 10),
          _buildDayItem('Wed', '14', false),
          const SizedBox(width: 10),
          _buildDayItem('Thu', '15', false),
          const SizedBox(width: 10),
          _buildDayItem('Fri', '16', false),
        ],
      ),
    );
  }

  Widget _buildDayItem(String day, String date, bool isActive) {
    return Container(
      width: 64,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryRed : AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: isActive ? null : Border.all(color: AppColors.borderDark),
        boxShadow: isActive ? [
          BoxShadow(color: AppColors.primaryRed.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))
        ] : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(day, style: TextStyle(color: isActive ? Colors.white70 : AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(date, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildTimeSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        children: [
          _buildToggleItem(Icons.event_available, 'Full Day', false),
          const Divider(height: 1, color: AppColors.borderDark),
          _buildTimePickerItem(Icons.schedule, 'Start Time', '12:30 PM'),
          const Divider(height: 1, color: AppColors.borderDark),
          _buildTimePickerItem(Icons.lock_clock, 'End Time', '01:30 PM'),
        ],
      ),
    );
  }

  Widget _buildToggleItem(IconData icon, String label, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.white60, size: 20),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
          const Spacer(),
          Switch(
            value: value,
            onChanged: (v) {},
            activeThumbColor: AppColors.primaryRed,
            activeTrackColor: AppColors.primaryRed.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePickerItem(IconData icon, String label, String time) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          children: [
            Icon(icon, color: Colors.white60, size: 20),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(time, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickPresets() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildPresetItem(Icons.restaurant, 'Lunch', '1 Hour'),
        _buildPresetItem(Icons.coffee, 'Break', '15 Mins'),
        _buildPresetItem(Icons.person, 'Errands', '30 Mins'),
        _buildPresetItem(Icons.more_time, 'Other', 'Custom'),
      ],
    );
  }

  Widget _buildPresetItem(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryRed, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('RECURRENCE', style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 2)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderDark),
          ),
          child: _buildSimpleListItem(Icons.repeat, 'Repeat', 'Every Tuesday'),
        ),
      ],
    );
  }

  Widget _buildSimpleListItem(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.white60, size: 20),
      title: Text(label, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: const TextStyle(color: Colors.white38, fontSize: 14)),
          const Icon(Icons.chevron_right, color: Colors.white24, size: 20),
        ],
      ),
      onTap: () {},
    );
  }

  Widget _buildNoteInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: const TextField(
        style: TextStyle(color: Colors.white, fontSize: 14),
        maxLines: 3,
        decoration: InputDecoration(
          hintText: 'Add a reason for this block (e.g. Dentists appointment)',
          hintStyle: TextStyle(color: Colors.white12, fontSize: 14),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildConflictWarning() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryRed.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryRed.withOpacity(0.2)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning, color: AppColors.primaryRed, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'This block overlaps with an appointment for John D. at 1:15 PM.',
              style: TextStyle(color: AppColors.primaryRed, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomCTA() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.borderDark)),
      ),
      child: SafeArea(
        top: false,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryRed,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
          child: const Text('Confirm Availability Change', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ),
    );
  }
}
