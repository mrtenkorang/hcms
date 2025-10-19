import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
     _db = await sql.openDatabase(path.join(dbPath, 'hcms_revived.db'),
        onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE forest_app(id TEXT PRIMARY KEY, timeDisplay TEXT, farmerId TEXT,'
        ' beneficiaryType TEXT, enumeratorValue TEXT,'
        ' farmerfirstName TEXT, farmerotherName TEXT, farmersurName TEXT,'
        ' farmerGender Text, farmerPhoneNum Text, farmerDoB TEXT, farmerMail TEXT, farmerPostal TEXT, kinName TEXT,'
        ' kinRelationShip TEXT, kinDoB TEXT, kinGender TEXT, kinPhoneNum TEXT, kinPostal TEXT, farmerPic64 TEXT, groupName TEXT,'
        ' groupPresident TEXT, groupSecretary TEXT, groupphoneNumber TEXT, groupDirectors TEXT, groupEmail TEXT,'
        ' groupAddress TEXT, region TEXT,'
        ' forestDistrict TEXT, mddas TEXT, mddasName TEXT, community TEXT, family TEXT, typeofEstablishment TEXT, farmID TEXT,'
        ' farmArea TEXT, pointsGet TEXT,'
        ' c2treePlantationDetail TEXT, c3treePlantationDetail TEXT, farmerdeclarationSig TEXT, witnessdeclarationSig TEXT,'
        ' witnessName TEXT, witnessPhone TEXT, conStat TEXT)',
      );
      await db.execute(
          'CREATE TABLE first_time_user(id TEXT PRIMARY KEY, firstTime TEXT, displayName TEXT, enumeratorValue TEXT, '
          'status TEXT, log TEXT, contact TEXT, password TEXT)');

      await db.execute(
        'CREATE TABLE farmer_offline(id TEXT PRIMARY KEY, foCommunity TEXT, foFarmerName TEXT, foContact TEXT, foGender TEXT, foDoB TEXT, foHolderCategory TEXT,'
        ' foFarmSize TEXT, foConStat TEXT)',
      );

      await db.execute(
        'CREATE TABLE farmer_api_list_seedling(id TEXT PRIMARY KEY, falSContact TEXT, falSFarmerName TEXT, falSCommunityName TEXT, falSCommunityId TEXT, falSBaseline TEXT,'
        ' dateCreated TEXT)',
      );
      await db.execute(
        'CREATE TABLE farmer_api_list_alternative(id TEXT PRIMARY KEY, falAFarmerName TEXT, falACommunityName TEXT, falACommunityId TEXT, falAContact TEXT, falABaseline TEXT,'
        ' dateCreated TEXT)',
      );

      await db.execute(
        'CREATE TABLE seedling_monitoring(id TEXT PRIMARY KEY, smTimeDisplay TEXT, smCommunity TEXT, smVisitDate TEXT, smEnumeratorValue TEXT, smFarmerId TEXT, smFarmerName TEXT, smBasline TEXT,'
        ' smFarmerContact TEXT, smSpecies TEXT, smReceivedDate TEXT, smPlantedDate TEXT, smQuantityReceived TEXT, smQuantityPlanted TEXT,'
        ' smQuantitySurvived TEXT, smPlantingArea TEXT, smAreaSize TEXT, smRegisteredTrees TEXT, smFarmLocation TEXT, smConStat TEXT)',
      );
      await db.execute(
        'CREATE TABLE seedling_monitoring2('
        'id TEXT PRIMARY KEY,'
        ' smTimeDisplay TEXT,'
        ' smCommunity TEXT,'
        ' smVisitDate TEXT,'
        ' smEnumeratorValue TEXT,'
        ' smBaseline TEXT,'
        ' surveyorName TEXT,'
        ' dateOfSurvey TEXT,'
        ' community TEXT,'
        ' farmerName TEXT,'
        ' farmerIDNumber TEXT,'
        ' typeOfPlantation TEXT,'
        ' totalSizeAcres TEXT,'
        ' speciesProvidedPlanted TEXT,'
        ' pr_quantityReceived TEXT,'
        ' pr_quantityPlanted TEXT,'
        ' pr_farmerdOB TEXT,'
        ' ka_quantityReceived TEXT,'
        ' ka_quantityPlanted TEXT,'
        ' ka_farmerdOB TEXT,'
        ' da_quantityReceived TEXT,'
        ' da_quantityPlanted TEXT,'
        ' da_farmerdOB TEXT,'
        ' ed_quantityReceived TEXT,'
        ' ed_quantityPlanted TEXT,'
        ' ed_farmerdOB TEXT,'
        ' em_quantityReceived TEXT,'
        ' em_quantityPlanted TEXT,'
        ' em_farmerdOB TEXT,'
        ' of_quantityReceived TEXT,'
        ' of_quantityPlanted TEXT,'
        ' of_farmerdOB TEXT,'
        ' md_quantityReceived TEXT,'
        ' md_quantityPlanted TEXT,'
        ' md_farmerdOB TEXT,'
        ' mo_quantityReceived TEXT,'
        ' mo_quantityPlanted TEXT,'
        ' mo_farmerdOB TEXT,'
        ' ok_quantityReceived TEXT,'
        ' ok_quantityPlanted TEXT,'
        ' ok_farmerdOB TEXT,'
        ' eu_quantityReceived TEXT,'
        ' eu_quantityPlanted TEXT,'
        ' eu_farmerdOB TEXT,'
        ' ba_quantityReceived TEXT,'
        ' ba_quantityPlanted TEXT,'
        ' ba_farmerdOB TEXT,'
        ' mappedFarmBoundaries TEXT,'
        ' totalSeedlingsAliveController TEXT,'
        ' speciesAlive TEXT,'
        ' reasonForDeath TEXT,'
        ' mappedSurvidedSeedlings TEXT,'
        ' sourceOfWater TEXT,'
        ' waterignFrequency TEXT,'
        ' anyExtremeSigns TEXT,'
        ' extremeWeathers TEXT,'
        ' pestsAroundYesNoValue TEXT,'
        ' pestDescription TEXT,'
        ' signsDiseaseYesNoValue TEXT,'
        ' diseaseDescription TEXT,'
        ' fertiliserAppliedYesNoValue TEXT,'
        ' fertiliserType TEXT,'
        ' pesticideHerbicideAppliedYesNoValue TEXT,'
        ' pesticideHerbicideType TEXT,'
        ' additionalObservations TEXT,'
        ' conStat TEXT)',
      );
      await db.execute(
        'CREATE TABLE lmb_monitoring(id TEXT PRIMARY KEY, lmbTimeDisplay TEXT, lmbEnumeratorValue TEXT, lmbName TEXT, lmbSector TEXT, lmbPrivateName TEXT, lmbFirstEngagement TEXT, lmbPartnershipType TEXT, lmbPartnershipDuration TEXT,'
        ' lmbMou TEXT, lmbFinancialName TEXT, lmbTypeLoanService TEXT, lmbLoanDuration TEXT,'
        ' lmbLoanInterest TEXT, lmbFemaleBenefit TEXT, lmbMaleBenefit TEXT, lmbYouthBenefit TEXT, lmbConStat TEXT)',
      );
      await db.execute(
        'CREATE TABLE alternative_livelihood(id TEXT PRIMARY KEY, alTimeDisplay TEXT, alCommunity TEXT, alEnumeratorValue TEXT, alVisitDate TEXT, alFarmerId TEXT, alFarmerName TEXT, alBasline TEXT,'
        ' alFarmerContact TEXT, alAdditionalActivity TEXT, alTrainerOrg TEXT, alOperationsStartDate TEXT, alInitialAmount TEXT, alAmountType TEXT,'
        ' alAmount TEXT, alAmountToLMB TEXT, alActivitySupported TEXT, alConStat TEXT)',
      );
      await db.execute(
        'CREATE TABLE training_log(id TEXT PRIMARY KEY, tlTimeDisplay TEXT, tlCommunityName TEXT, tlTopic TEXT, tlEventDate TEXT, tlDuration TEXT, tlTrainerName TEXT,'
        ' tlTrainerOrg TEXT, tlEnumeratorValue TEXT, tlParticipantDetails TEXT, tlConStat TEXT)',
      );
      await db.execute(
        'CREATE TABLE news_and_articles(id TEXT PRIMARY KEY, naTimeDisplay TEXT, naTitle TEXT, naContent TEXT)',
      );
      await db.execute(
        'CREATE TABLE workshops(id TEXT PRIMARY KEY, wsTimeDisplay TEXT, wsTitle TEXT, wsContent TEXT)',
      );

      await db.execute(
        'CREATE TABLE tree_farmer_offline(id TEXT PRIMARY KEY, tfoTimeDisplay TEXT, tfoFarmerID TEXT, tfoBeneficiaryType TEXT, tfoEnumeratorValue TEXT,'
        ' tfoFarmerfirstName TEXT, tfoFarmerotherName TEXT, tfoFarmersurName TEXT,'
        ' tfoFarmerGender Text, tfoFarmerPhoneNum Text, tfoFarmerDoB TEXT, tfoFarmerMail TEXT, tfoFarmerPostal TEXT, tfoKinName TEXT,'
        ' tfoKinRelationShip TEXT, tfoKinDoB TEXT, tfoKinGender TEXT, tfoKinPhoneNum TEXT, tfoKinPostal TEXT, tfoFarmerPic64 TEXT, tfoGroupName TEXT,'
        ' tfoGroupPresident TEXT, tfoGroupSecretary TEXT, tfoGroupphoneNumber TEXT, tfoGroupDirectors TEXT, tfoGroupEmail TEXT,'
        ' tfoGroupAddress TEXT, tfoFarmerdeclarationSig, tfoConStat TEXT)',
      );
      await db.execute(
        'CREATE TABLE tree_farmer_api_list(id TEXT PRIMARY KEY, tfaTimeDisplay TEXT, tfaFarmerID TEXT, tfaBeneficiaryType TEXT, tfaEnumeratorValue TEXT,'
        ' tfaFarmerfirstName TEXT, tfaFarmerotherName TEXT, tfaFarmersurName TEXT,'
        ' tfaFarmerGender Text, tfaFarmerPhoneNum Text, tfaFarmerDoB TEXT, tfaFarmerMail TEXT, tfaFarmerPostal TEXT, tfaKinName TEXT,'
        ' tfaKinRelationShip TEXT, tfaKinDoB TEXT, tfaKinGender TEXT, tfaKinPhoneNum TEXT, tfaKinPostal TEXT, tfaFarmerPic64 TEXT, tfaGroupName TEXT,'
        ' tfaGroupPresident TEXT, tfaGroupSecretary TEXT, tfaGroupphoneNumber TEXT, tfaGroupDirectors TEXT, tfaGroupEmail TEXT,'
        ' tfaGroupAddress TEXT, tfaFarmerdeclarationSig, tfaConStat TEXT)',
      );
      await db.execute(
        'CREATE TABLE deforestation(id TEXT PRIMARY KEY, timeDisplay TEXT,'
        ' community TEXT, gfwDirected TEXT, seeDeforestation TEXT,'
        ' deforestationCause TEXT, takeAction TEXT, actionReason TEXT,'
        ' latitude TEXT, longitude TEXT, image TEXT, conStat TEXT)',
      );


      await db.execute('''
      CREATE TABLE seedling_monitorings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        surveyor_name TEXT,
        date_of_survey TEXT,
        community TEXT,
        farmer_name TEXT,
        farmer_id_number TEXT,
        community_notfound INTEGER DEFAULT 0,
        custom_community_name TEXT,
        plantation_type TEXT,
        total_size_acres REAL,
        species_provided_planted TEXT,
        mapped_farm_boundaries TEXT,
        mapped_area_hectares REAL,
        total_seedlings_alive INTEGER,
        species_alive TEXT,
        reason_for_death TEXT,
        mapped_surviving_seedlings TEXT,
        source_of_water TEXT,
        watering_frequency TEXT,
        has_extreme_weather INTEGER DEFAULT 0,
        extreme_weathers TEXT,
        other_extreme_weather TEXT,
        pests_around INTEGER DEFAULT 0,
        pest_description TEXT,
        signs_of_disease INTEGER DEFAULT 0,
        disease_description TEXT,
        fertiliser_applied INTEGER DEFAULT 0,
        fertiliser_type TEXT,
        pesticide_applied INTEGER DEFAULT 0,
        pesticide_type TEXT,
        additional_observations TEXT,
        farmer_contact TEXT,
        enumerator_value TEXT,
        submission_status TEXT DEFAULT 'draft',
        connection_status TEXT DEFAULT 'not_connected',
        created_at TEXT,
        updated_at TEXT
      )
    ''');

      // Species planting details table
      await db.execute('''
      CREATE TABLE species_planting_details(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        monitoring_id INTEGER,
        species TEXT,
        quantity_received INTEGER,
        quantity_planted INTEGER,
        date_of_planting TEXT,
        FOREIGN KEY (monitoring_id) REFERENCES seedling_monitorings (id) ON DELETE CASCADE
      )
    ''');
    }, version: 1);

    return _db!;
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> fetchData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<List<Map<String, dynamic>>> fetchData2(
      String table, field) async {
    final db = await DBHelper.database();
    return db.query(table, groupBy: "$field");
  }

  static Future<List<Map<String, dynamic>>> fetchDataWhere(
      String table, fieldname, id) async {
    final db = await DBHelper.database();
    return db.query(table, where: "$fieldname = ?", whereArgs: [id]);
  }

  static delete(String id) async {
    final db = await DBHelper.database();
    db.delete('forest_app', where: 'ID = ?', whereArgs: [id]);
  }

  static deleteMV(String tableName, String id) async {
    final db = await DBHelper.database();
    db.delete(tableName, where: 'ID = ?', whereArgs: [id]);
  }

  static deleteLFD(String tableName, String contact) async {
    final db = await DBHelper.database();
    db.delete(tableName, where: 'foContact = ?', whereArgs: [contact]);
  }

  // static Future<void> update(String ft, String dn, String ev, String st) async {
  //   final db = await DBHelper.database();
  //   await db.rawUpdate(
  //       'UPDATE first_time_user SET firstTime = ?, displayName = ?, enumeratorValue = ?  WHERE id = ?',
  //       ['$ft', '$dn', '$ev', '$st']);
  // }

  static Future<void> updateLog(String logStat, String id) async {
    final db = await DBHelper.database();
    await db.rawUpdate(
        'UPDATE first_time_user SET log = ? WHERE id = ?', [logStat, id]);
  }

  // static Future<void> updateFarmerApiList(String logStat, String id) async {
  //   final db = await DBHelper.database();

  //   await db.rawInsert("INSERT IGNORE INTO farmer_api_list ");
  //   await db.rawUpdate(
  //       'UPDATE farmer_api_list SET log = ? WHERE id = ?', ['$logStat', '$id']);
  // }

  static Future<void> updateFarmerApiList(
      String table, Map<String, Object> data) async {
    final db = await DBHelper.database();

    // await db.rawInsert("INSERT IGNORE INTO farmer_api_list ");
    // await db.rawUpdate(
    //     'UPDATE farmer_api_list SET log = ? WHERE id = ?', ['$logStat', '$id']);
    db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.ignore);
  }

  static Future<void> update(String xx, String id) async {
    final db = await DBHelper.database();
    await db.rawUpdate(
        'UPDATE forest_app SET conStat = ? WHERE id = ?', [xx, id]);
  }

  static Future<void> updateMView(
      String tableName, String conName, String newCon, String id) async {
    final db = await DBHelper.database();
    await db.rawUpdate(
        'UPDATE $tableName SET $conName = ? WHERE id = ?', [newCon, id]);
  }

  static Future<void> updateGroupBeforeSend(
      String groupname,
      String grouppresident,
      String groupsecretary,
      String groupPhone,
      String groupdirectors,
      String groupemail,
      String groupaddress,
      String region,
      String forestDistrict,
      String mddas,
      String mddasName,
      String community,
      String family,
      String typeofEstablishment,
      String farmID,
      String farmArea,
      String pointsGet,
      String c2treePlantationDetail,
      String c3treePlantationDetail,
      String farmerdeclarationSig,
      String witnessdeclarationSig,
      String witnessName,
      String witnessPhone,
      String conStat,
      String id) async {
    final db = await DBHelper.database();
    await db.rawUpdate(
        'UPDATE forest_app SET groupName = ?, groupPresident = ?,'
        ' groupSecretary = ?, groupphoneNumber = ?, groupDirectors = ?,'
        ' groupEmail = ?, groupAddress = ?, region = ?,'
        ' forestDistrict = ?, mddas = ?, mddasName = ?, community = ?,'
        ' family = ?, typeofEstablishment = ?, farmID = ?, farmArea = ?, pointsGet = ?,'
        ' c2treePlantationDetail = ?, c3treePlantationDetail = ?,'
        ' farmerdeclarationSig = ?, witnessdeclarationSig = ?,'
        ' witnessName = ?, witnessPhone = ?, conStat = ? WHERE id = ?',
        [
          groupname,
          grouppresident,
          groupsecretary,
          groupPhone,
          groupdirectors,
          groupemail,
          groupaddress,
          region,
          forestDistrict,
          mddas,
          mddasName,
          community,
          family,
          typeofEstablishment,
          farmID,
          farmArea,
          pointsGet,
          c2treePlantationDetail,
          c3treePlantationDetail,
          farmerdeclarationSig,
          witnessdeclarationSig,
          witnessName,
          witnessPhone,
          conStat,
          id
        ]);
  }

  static Future<void> updateIndBeforeSend(
      String farmerfirstName,
      String farmerotherName,
      String farmersurName,
      String farmerGender,
      String farmerPhoneNum,
      String farmerDoB,
      String farmerMail,
      String farmerPostal,
      String kinName,
      String kinRelationShip,
      String kinDoB,
      String kinGender,
      String kinPhoneNum,
      String kinPostal,
      String farmerPic64,
      String region,
      String forestDistrict,
      String mddas,
      String mddasName,
      String community,
      String family,
      String typeofEstablishment,
      String farmID,
      String farmArea,
      String pointsGet,
      String c2treePlantationDetail,
      String c3treePlantationDetail,
      String farmerdeclarationSig,
      String witnessdeclarationSig,
      String witnessName,
      String witnessPhone,
      String conStat,
      String id) async {
    final db = await DBHelper.database();
    await db.rawUpdate(
        'UPDATE forest_app SET farmerfirstName = ?, farmerotherName = ?, farmersurName = ?,'
        ' farmerGender = ?, farmerPhoneNum = ?, farmerDoB = ?, farmerMail = ?,'
        ' farmerPostal = ?, kinName = ?,'
        ' kinRelationShip = ?, kinDoB = ?, kinGender = ?, kinPhoneNum = ?,'
        ' kinPostal = ?, farmerPic64 = ?, region = ?,'
        ' forestDistrict = ?, mddas = ?, mddasName = ?, community = ?,'
        ' family = ?, typeofEstablishment = ?, farmID = ?, farmArea = ?, pointsGet = ?,'
        ' c2treePlantationDetail = ?, c3treePlantationDetail = ?,'
        ' farmerdeclarationSig = ?, witnessdeclarationSig = ?,'
        ' witnessName = ?, witnessPhone = ?, conStat = ? WHERE id = ?',
        [
          farmerfirstName,
          farmerotherName,
          farmersurName,
          farmerGender,
          farmerPhoneNum,
          farmerDoB,
          farmerMail,
          farmerPostal,
          kinName,
          kinRelationShip,
          kinDoB,
          kinGender,
          kinPhoneNum,
          kinPostal,
          farmerPic64,
          region,
          forestDistrict,
          mddas,
          mddasName,
          community,
          family,
          typeofEstablishment,
          farmID,
          farmArea,
          pointsGet,
          c2treePlantationDetail,
          c3treePlantationDetail,
          farmerdeclarationSig,
          witnessdeclarationSig,
          witnessName,
          witnessPhone,
          conStat,
          id
        ]);
  }

  // /// Insert list of maps into [table] in chunked transactions to avoid locks.
  // /// `records` should already be serializable map values.
  // static Future<int> insertRecords(
  //     String table, List<Map<String, dynamic>> records,
  //     {int chunkSize = 200}) async {
  //   if (records.isEmpty) return 0;
  //   final db = await dbInstance();
  //   int inserted = 0;
  //   await db.transaction((txn) async {
  //     for (int i = 0; i < records.length; i += chunkSize) {
  //       final chunk = records.skip(i).take(chunkSize);
  //       final batch = txn.batch();
  //       for (final r in chunk)
  //         batch.insert(table, r, conflictAlgorithm: ConflictAlgorithm.ignore);
  //       await batch.commit(noResult: true);
  //       inserted += chunk.length;
  //     }
  //   });
  //   return inserted;
  // }

  // /// Get the current count of rows for a table
  // static Future<int> getCount(String table) async {
  //   final db = await DBHelper.database();
  //   final row = await db.rawQuery('SELECT COUNT(*) as c FROM $table');
  //   return sql.Sqflite.firstIntValue(row) ?? 0;
  // }

  // static Future<void> close() async {
  //   if (db != null) {
  //     await db!.close();
  //     _db = null;
  //   }
  // }
}
