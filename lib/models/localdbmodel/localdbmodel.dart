class PersonalFarmer {
  final String id;
  final String timeDisplay;
//beneficiary Type
  final String farmerId;
  final String beneficiaryType;

  final String enumeratorValue;

//farmer Details
  // final String farmerRegNum;
  final String farmerfirstName;
  final String farmerotherName;
  final String farmersurName;
  final String farmerGender;
  final String farmerPhoneNum;
  final String farmerDoB;
  final String farmerMail;
  final String farmerPostal;
  final String kinName;
  final String kinRelationShip;
  final String kinDoB;
  final String kinGender;
  final String kinPhoneNum;
  final String kinPostal;
  final String farmerPic64;

  //group Details
  final String groupName;
  final String groupPresident;
  final String groupSecretary;
  final String groupphoneNumber;
  final String groupDirectors;
  final String groupEmail;
  final String groupAddress;

  //farm Details
  final String region;
  final String forestDistrict;
  final String mddas;
  final String mddasName;
  final String community;
  final String family;
  final String typeofEstablishment;

  //farm Cordinates
  final String farmID;
  final String farmArea;
  final String pointsGet;

  //tree Plantation Detail
  final String c2treePlantationDetail;
  final String c3treePlantationDetail;

  // declaration Signatures - one more should be added
  final String farmerdeclarationSig;
  final String witnessdeclarationSig;
  final String witnessName;
  final String witnessPhone;

  // connection status
  String conStat;

  PersonalFarmer({
    required this.id,
    this.timeDisplay = '',
    this.farmerId = '',
    this.beneficiaryType = '',
    this.enumeratorValue = '',
    this.farmerfirstName = '',
    this.farmerotherName = '',
    this.farmersurName = '',
    this.farmerGender = '',
    this.farmerPhoneNum = '',
    this.farmerDoB = '',
    this.farmerMail = '',
    this.farmerPostal = '',
    this.kinName = '',
    this.kinRelationShip = '',
    this.kinDoB = '',
    this.kinGender = '',
    this.kinPhoneNum = '',
    this.kinPostal = '',
    this.farmerPic64 = '',
    this.region = '',
    this.forestDistrict = '',
    this.mddas = '',
    this.mddasName = '',
    this.community = '',
    this.family = '',
    this.typeofEstablishment = '',
    this.farmID = '',
    this.farmArea = '',
    this.pointsGet = '',
    this.c2treePlantationDetail = '',
    this.c3treePlantationDetail = '',
    this.farmerdeclarationSig = '',
    this.witnessdeclarationSig = '',
    this.witnessName = '',
    this.witnessPhone = '',
    this.groupName = '',
    this.groupPresident = '',
    this.groupDirectors = '',
    this.groupSecretary = '',
    this.groupphoneNumber = '',
    this.groupEmail = '',
    this.groupAddress = '',
    this.conStat = '',
  });
}

class UserFreq {
  String id;
  String firstTime;
  String displayName;
  String enumeratorValue;
  String status;
  String logStatus;
  String enumeratorContact;
  String enumeratorPassword;

  UserFreq({
    required this.id,
    this.firstTime = '',
    this.displayName = '',
    this.enumeratorValue = '',
    this.status = '',
    this.logStatus = '',
    this.enumeratorContact = '',
    this.enumeratorPassword = '',
  });
}

class SeedlingMonitoring {
  final String smId;
  final String smTimeDisplay;
  final String smCommunity;
  final String smVisitDate;
  final String smEnumeratorValue;
  final String smFarmerId;
  final String smFarmerName;
  final String smBaseline;
  final String smFarmerContact;
  final String smSpecies;
  final String smReceivedDate;
  final String smPlantedDate;
  final String smQuantityReceived;
  final String smQuantityPlanted;
  final String smQuantitySurvived;
  final String smPlantingArea;
  final String smAreaSize;
  final String smRegisteredTrees;
  final String smFarmLocation;
  final String smConStat;

