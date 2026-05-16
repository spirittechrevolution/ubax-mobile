import 'package:flutter/material.dart';

enum PropertyStatus { loue, disponible, vendu }

enum BailleurContractType { location, vente }

class BailleurProperty {
  const BailleurProperty({
    required this.id,
    required this.name,
    required this.location,
    required this.imageAsset,
    required this.status,
    required this.totalApartments,
    required this.availableApartments,
    required this.rentedApartments,
    required this.soldApartments,
    required this.bedrooms,
    required this.livingRooms,
    required this.bathrooms,
    required this.surfaceM2,
  });

  final String id;
  final String name;
  final String location;
  final String imageAsset;
  final PropertyStatus status;
  final int totalApartments;
  final int availableApartments;
  final int rentedApartments;
  final int soldApartments;
  final int bedrooms;
  final int livingRooms;
  final int bathrooms;
  final int surfaceM2;
}

class BailleurTenant {
  const BailleurTenant({
    required this.id,
    required this.name,
    required this.apartmentNumber,
    required this.floor,
    required this.phone,
    required this.bailYears,
    required this.avatarAsset,
    required this.reference,
    required this.startDate,
    required this.endDate,
    required this.bailMonths,
    required this.monthlyRent,
    required this.lastPayment,
    required this.caution,
    required this.nextPayment,
    required this.currentBalance,
    required this.progressPercent,
    required this.paidCount,
    required this.pendingCount,
    required this.unpaidCount,
    required this.apartmentImage,
    required this.propertyId,
    required this.isActive,
    required this.contractType,
  });

  final String id;
  final String name;
  final String apartmentNumber;
  final String floor;
  final String phone;
  final int bailYears;
  final String avatarAsset;
  final String reference;
  final String startDate;
  final String endDate;
  final int bailMonths;
  final int monthlyRent;
  final String lastPayment;
  final int caution;
  final String nextPayment;
  final int currentBalance;
  final int progressPercent;
  final int paidCount;
  final int pendingCount;
  final int unpaidCount;
  final String apartmentImage;
  final String propertyId;
  final bool isActive;
  final BailleurContractType contractType;
}

class BailleurFluxPoint {
  const BailleurFluxPoint(this.x, this.y);
  final double x;
  final double y;
}

class BailleurProfile {
  const BailleurProfile({
    required this.name,
    required this.role,
    required this.avatarAsset,
    required this.totalProperties,
    required this.soldCount,
    required this.rentedCount,
    required this.availableCount,
    required this.monthlyRevenue,
    required this.revenueEvolutionPercent,
    required this.revenuePoints,
  });

  final String name;
  final String role;
  final String avatarAsset;
  final int totalProperties;
  final int soldCount;
  final int rentedCount;
  final int availableCount;
  final int monthlyRevenue;
  final int revenueEvolutionPercent;
  final List<BailleurFluxPoint> revenuePoints;
}

const kMockBailleurProfile = BailleurProfile(
  name: 'Franck Ouattara',
  role: 'Bailleur',
  avatarAsset: 'assets/images/pexels-ekrulila-2128329.jpg',
  totalProperties: 10,
  soldCount: 3,
  rentedCount: 5,
  availableCount: 2,
  monthlyRevenue: 850000,
  revenueEvolutionPercent: 5,
  revenuePoints: [
    BailleurFluxPoint(0, 200000),
    BailleurFluxPoint(1, 350000),
    BailleurFluxPoint(2, 260000),
    BailleurFluxPoint(3, 500000),
    BailleurFluxPoint(4, 420000),
    BailleurFluxPoint(5, 700000),
    BailleurFluxPoint(6, 850000),
  ],
);

