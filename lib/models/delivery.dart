// Delivery model class
class Delivery {
  final String id;
  final String customerName;
  final String address;
  final String phone;
  final String packageDetails;
  final DeliveryStatus status;
  final DateTime scheduledTime;
  final String? notes;
  final double? latitude;
  final double? longitude;

  Delivery({
    required this.id,
    required this.customerName,
    required this.address,
    required this.phone,
    required this.packageDetails,
    required this.status,
    required this.scheduledTime,
    this.notes,
    this.latitude,
    this.longitude,
  });
}

enum DeliveryStatus { pending, completed, failed }

// Sample delivery data
class DeliveryData {
  static List<Delivery> getSampleDeliveries() {
    return [
      // Pending deliveries
      Delivery(
        id: 'D001',
        customerName: 'John Smith',
        address: '123 Main St, New York, NY 10001',
        phone: '+1 (555) 123-4567',
        packageDetails: 'Electronics Package - 2 items',
        status: DeliveryStatus.pending,
        scheduledTime: DateTime.now().add(const Duration(hours: 1)),
        notes: 'Ring doorbell twice',
      ),
      Delivery(
        id: 'D002',
        customerName: 'Sarah Johnson',
        address: '456 Oak Ave, New York, NY 10002',
        phone: '+1 (555) 234-5678',
        packageDetails: 'Books - 1 package',
        status: DeliveryStatus.pending,
        scheduledTime: DateTime.now().add(const Duration(hours: 2)),
        notes: 'Leave at door if no answer',
      ),
      Delivery(
        id: 'D003',
        customerName: 'Mike Wilson',
        address: '789 Pine St, New York, NY 10003',
        phone: '+1 (555) 345-6789',
        packageDetails: 'Clothing - 3 items',
        status: DeliveryStatus.pending,
        scheduledTime: DateTime.now().add(const Duration(hours: 3)),
      ),
      Delivery(
        id: 'D004',
        customerName: 'Emily Davis',
        address: '321 Elm Dr, New York, NY 10004',
        phone: '+1 (555) 456-7890',
        packageDetails: 'Home & Garden - 1 item',
        status: DeliveryStatus.pending,
        scheduledTime: DateTime.now().add(const Duration(hours: 4)),
        notes: 'Fragile - Handle with care',
      ),
      Delivery(
        id: 'D005',
        customerName: 'David Brown',
        address: '654 Maple Ln, New York, NY 10005',
        phone: '+1 (555) 567-8901',
        packageDetails: 'Sports Equipment - 2 items',
        status: DeliveryStatus.pending,
        scheduledTime: DateTime.now().add(const Duration(hours: 5)),
      ),
      Delivery(
        id: 'D006',
        customerName: 'Lisa Anderson',
        address: '987 Cedar St, New York, NY 10006',
        phone: '+1 (555) 678-9012',
        packageDetails: 'Kitchen Appliances - 1 item',
        status: DeliveryStatus.pending,
        scheduledTime: DateTime.now().add(const Duration(hours: 6)),
        notes: 'Heavy item - requires assistance',
      ),
      Delivery(
        id: 'D007',
        customerName: 'Tom Miller',
        address: '147 Birch Ave, New York, NY 10007',
        phone: '+1 (555) 789-0123',
        packageDetails: 'Documents - Express delivery',
        status: DeliveryStatus.pending,
        scheduledTime: DateTime.now().add(const Duration(minutes: 30)),
        notes: 'Urgent - Priority delivery',
      ),
      Delivery(
        id: 'D008',
        customerName: 'Anna Taylor',
        address: '258 Spruce Dr, New York, NY 10008',
        phone: '+1 (555) 890-1234',
        packageDetails: 'Pharmacy Items - 1 package',
        status: DeliveryStatus.pending,
        scheduledTime: DateTime.now().add(const Duration(hours: 7)),
        notes: 'Prescription medication - ID required',
      ),

      // Completed deliveries
      Delivery(
        id: 'D009',
        customerName: 'Robert White',
        address: '369 Willow St, New York, NY 10009',
        phone: '+1 (555) 901-2345',
        packageDetails: 'Electronics - 1 item',
        status: DeliveryStatus.completed,
        scheduledTime: DateTime.now().subtract(const Duration(hours: 2)),
        notes: 'Delivered to front door',
      ),
      Delivery(
        id: 'D010',
        customerName: 'Jennifer Garcia',
        address: '741 Aspen Rd, New York, NY 10010',
        phone: '+1 (555) 012-3456',
        packageDetails: 'Food & Beverages - 2 items',
        status: DeliveryStatus.completed,
        scheduledTime: DateTime.now().subtract(const Duration(hours: 3)),
        notes: 'Customer satisfied',
      ),
      Delivery(
        id: 'D011',
        customerName: 'Chris Martinez',
        address: '852 Poplar Ave, New York, NY 10011',
        phone: '+1 (555) 123-4567',
        packageDetails: 'Books & Media - 3 items',
        status: DeliveryStatus.completed,
        scheduledTime: DateTime.now().subtract(const Duration(hours: 4)),
      ),

      // Failed delivery
      Delivery(
        id: 'D012',
        customerName: 'Jessica Lee',
        address: '963 Hickory Ln, New York, NY 10012',
        phone: '+1 (555) 234-5678',
        packageDetails: 'Personal Care - 1 package',
        status: DeliveryStatus.failed,
        scheduledTime: DateTime.now().subtract(const Duration(hours: 1)),
        notes: 'Customer not available - will retry tomorrow',
      ),
    ];
  }

  static List<Delivery> getDeliveriesByStatus(DeliveryStatus status) {
    return getSampleDeliveries()
        .where((delivery) => delivery.status == status)
        .toList();
  }
}