  SeedlingMonitoring({
    required this.smId,
    this.smTimeDisplay = '',
    this.smCommunity = '',
    this.smVisitDate = '',
    this.smEnumeratorValue = '',
    this.smFarmerId = '',
    this.smFarmerName = '',
    this.smBaseline = '',
    this.smFarmerContact = '',
    this.smSpecies = '',
    this.smReceivedDate = '',
    this.smPlantedDate = '',
    this.smQuantityReceived = '',
    this.smQuantityPlanted = '',
    this.smQuantitySurvived = '',
    this.smPlantingArea = '',
    this.smAreaSize = '',
    this.smRegisteredTrees = '',
    this.smFarmLocation = '',
    this.smConStat = '',
  });
}

class SeedlingMonitoring2 {
  final String smId;
  final String smTimeDisplay;
  final String smCommunity;
  final String smVisitDate;
  final String smEnumeratorValue;
  final String smBaseline;
  final String surveyorName;
  final String dateOfSurvey;
  final String community;
  final String farmerName;
  final String farmerIDNumber;
  final String typeOfPlantation;
  final String totalSizeAcres;
  final String speciesProvidedPlanted;
  final String pr_quantityReceived;
  final String pr_quantityPlanted;
  final String pr_farmerdOB;
  final String ka_quantityReceived;
  final String ka_quantityPlanted;
  final String ka_farmerdOB;
  final String da_quantityReceived;
  final String da_quantityPlanted;
  final String da_farmerdOB;
  final String ed_quantityReceived;
  final String ed_quantityPlanted;
  final String ed_farmerdOB;
  final String em_quantityReceived;
  final String em_quantityPlanted;
  final String em_farmerdOB;
  final String of_quantityReceived;
  final String of_quantityPlanted;
  final String of_farmerdOB;
  final String md_quantityReceived;
  final String md_quantityPlanted;
  final String md_farmerdOB;
  final String mo_quantityReceived;
  final String mo_quantityPlanted;
  final String mo_farmerdOB;
  final String ok_quantityReceived;
  final String ok_quantityPlanted;
  final String ok_farmerdOB;
  final String eu_quantityReceived;
  final String eu_quantityPlanted;
  final String eu_farmerdOB;
  final String ba_quantityReceived;
  final String ba_quantityPlanted;
  final String ba_farmerdOB;
  final String mappedFarmBoundaries;
  final String totalSeedlingsAliveController;
  final String speciesAlive;
  final String reasonForDeath;
  final String mappedSurvidedSeedlings;
  final String sourceOfWater;
  final String waterignFrequency;
  final String anyExtremeSigns;
  final String extremeWeathers;
  final String pestsAroundYesNoValue;
  final String pestDescription;
  final String signsDiseaseYesNoValue;
  final String diseaseDescription;
  final String fertiliserAppliedYesNoValue;
  final String fertiliserType;
  final String pesticideHerbicideAppliedYesNoValue;
  final String pesticideHerbicideType;
  final String additionalObservations;
  String conStat;

