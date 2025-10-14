class DeclarationDetials {
  String? signature;
  WitnessDetails? witness;

  DeclarationDetials({
    this.signature,
    this.witness,
  });

  Map<String, dynamic> toDeclarationJson() => {
        "signatureOrThumbprintBase64String": signature,
        "witness": witness,
      };
}

class WitnessDetails {
  String? witnessDate;
  String? witnessName;
  String? witnessPhoneNumber;
  String? witnessSignature;

  WitnessDetails({
    this.witnessDate,
    this.witnessName,
    this.witnessPhoneNumber,
    this.witnessSignature,
  });

  Map<String, dynamic> toWitnessJson() => {
        "date": witnessDate,
        "name": witnessName,
        "phoneNumber": witnessPhoneNumber,
        "witnessSignatureOrThumbprintBase64String": witnessSignature,
      };
}
