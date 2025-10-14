import 'dart:convert';

class ParticipantsModelArray {
  String? farmerid;
  String? farmerName;
  String? communityName;
  String? gender;
  String? phoneNumber;
  // String sigThumb;

  ParticipantsModelArray({
    this.farmerid,
    this.farmerName,
    this.communityName,
    this.gender,
    this.phoneNumber,
    // this.sigThumb,
  });

  Map<String, dynamic> toFarmInformationArrayJson() => {
        'farmerid': farmerid,
        "name": farmerName,
        "community": communityName,
        "gender": gender,
        "phoneNumber": phoneNumber,
        // "signatureOrThumbprintBase64String": sigThumb,
      };

  factory ParticipantsModelArray.fromJson(Map<String, dynamic> jsonData) {
    return ParticipantsModelArray(
      farmerid: jsonData['farmerid'],
      farmerName: jsonData['name'],
      communityName: jsonData['community'],
      gender: jsonData['gender'],
      phoneNumber: jsonData['phoneNumber'],
    );
    // sigThumb: jsonData['signatureOrThumbprintBase64String']);
  }

  static Map<String, dynamic> toMap(ParticipantsModelArray participantInfo) => {
        'farmerid': participantInfo.farmerid,
        // 'name': participantInfo.farmerName,
        // "community": participantInfo.communityName,
        // "gender": participantInfo.gender,
        // "phoneNumber": participantInfo.phoneNumber,
        // "signatureOrThumbprintBase64String": participantInfo.sigThumb
      };

  static String encode(List<ParticipantsModelArray> participantInfos) =>
      json.encode(
        participantInfos
            .map<Map<String, dynamic>>((participantInfo) =>
                ParticipantsModelArray.toMap(participantInfo))
            .toList(),
      );

  static List<ParticipantsModelArray> decode(String participantInfos) =>
      (json.decode(participantInfos) as List<dynamic>)
          .map<ParticipantsModelArray>((participantItem) =>
              ParticipantsModelArray.fromJson(participantItem))
          .toList();

  @override
  String toString() {
    return '{"farmerid": $farmerid}';
    // return '{"name": $farmerName, "community": '
    //     '$communityName, "gender": "$gender", "phoneNumber": $phoneNumber, "signatureOrThumbprintBase64String": $sigThumb}';
  }
}