  SeedlingMonitoring2({
    required this.smId,
    this.smTimeDisplay = '',
    this.smCommunity = '',
    this.smVisitDate = '',
    this.smEnumeratorValue = '',
    this.smBaseline = '',
    this.surveyorName = '',
    this.dateOfSurvey = '',
    this.community = '',
    this.farmerName = '',
    this.farmerIDNumber = '',
    this.typeOfPlantation = '',
    this.totalSizeAcres = '',
    this.speciesProvidedPlanted = '',
    this.pr_quantityReceived = '',
    this.pr_quantityPlanted = '',
    this.pr_farmerdOB = '',
    this.ka_quantityReceived = '',
    this.ka_quantityPlanted = '',
    this.ka_farmerdOB = '',
    this.da_quantityReceived = '',
    this.da_quantityPlanted = '',
    this.da_farmerdOB = '',
    this.ed_quantityReceived = '',
    this.ed_quantityPlanted = '',
    this.ed_farmerdOB = '',
    this.em_quantityReceived = '',
    this.em_quantityPlanted = '',
    this.em_farmerdOB = '',
    this.of_quantityReceived = '',
    this.of_quantityPlanted = '',
    this.of_farmerdOB = '',
    this.md_quantityReceived = '',
    this.md_quantityPlanted = '',
    this.md_farmerdOB = '',
    this.mo_quantityReceived = '',
    this.mo_quantityPlanted = '',
    this.mo_farmerdOB = '',
    this.ok_quantityReceived = '',
    this.ok_quantityPlanted = '',
    this.ok_farmerdOB = '',
    this.eu_quantityReceived = '',
    this.eu_quantityPlanted = '',
    this.eu_farmerdOB = '',
    this.ba_quantityReceived = '',
    this.ba_quantityPlanted = '',
    this.ba_farmerdOB = '',
    this.mappedFarmBoundaries = '',
    this.totalSeedlingsAliveController = '',
    this.speciesAlive = '',
    this.reasonForDeath = '',
    this.mappedSurvidedSeedlings = '',
    this.sourceOfWater = '',
    this.waterignFrequency = '',
    this.anyExtremeSigns = '',
    this.extremeWeathers = '',
    this.pestsAroundYesNoValue = '',
    this.pestDescription = '',
    this.signsDiseaseYesNoValue = '',
    this.diseaseDescription = '',
    this.fertiliserAppliedYesNoValue = '',
    this.fertiliserType = '',
    this.pesticideHerbicideAppliedYesNoValue = '',
    this.pesticideHerbicideType = '',
    this.additionalObservations = '',
    this.conStat = '',
  });
}

class LMBMonitoring {
  final String lmbId;
  final String lmbTimeDisplay;
  final String lmbEnumeratorValue;
  final String lmbName;
  final String lmbSector;
  final String lmbPrivateName;
  final String lmbFirstEngagement;
  final String lmbPartnershipType;
  final String lmbPartnershipDuration;
  final String lmbMou;
  final String lmbFinancialName;
  final String lmbTypeLoanService;
  final String lmbLoanDuration;
  final String lmbLoanInterest;
  final String lmbFemaleBenefit;
  final String lmbMaleBenefit;
  final String lmbYouthBenefit;
  final String lmbConStat;

  LMBMonitoring({
    required this.lmbId,
    this.lmbTimeDisplay = '',
    this.lmbEnumeratorValue = '',
    this.lmbName = '',
    this.lmbSector = '',
    this.lmbPrivateName = '',
    this.lmbFirstEngagement = '',
    this.lmbPartnershipType = '',
    this.lmbPartnershipDuration = '',
    this.lmbMou = '',
    this.lmbFinancialName = '',
    this.lmbTypeLoanService = '',
    this.lmbLoanDuration = '',
    this.lmbLoanInterest = '',
    this.lmbFemaleBenefit = '',
    this.lmbMaleBenefit = '',
    this.lmbYouthBenefit = '',
    this.lmbConStat = '',
  });
}

class AlternativeLivelihood {
  final String alId;
  final String alTimeDisplay;
  final String alCommunity;
  final String alEnumeratorValue;
  final String alVisitDate;
  final String alFarmerId;
  final String alFarmerName;
  final String alBasline;
  final String alFarmerContact;
  final String alAdditionalActivity;
  final String alTrainerOrg;
  final String alOperationsStartDate;
  final String alInitialAmount;
  final String alAmountType;
  final String alAmount;
  final String alAmountToLMB;
  final String alActivitySupported;
  final String alConStat;

  AlternativeLivelihood({
    required this.alId,
    this.alTimeDisplay = '',
    this.alCommunity = '',
    this.alEnumeratorValue = '',
    this.alVisitDate = '',
    this.alFarmerId = '',
    this.alFarmerName = '',
    this.alBasline = '',
    this.alFarmerContact = '',
    this.alAdditionalActivity = '',
    this.alTrainerOrg = '',
    this.alOperationsStartDate = '',
    this.alInitialAmount = '',
    this.alAmountType = '',
    this.alAmount = '',
    this.alAmountToLMB = '',
    this.alActivitySupported = '',
    this.alConStat = '',
  });
}

