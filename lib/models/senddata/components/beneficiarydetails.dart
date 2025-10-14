class BeneficiaryDetails {
  String? dateofbirth;
  String? firstName;
  String? otherNames;
  String? surName;
  String? gender;
  String? passportImage;
  String? beneficiaryType;
  String? phoneNumber;
  String? postalAddress;
  String? email;
  Kin? nextofKin;

  BeneficiaryDetails({
    this.dateofbirth,
    this.firstName,
    this.otherNames,
    this.surName,
    this.gender,
    this.passportImage,
    this.beneficiaryType,
    this.phoneNumber,
    this.postalAddress,
    this.email,
    this.nextofKin,
  });

  Map<String, dynamic> tobeneficiaryJson() => {
        "dateOfBirth": dateofbirth,
        "firstName": firstName,
        "otherNames": otherNames,
        "surname": surName,
        "gender": gender,
        "passportImageBase64String": passportImage,
        "beneficiaryType": beneficiaryType,
        "phoneNumber": phoneNumber,
        "address": postalAddress,
        "email": email,
        "nextOfKin": nextofKin,
      };
}

class Kin {
  String? kinDateofbirth;
  String? kinGender;
  String? kinName;
  String? kinPhoneNumber;
  String? kinRelationship;
  String? kinPostalAddress;

  Kin({
    this.kinDateofbirth,
    this.kinGender,
    this.kinName,
    this.kinPhoneNumber,
    this.kinRelationship,
    this.kinPostalAddress,
  });

  Map<String, dynamic> toKinJson() => {
        "dateOfBirth": kinDateofbirth,
        "gender": kinGender,
        "name": kinName,
        "phoneNumber": kinPhoneNumber,
        "relationship": kinRelationship,
      };
}
