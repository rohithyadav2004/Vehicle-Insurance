class incidentModel {
  const incidentModel({
    this.incidentID,
    this.incidentType,
    this.incidentDate,
    this.Description,
    this.incidentCost
  });
  final String? incidentID;
  final String? incidentType;
  final String? incidentDate;
  final String? Description;
  final int? incidentCost;
}


class vehicleServiceModel{
  const vehicleServiceModel({
    this.vsId,
    this.vId,
    this.custId,
    this.vsName,
    this.vsAddress,
    this.vsContact,
    this.vsIncharge,
    this.vsType
  });
  final String? vsId;
  final String? vId;
  final String? custId;
  final String? vsName;
  final String? vsAddress;
  final int? vsContact;
  final String? vsIncharge;
  final String? vsType;
}

class IncidentReportModel{
  const IncidentReportModel({
    this.incidentReportID,
    this.incidentID,
    this.incidentCost,
    this.customerId,
    this.incidentType,
    this.incidentDescription,
    this.incidentInsepector
  });

  final String? incidentReportID;
  final String? incidentID;
  final int? incidentCost;
  final String? customerId;
  final String?  incidentType;
  final String? incidentDescription;
  final String? incidentInsepector;
}


class ClaimModel{
  const ClaimModel({
    this.claimId,
    this.agreementId,
    this.claimAmt,
    this.incidentId,
    this.damageType,
    this.dateOfClaim,
    this.claimStatus,
    this.customerId
  });

  final String?  claimId;
  final String? agreementId;
  final int? claimAmt;
  final String? incidentId;
  final String? damageType;
  final String? dateOfClaim;
  final String? claimStatus;
  final String? customerId;
}

class ClaimSettlementModel{
  const ClaimSettlementModel({
    this.claimSetId,
    this.claimId,
    this.custId,
    this.vehicleId,
    this.dateSettled,
    this.coverageId,
    this.amountPaid,
  });
  final String? claimSetId;
  final String? claimId;
  final String? custId;
  final String? vehicleId;
  final String? dateSettled;
  final String? coverageId;
  final int? amountPaid;
}

class VehicleCardModel{
  const VehicleCardModel({
    this.vehicleType,
    this.vehicleRegistrationNumber,
    this.expiryDate
  });
  final String? vehicleType;
  final String? vehicleRegistrationNumber;
  final bool? expiryDate;
}