class TrainingLog {
  final String? tlId;
  final String? tlTimeDisplay;
  final String? tlCommunityName;
  final String? tlTopic;
  final String? tlEventDate;
  final String? tlDuration;
  final String? tlTrainerName;
  final String? tlTrainerOrg;
  final String? tlEnumeratorValue;
  final String? tlParticipantDetails;
  final String? tlConStat;

  TrainingLog({
    required this.tlId,
    this.tlTimeDisplay,
    this.tlCommunityName,
    this.tlTopic,
    this.tlEventDate,
    this.tlDuration,
    this.tlTrainerName,
    this.tlTrainerOrg,
    this.tlEnumeratorValue,
    this.tlParticipantDetails,
    this.tlConStat,
  });
}

class RegisteredFarmer {
  final String? foId;
  final String? foCommunity;
  final String? foFarmerName;
  final String? foContact;
  final String? foGender;
  final String? foDoB;
  final String? foHolderCategory;
  final String? foFarmSize;
  final String? foConStat;

  RegisteredFarmer({
    required this.foId,
    this.foCommunity,
    this.foFarmerName,
    this.foContact,
    this.foGender,
    this.foDoB,
    this.foHolderCategory,
    this.foFarmSize,
    this.foConStat,
  });
}

class RegisteredFarmerListApiSeedling {
  final String? falSId;
  final String? falSFarmerName;
  final String? falSCommunityName;
  final String? falSCommunityId;
  final String? falSContact;
  final String? falSBaseline;
  final String? dateCreated;

  RegisteredFarmerListApiSeedling({
    required this.falSId,
    this.falSFarmerName,
    this.falSCommunityName,
    this.falSCommunityId,
    this.falSContact,
    this.falSBaseline,
    this.dateCreated,
  });
}

class RegisteredFarmerListApiAlternative {
  final String? falAId;
  final String? falAFarmerName;
  final String? falACommunityName;
  final String? falACommunityId;
  final String? falAContact;
  final String? falABaseline;
  final String? dateCreated;

  RegisteredFarmerListApiAlternative({
    required this.falAId,
    this.falAFarmerName,
    this.falACommunityName,
    this.falACommunityId,
    this.falAContact,
    this.falABaseline,
    this.dateCreated,
  });
}

class NewsAndArticles {
  final String naId;
  final String naTimeDisplay;
  final String naTitle;
  final String naContent;

  NewsAndArticles({
    required this.naId,
    this.naTimeDisplay = '',
    this.naTitle = '',
    this.naContent = '',
  });
}

class WorkShops {
  final String wsId;
  final String wsTimeDisplay;
  final String wsTitle;
  final String wsContent;

  WorkShops({
    required this.wsId,
    this.wsTimeDisplay = '',
    this.wsTitle = '',
    this.wsContent = '',
  });
}

class PersonalFarmerOffline {
  final String id;
  final String tfoTimeDisplay;
//beneficiary Type
  final String tfoBeneficiaryType;

  final String tfoEnumeratorValue;

//farmer Details
  final String tfoFarmerfirstName;
  final String tfoFarmerotherName;
  final String tfoFarmersurName;
  final String tfoFarmerGender;
  final String tfoFarmerPhoneNum;
  final String tfoFarmerDoB;
  final String tfoFarmerMail;
  final String tfoFarmerPostal;
  final String tfoKinName;
  final String tfoKinRelationShip;
  final String tfoKinDoB;
  final String tfoKinGender;
  final String tfoKinPhoneNum;
  final String tfoKinPostal;
  final String tfoFarmerPic64;

  //group Details
  final String tfoGroupName;
  final String tfoGroupPresident;
  final String tfoGroupSecretary;
  final String tfoGroupphoneNumber;
  final String tfoGroupDirectors;
  final String tfoGroupEmail;
  final String tfoGroupAddress;

  // declaration Signatures - one more should be added
  final String tfoFarmerdeclarationSig;

  // connection status
  String tfoConStat;