const kMockBailleurProperties = <BailleurProperty>[
  BailleurProperty(
    id: 'prop-azalai',
    name: 'Résidence Azalai',
    location: 'Cocody Angré, Abidjan – Côte d\'Ivoire',
    imageAsset: 'assets/images/villa.jpg',
    status: PropertyStatus.loue,
    totalApartments: 14,
    availableApartments: 4,
    rentedApartments: 8,
    soldApartments: 2,
    bedrooms: 2,
    livingRooms: 1,
    bathrooms: 1,
    surfaceM2: 130,
  ),
  BailleurProperty(
    id: 'prop-villa-luxe',
    name: 'Villa de luxe',
    location: 'Riviera, Abidjan – Côte d\'Ivoire',
    imageAsset: 'assets/images/villa10.jpg',
    status: PropertyStatus.disponible,
    totalApartments: 1,
    availableApartments: 1,
    rentedApartments: 0,
    soldApartments: 0,
    bedrooms: 5,
    livingRooms: 2,
    bathrooms: 3,
    surfaceM2: 420,
  ),
  BailleurProperty(
    id: 'prop-appartement-moderne',
    name: 'Appartement moderne',
    location: 'Marcory, Abidjan – Côte d\'Ivoire',
    imageAsset: 'assets/images/appartements-luxe.jpg',
    status: PropertyStatus.vendu,
    totalApartments: 1,
    availableApartments: 0,
    rentedApartments: 0,
    soldApartments: 1,
    bedrooms: 3,
    livingRooms: 1,
    bathrooms: 2,
    surfaceM2: 110,
  ),
];

const kMockBailleurTenants = <BailleurTenant>[
  BailleurTenant(
    id: 'tenant-0025',
    name: 'Aïssata Coulibaly',
    apartmentNumber: '0025',
    floor: '2ème étage',
    phone: '+225 01 02 03 04 05',
    bailYears: 1,
    avatarAsset: 'assets/images/villa9.jpg',
    reference: 'UBX-CL-2025-0014',
    startDate: '14/11/2025',
    endDate: '14/11/2026',
    bailMonths: 12,
    monthlyRent: 350000,
    lastPayment: '05/01/2026',
    caution: 500000,
    nextPayment: '05/02/2026',
    currentBalance: 0,
    progressPercent: 10,
    paidCount: 3,
    pendingCount: 9,
    unpaidCount: 0,
    apartmentImage: 'assets/images/chambre11.jpg',
    propertyId: 'prop-azalai',
    isActive: true,
    contractType: BailleurContractType.location,
  ),
  BailleurTenant(
    id: 'tenant-0026',
    name: 'Ismaël Fofana',
    apartmentNumber: '0026',
    floor: '2ème étage',
    phone: '+225 01 02 03 04 05',
    bailYears: 1,
    avatarAsset: 'assets/images/sara2.jpg',
    reference: 'UBX-CL-2025-0015',
    startDate: '01/10/2025',
    endDate: '01/10/2026',
    bailMonths: 12,
    monthlyRent: 320000,
    lastPayment: '01/01/2026',
    caution: 480000,
    nextPayment: '01/02/2026',
    currentBalance: 0,
    progressPercent: 20,
    paidCount: 4,
    pendingCount: 8,
    unpaidCount: 0,
    apartmentImage: 'assets/images/villa3.jpg',
    propertyId: 'prop-azalai',
    isActive: true,
    contractType: BailleurContractType.location,
  ),
  BailleurTenant(
    id: 'tenant-0027',
    name: 'Mariam Touré',
    apartmentNumber: '0027',
    floor: '3ème étage',
    phone: '+225 01 02 03 04 05',
    bailYears: 1,
    avatarAsset: 'assets/images/villa6.jpg',
    reference: 'UBX-CL-2025-0016',
    startDate: '15/09/2025',
    endDate: '15/09/2026',
    bailMonths: 12,
    monthlyRent: 340000,
    lastPayment: '15/01/2026',
    caution: 500000,
    nextPayment: '15/02/2026',
    currentBalance: 0,
    progressPercent: 30,
    paidCount: 5,
    pendingCount: 7,
    unpaidCount: 0,
    apartmentImage: 'assets/images/chambre12.jpg',
    propertyId: 'prop-villa-luxe',
    isActive: true,
    contractType: BailleurContractType.vente,
  ),
];

Color propertyStatusColor(PropertyStatus s) {
  switch (s) {
    case PropertyStatus.loue:
      return const Color(0xFFE87D1E);
    case PropertyStatus.disponible:
      return const Color(0xFF2563EB);
    case PropertyStatus.vendu:
      return const Color(0xFF22C55E);
  }
}

String propertyStatusLabel(PropertyStatus s) {
  switch (s) {
    case PropertyStatus.loue:
      return 'Loué';
    case PropertyStatus.disponible:
      return 'Disponible';
    case PropertyStatus.vendu:
      return 'Vendu';
  }
}
