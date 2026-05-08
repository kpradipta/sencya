import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../theme/colors.dart';
import '../../bloc/booking/booking_bloc.dart';
import '../../bloc/booking/booking_event.dart';
import '../../bloc/booking/booking_state.dart';
import '../../../domain/entities/service.dart';
import '../../../domain/entities/capster.dart';

class BookingSummaryPage extends StatefulWidget {
  final Service service;
  final Capster capster;

  const BookingSummaryPage({
    super.key,
    required this.service,
    required this.capster,
  });

  @override
  State<BookingSummaryPage> createState() => _BookingSummaryPageState();
}

class _BookingSummaryPageState extends State<BookingSummaryPage> {
  DateTime? _selectedTime;
  
  final List<DateTime> _availableSlots = List.generate(8, (index) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + 1, 9 + index, 0);
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BOOKING SUMMARY'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: BlocListener<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is BookingCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Booking Successful!', style: TextStyle(color: AppColors.background)), backgroundColor: AppColors.elegantGold),
            );
            context.go('/home');
          } else if (state is BookingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message, style: TextStyle(color: AppColors.background)), backgroundColor: AppColors.error),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('CONFIRM SELECTION', style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      _buildSummaryRow('Service', widget.service.name),
                      const Divider(color: AppColors.borderStroke, height: 32),
                      _buildSummaryRow('Provider', widget.capster.name),
                      const Divider(color: AppColors.borderStroke, height: 32),
                      _buildSummaryRow('Price', 'Rp ${widget.service.price}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 48),
              Text('SELECT TIME SLOT', style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _availableSlots.map((time) {
                  final isSelected = _selectedTime == time;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTime = time),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: encourages(isSelected),
                        border: Border.all(color: isSelected ? AppColors.elegantGold : AppColors.borderStroke),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        DateFormat('HH:mm').format(time),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isSelected ? AppColors.matteBlack : AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const Spacer(),
              BlocBuilder<BookingBloc, BookingState>(
                builder: (context, state) {
                  if (state is BookingLoading) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.elegantGold));
                  }
                  return ElevatedButton(
                    onPressed: _selectedTime == null
                        ? null
                        : () {
                            context.read<BookingBloc>().add(
                                  CreateBookingRequested(
                                    serviceId: widget.service.id,
                                    capsterId: widget.capster.id,
                                    scheduledAt: _selectedTime!,
                                  ),
                                );
                          },
                    child: const Text('CONFIRM BOOKING'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color encourages(bool isSelected) {
    return isSelected ? AppColors.elegantGold : Colors.transparent;
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
        Text(value, style: Theme.of(context).textTheme.titleSmall),
      ],
    );
  }
}