  PersonalFarmerOffline({
    required this.id,
    this.tfoTimeDisplay = '',
    this.tfoBeneficiaryType = '',
    this.tfoEnumeratorValue = '',
    this.tfoFarmerfirstName = '',
    this.tfoFarmerotherName = '',
    this.tfoFarmersurName = '',
    this.tfoFarmerGender = '',
    this.tfoFarmerPhoneNum = '',
    this.tfoFarmerDoB = '',
    this.tfoFarmerMail = '',
    this.tfoFarmerPostal = '',
    this.tfoKinName = '',
    this.tfoKinRelationShip = '',
    this.tfoKinDoB = '',
    this.tfoKinGender = '',
    this.tfoKinPhoneNum = '',
    this.tfoKinPostal = '',
    this.tfoFarmerPic64 = '',
    this.tfoFarmerdeclarationSig = '',
    this.tfoGroupName = '',
    this.tfoGroupPresident = '',
    this.tfoGroupDirectors = '',
    this.tfoGroupSecretary = '',
    this.tfoGroupphoneNumber = '',
    this.tfoGroupEmail = '',
    this.tfoGroupAddress = '',
    this.tfoConStat = '',
  });
}

class PersonalFarmerApiList {
  final String id;
  final String tfaTimeDisplay;
//beneficiary Type
  final String tfaBeneficiaryType;

  final String tfaEnumeratorValue;

//farmer Details
  final String tfaFarmerId;
  final String tfaFarmerfirstName;
  final String tfaFarmerotherName;
  final String tfaFarmersurName;
  final String tfaFarmerGender;
  final String tfaFarmerPhoneNum;
  final String tfaFarmerDoB;
  final String tfaFarmerMail;
  final String tfaFarmerPostal;
  final String tfaKinName;
  final String tfaKinRelationShip;
  final String tfaKinDoB;
  final String tfaKinGender;
  final String tfaKinPhoneNum;
  final String tfaKinPostal;
  final String tfaFarmerPic64;

  //group Details
  final String tfaGroupName;
  final String tfaGroupPresident;
  final String tfaGroupSecretary;
  final String tfaGroupphoneNumber;
  final String tfaGroupDirectors;
  final String tfaGroupEmail;
  final String tfaGroupAddress;

  // declaration Signatures - one more should be added
  final String tfaFarmerdeclarationSig;

  // connection status
  String tfaConStat;

  PersonalFarmerApiList({
    required this.id,
    this.tfaTimeDisplay = '',
    this.tfaBeneficiaryType = '',
    this.tfaEnumeratorValue = '',
    this.tfaFarmerId = '',
    this.tfaFarmerfirstName = '',
    this.tfaFarmerotherName = '',
    this.tfaFarmersurName = '',
    this.tfaFarmerGender = '',
    this.tfaFarmerPhoneNum = '',
    this.tfaFarmerDoB = '',
    this.tfaFarmerMail = '',
    this.tfaFarmerPostal = '',
    this.tfaKinName = '',
    this.tfaKinRelationShip = '',
    this.tfaKinDoB = '',
    this.tfaKinGender = '',
    this.tfaKinPhoneNum = '',
    this.tfaKinPostal = '',
    this.tfaFarmerPic64 = '',
    this.tfaFarmerdeclarationSig = '',
    this.tfaGroupPresident = '',
    this.tfaGroupDirectors = '',
    this.tfaGroupName = '',
    this.tfaGroupSecretary = '',
    this.tfaGroupphoneNumber = '',
    this.tfaGroupEmail = '',
    this.tfaGroupAddress = '',
    this.tfaConStat = '',
  });
}

class DeforestationModel {
  final String id;
  final String timeDisplay;
  final String community;
  final String gfwDirected;
  final String seeDeforestation;
  final String deforestationCause;
  final String takeAction;
  final String actionReason;
  final String latitude;
  final String longitude;
  final String image;
  final String conStat;

  DeforestationModel({
    this.id = "",
    this.timeDisplay = "",
    this.community = "",
    this.gfwDirected = "",
    this.seeDeforestation = "",
    this.deforestationCause = "",
    this.takeAction = "",
    this.actionReason = "",
    this.latitude = "",
    this.longitude = "",
    this.image = "",
    this.conStat = "",
  });
}
