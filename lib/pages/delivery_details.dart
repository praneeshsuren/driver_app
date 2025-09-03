import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/delivery.dart';

class DeliveryDetailsPage extends StatefulWidget {
  final Delivery delivery;

  const DeliveryDetailsPage({super.key, required this.delivery});

  @override
  State<DeliveryDetailsPage> createState() => _DeliveryDetailsPageState();
}

class _DeliveryDetailsPageState extends State<DeliveryDetailsPage> {
  bool _isProcessing = false;

  Color _getStatusColor(DeliveryStatus status) {
    switch (status) {
      case DeliveryStatus.pending:
        return Colors.orange;
      case DeliveryStatus.completed:
        return Colors.green;
      case DeliveryStatus.failed:
        return Colors.red;
    }
  }

  IconData _getStatusIcon(DeliveryStatus status) {
    switch (status) {
      case DeliveryStatus.pending:
        return Icons.schedule;
      case DeliveryStatus.completed:
        return Icons.check_circle;
      case DeliveryStatus.failed:
        return Icons.error;
    }
  }

  String _getStatusText(DeliveryStatus status) {
    switch (status) {
      case DeliveryStatus.pending:
        return 'Pending';
      case DeliveryStatus.completed:
        return 'Completed';
      case DeliveryStatus.failed:
        return 'Failed';
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  String _formatDate(DateTime dateTime) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
  }

  void _navigateToAddress() {
    // In a real app, this would open Google Maps or in-app navigation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.navigation, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text('Opening navigation to ${widget.delivery.address}'),
            ),
          ],
        ),
        backgroundColor: Colors.blue.shade600,
      ),
    );
  }

  void _callCustomer() {
    // In a real app, this would initiate a phone call
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.phone, color: Colors.white),
            const SizedBox(width: 8),
            Text('Calling ${widget.delivery.customerName}...'),
          ],
        ),
        backgroundColor: Colors.green.shade600,
      ),
    );
  }

  void _markAsDelivered() {
    _showProofOfDeliveryDialog();
  }

  void _markAsFailed() {
    _showFailureReasonDialog();
  }

  void _showProofOfDeliveryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Proof of Delivery'),
          content: const Text(
            'Please capture proof of delivery before marking as completed.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showProofOptionsBottomSheet();
              },
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  void _showFailureReasonDialog() {
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Mark as Failed'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Please provide a reason for the failed delivery:'),
              const SizedBox(height: 16),
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(
                  hintText: 'Enter reason...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (reasonController.text.trim().isNotEmpty) {
                  Navigator.pop(context);
                  _processStatusUpdate(
                    DeliveryStatus.failed,
                    reasonController.text.trim(),
                  );
                }
              },
              child: const Text('Mark as Failed'),
            ),
          ],
        );
      },
    );
  }

  void _showProofOptionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Capture Proof of Delivery',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildProofOption(
                        icon: Icons.camera_alt,
                        title: 'Take Photo',
                        subtitle: 'Capture delivery photo',
                        onTap: () {
                          Navigator.pop(context);
                          _capturePhoto();
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildProofOption(
                        icon: Icons.edit,
                        title: 'Get Signature',
                        subtitle: 'Customer signature',
                        onTap: () {
                          Navigator.pop(context);
                          _captureSignature();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _processStatusUpdate(
                        DeliveryStatus.completed,
                        'No proof captured',
                      );
                    },
                    child: const Text('Skip Proof (Not Recommended)'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProofOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32, color: Colors.blue.shade600),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _capturePhoto() {
    // In a real app, this would open the camera
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.camera_alt, color: Colors.white),
            SizedBox(width: 8),
            Text('Camera opened for delivery photo'),
          ],
        ),
        backgroundColor: Colors.blue.shade600,
        action: SnackBarAction(
          label: 'Complete',
          textColor: Colors.white,
          onPressed: () {
            _processStatusUpdate(DeliveryStatus.completed, 'Photo captured');
          },
        ),
      ),
    );
  }

  void _captureSignature() {
    // In a real app, this would open a signature capture screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.edit, color: Colors.white),
            SizedBox(width: 8),
            Text('Signature pad opened'),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        action: SnackBarAction(
          label: 'Complete',
          textColor: Colors.white,
          onPressed: () {
            _processStatusUpdate(
              DeliveryStatus.completed,
              'Signature captured',
            );
          },
        ),
      ),
    );
  }

  void _processStatusUpdate(DeliveryStatus newStatus, String proof) {
    setState(() {
      _isProcessing = true;
    });

    // Simulate API call delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isProcessing = false;
      });

      final statusText = _getStatusText(newStatus);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Delivery marked as $statusText'),
          backgroundColor: _getStatusColor(newStatus),
        ),
      );

      // Navigate back to previous screen
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(widget.delivery.status);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: statusColor,
        foregroundColor: Colors.white,
        title: Text(
          'Delivery ${widget.delivery.id}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getStatusIcon(widget.delivery.status),
                  size: 16,
                  color: Colors.white,
                ),
                const SizedBox(width: 4),
                Text(
                  _getStatusText(widget.delivery.status),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _isProcessing
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Updating delivery status...'),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Map Preview Section
                  Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: Stack(
                      children: [
                        // Placeholder for map
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.shade100,
                                Colors.blue.shade300,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.map, size: 48, color: Colors.white),
                                SizedBox(height: 8),
                                Text(
                                  'Map Preview',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Location marker
                        const Positioned(
                          top: 80,
                          left: 0,
                          right: 0,
                          child: Icon(
                            Icons.location_on,
                            size: 40,
                            color: Colors.red,
                          ),
                        ),
                        // Navigate button overlay
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: FloatingActionButton(
                            onPressed: _navigateToAddress,
                            backgroundColor: Colors.blue.shade600,
                            child: const Icon(
                              Icons.navigation,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Customer Information
                  _buildSection(
                    title: 'Customer Information',
                    child: Column(
                      children: [
                        _buildInfoRow(
                          icon: Icons.person,
                          label: 'Name',
                          value: widget.delivery.customerName,
                          actionIcon: null,
                        ),
                        _buildInfoRow(
                          icon: Icons.phone,
                          label: 'Phone',
                          value: widget.delivery.phone,
                          actionIcon: Icons.call,
                          onActionTap: _callCustomer,
                        ),
                        _buildInfoRow(
                          icon: Icons.location_on,
                          label: 'Address',
                          value: widget.delivery.address,
                          actionIcon: Icons.map,
                          onActionTap: _navigateToAddress,
                        ),
                      ],
                    ),
                  ),

                  // Delivery Information
                  _buildSection(
                    title: 'Delivery Information',
                    child: Column(
                      children: [
                        _buildInfoRow(
                          icon: Icons.inventory,
                          label: 'Items to Deliver',
                          value: widget.delivery.packageDetails,
                        ),
                        _buildInfoRow(
                          icon: Icons.schedule,
                          label: 'Estimated Time',
                          value:
                              '${_formatDate(widget.delivery.scheduledTime)} at ${_formatTime(widget.delivery.scheduledTime)}',
                        ),
                        _buildInfoRow(
                          icon: Icons.local_shipping,
                          label: 'Delivery ID',
                          value: widget.delivery.id,
                        ),
                      ],
                    ),
                  ),

                  // Special Instructions
                  if (widget.delivery.notes != null)
                    _buildSection(
                      title: 'Special Instructions',
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.amber.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info, color: Colors.amber.shade700),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                widget.delivery.notes!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.amber.shade800,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Actions section - only show for pending deliveries
                  if (widget.delivery.status == DeliveryStatus.pending)
                    _buildSection(
                      title: 'Actions',
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _navigateToAddress,
                                  icon: const Icon(Icons.navigation),
                                  label: const Text('Navigate'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade600,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _callCustomer,
                                  icon: const Icon(Icons.phone),
                                  label: const Text('Call'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade600,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _markAsDelivered,
                                  icon: const Icon(Icons.check_circle),
                                  label: const Text('Mark as Delivered'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade600,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _markAsFailed,
                                  icon: const Icon(Icons.error),
                                  label: const Text('Mark as Failed'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade600,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    IconData? actionIcon,
    VoidCallback? onActionTap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (actionIcon != null && onActionTap != null)
            IconButton(
              onPressed: onActionTap,
              icon: Icon(actionIcon, color: Colors.blue.shade600),
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            ),
        ],
      ),
    );
  }
}
