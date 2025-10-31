import 'dart:convert';

import 'package:hcms_revived2/controller/models/communinty_model.dart';
import 'package:hcms_revived2/controller/models/deforestation_model.dart';
import 'package:hcms_revived2/controller/models/district_region_model.dart';
import 'package:hcms_revived2/controller/models/establishment_type_model.dart';
import 'package:hcms_revived2/controller/models/farmer_from_server.dart';
import 'package:hcms_revived2/controller/models/farmer_local_model.dart';
import 'package:hcms_revived2/controller/models/mmda_model.dart';
import 'package:hcms_revived2/controller/models/ta_stool_skin_family%20model.dart';
import 'package:hcms_revived2/controller/models/training_log_model.dart';
import 'package:hcms_revived2/controller/models/tree_registration_model.dart';
import 'package:hcms_revived2/models/localdbmodel/seedling_monitoring_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;

class AppDatabaseHelper {
  static final AppDatabaseHelper _instance = AppDatabaseHelper._internal();
  Database? _database;

  AppDatabaseHelper._internal();

  factory AppDatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'farmers_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  final String farmersFromServerTable = "farmers_from_server_tbl";
  // final String regionTable = "region_table_tbl";
  final String districtTable = "district_region_table_tbl";
  final String taStoolSkinFamilyTable = "ta_family_tbl";
  final String communityTable = "community_tbl";
  final String mmdasTable = "mmdas_table";
  final String seedlingMonitoringTable = "seedling_monitoring_tbl";
  final String estaTypeTable = "esta_type_table";
  static const String treeRegistrationTable = 'tree_registration_table';
  static const String treesTable = 'trees_table';
  static const String localFarmerTable = 'local_farmer_table';
  static const String trainingLogTable = 'training_logs_tbl';
  static const String deforestationReportsTAble = 'deforestation_reports_tbl';

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $farmersFromServerTable (
        id INTEGER PRIMARY KEY,
        landscape TEXT NOT NULL,
        community INTEGER NOT NULL,
        farmercode TEXT NOT NULL,
        farmer_name TEXT NOT NULL,
        contact TEXT NOT NULL,
        nationalid_type TEXT NOT NULL,
        nationalid TEXT NOT NULL,
        membership_ra INTEGER NOT NULL,
        cocoa_card TEXT NOT NULL,
        photo TEXT NOT NULL,
        gender TEXT NOT NULL,
        dob TEXT NOT NULL,
        age INTEGER NOT NULL,
        small_holder_category TEXT NOT NULL,
        farm_size REAL NOT NULL,
        created_date TEXT NOT NULL,
        community_name TEXT NOT NULL,
        community_id INTEGER NOT NULL,
        community_lat REAL,
        community_long REAL,
        community_elevation REAL,
        district_name TEXT NOT NULL,
        district_id INTEGER NOT NULL,
        district_code TEXT NOT NULL,
        district_pilot INTEGER NOT NULL,
        region_name TEXT NOT NULL,
        region_id INTEGER NOT NULL,
        region_code TEXT NOT NULL,
        region_pilot INTEGER NOT NULL
      )
    ''');

    // Trees Table
    await db.execute('''
      CREATE TABLE $treesTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tree_registration_id INTEGER,
        tree_name TEXT,
        pn TEXT,
        species TEXT,
        size TEXT,
        yo_establishment TEXT,
        latitude REAL,
        longitude REAL,
        altitude REAL,
        accuracy REAL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (tree_registration_id) REFERENCES $treeRegistrationTable(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE $localFarmerTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        landscape TEXT,
        community INTEGER,
        farmercode TEXT,
        farmer_name TEXT,
        contact TEXT,
        nationalid_type TEXT,
        nationalid TEXT,
        membership_ra INTEGER DEFAULT 0,
        cocoa_card TEXT,
        gender TEXT,
        dob TEXT,
        age INTEGER,
        small_holder_category TEXT,
        farm_size REAL,
        status TEXT DEFAULT 'pending',
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $treeRegistrationTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        farmer_id INTEGER,
        region_id INTEGER,
        district_id INTEGER,
        mmda_id INTEGER,
        community_id INTEGER,
        establishment_type TEXT,
        next_of_kin_name TEXT,
        farmer_relationship_with_next_of_kin TEXT,
        next_of_kin_dob TEXT,
        next_of_kin_gender TEXT,
        next_of_kin_phone_number TEXT,
        next_of_kin_postal_address TEXT,
        farm_boundary_polygon BLOB,
        farm_size REAL,
        group_name TEXT,
        group_president TEXT,
        group_secretary TEXT,
        company_directors TEXT,
        group_phone_number TEXT,
        group_email TEXT,
        group_postal_address TEXT,
        group_reg_numb TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
        is_synced INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE $trainingLogTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        community_id INTEGER NOT NULL,
        community_name TEXT NOT NULL,
        training_topic TEXT NOT NULL,
        event_date TEXT NOT NULL,
        event_duration TEXT NOT NULL,
        trainer_name TEXT NOT NULL,
        trainer_organisation TEXT NOT NULL,
        enumerator_id INTEGER NOT NULL,
        participants TEXT NOT NULL,
        created_at TEXT,
        updated_at TEXT,
        is_synced INTEGER DEFAULT 0
      )
    ''');

    // Create indexes for better performance
    // await db.execute('CREATE INDEX idx_farmers_contact ON farmers(contact)');
    // await db.execute(
    //   'CREATE INDEX idx_farmers_community ON farmers(community_name)',
    // );
    // await db.execute('CREATE INDEX idx_farmers_name ON farmers(farmer_name)');

    // await db.execute('''
    //   CREATE TABLE $regionTable(
    //     id INTEGER PRIMARY KEY,
    //     region TEXT NOT NULL,
    //     created_at INTEGER DEFAULT (strftime('%s', 'now'))
    //   )
    // ''');

    // Create districts table
    await db.execute('''
      CREATE TABLE $districtTable(
        id INTEGER PRIMARY KEY,
        region_name TEXT NOT NULL,
        district_name TEXT NOT NULL,
        district_id INTEGER NOT NULL,
        region_id TEXT NOT NULL
      )
    ''');

    // Create indexes
    // await db.execute('CREATE INDEX idx_regions_name ON $regionTable(region)');
    // await db.execute(
    //   'CREATE INDEX idx_districts_name ON districts(district)',
    // );
    // await db.execute(
    //   'CREATE INDEX idx_districts_region ON districts(id)',
    // );

    await db.execute('''
    CREATE TABLE $taStoolSkinFamilyTable(
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      created_at INTEGER DEFAULT (strftime('%s', 'now'))
    )
  ''');

    // await db.execute('CREATE INDEX idx_types ON $taStoolSkinFamilyTable(name)');

    await db.execute('''
    CREATE TABLE $communityTable(
      id INTEGER PRIMARY KEY,
      community TEXT NOT NULL,
      district INTEGER NOT NULL,
      created_at INTEGER DEFAULT (strftime('%s', 'now'))
    )
  ''');

    await db.execute('''
          CREATE TABLE $deforestationReportsTAble (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            community TEXT,
            directed_by_gfw TEXT,
            do_u_see_deforestation TEXT,
            cause_deforestation TEXT,
            further_action_taken TEXT,
            reason_further_action_taken TEXT,
            latitude REAL,
            longitude REAL,
            photos TEXT,
            submission_status TEXT,
            created_at TEXT,
            updated_at TEXT
          )
        ''');

    await db.execute('''
    CREATE TABLE $mmdasTable(
      id INTEGER PRIMARY KEY,
      mmda TEXT NOT NULL,
      created_at INTEGER DEFAULT (strftime('%s', 'now'))
    )
  ''');

    await db.execute('''
      CREATE TABLE $seedlingMonitoringTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        -- General Information
        surveyor_name TEXT,
        date_of_survey TEXT,
        community TEXT,
        farmer_name TEXT,
        farmer_id_number TEXT,
        community_not_found INTEGER DEFAULT 0,
        custom_community_name TEXT,
        
        -- Plantation Details
        plantation_type TEXT,
        total_size_acres REAL,
        species_provided_planted TEXT, -- JSON array
        
        -- Species Planting Details (stored as JSON)
        species_planting_details TEXT,
        
        -- Mapped Area
        mapped_farm_boundaries TEXT,
        mapped_area_hectares REAL,
        
        -- Seedling Survival
        total_seedlings_alive INTEGER,
        species_alive TEXT, -- JSON array
        reason_for_death TEXT, -- JSON array
        mapped_surviving_seedlings TEXT, -- JSON array of trees
        
        -- Environmental Conditions
        source_of_water TEXT, -- JSON array
        watering_frequency TEXT,
        has_extreme_weather INTEGER,
        extreme_weathers TEXT, -- JSON array
        other_extreme_weather TEXT,
        
        -- Final Observations
        pests_around INTEGER,
        pest_description TEXT,
        signs_of_disease INTEGER,
        disease_description TEXT,
        fertiliser_applied INTEGER,
        fertiliser_type TEXT,
        pesticide_applied INTEGER,
        pesticide_type TEXT,
        additional_observations TEXT,
        
        -- Metadata
        farmer_contact TEXT,
        enumerator_value TEXT,
        created_at TEXT,
        submission_status TEXT DEFAULT 'draft',
        connection_status TEXT DEFAULT 'not connected',
        
        -- Timestamps
        updated_at INTEGER DEFAULT (strftime('%s', 'now'))
      )
    ''');

    await db.execute('''
    CREATE TABLE $estaTypeTable(
      id INTEGER PRIMARY KEY,
      esta_type TEXT NOT NULL,
      created_at INTEGER DEFAULT (strftime('%s', 'now'))
    )
  ''');

    await db.execute(
      'CREATE INDEX idx_esta_types ON $estaTypeTable(esta_type)',
    );

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
      'status TEXT, log TEXT, contact TEXT, password TEXT)',
    );

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
  }

  // Bulk insert
  Future<void> bulkInsertEstaTypes(List<EstaTypeModel> estaTypes) async {
    if (estaTypes.isEmpty) return;

    final db = await database;

    await db.transaction((txn) async {
      final batch = txn.batch();

      for (var estaType in estaTypes) {
        batch.insert(estaTypeTable, {
          'id': estaType.id,
          'esta_type': estaType.esta_type,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }

      await batch.commit();
    });
  }

  // Get all $estaTypeTable
  Future<List<EstaTypeModel>> getAllEstaTypes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      estaTypeTable,
      orderBy: 'esta_type ASC',
    );
    return maps
        .map(
          (map) => EstaTypeModel(
            id: map['id'] as int?,
            esta_type: map['esta_type']?.toString(),
          ),
        )
        .toList();
  }

  // Delete all $estaTypeTable
  Future<void> deleteAllEstaTypes() async {
    final db = await database;
    await db.delete(estaTypeTable);
  }

  // Bulk insert
  Future<void> bulkInsertCommunities(List<CommunityModel> communities) async {
    if (communities.isEmpty) return;

    final db = await database;

    await db.transaction((txn) async {
      final batch = txn.batch();

      for (var community in communities) {
        batch.insert(communityTable, {
          'id': community.id,
          'community': community.community,
          'district': community.district,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }

      await batch.commit();
    });
  }

  // Get all communities
  Future<List<CommunityModel>> getAllCommunities() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      communityTable,
      orderBy: 'community ASC',
    );
    return maps
        .map(
          (map) => CommunityModel(
            id: map['id'] as int?,
            community: map['community']?.toString(),
          ),
        )
        .toList();
  }

  // Delete all communities
  Future<void> deleteAllCommunities() async {
    final db = await database;
    await db.delete(communityTable);
  }

  // Bulk insert
  Future<void> bulkInsertTypes(List<TAStoolSkinFamilyModel> types) async {
    if (types.isEmpty) return;

    final db = await database;

    await db.transaction((txn) async {
      final batch = txn.batch();

      for (var name in types) {
        batch.insert(taStoolSkinFamilyTable, {
          'id': name.id,
          'name': name.name,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }

      await batch.commit();
    });
  }

  // Get all types
  Future<List<TAStoolSkinFamilyModel>> getAllTypes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      taStoolSkinFamilyTable,
      orderBy: 'name ASC',
    );
    return maps
        .map(
          (map) => TAStoolSkinFamilyModel(
            id: map['id'] as int?,
            name: map['name']?.toString(),
          ),
        )
        .toList();
  }

  // Delete all types
  Future<void> deleteAllTypes() async {
    final db = await database;
    await db.delete(taStoolSkinFamilyTable);
  }

  // CREATE - Insert a new farmer
  Future<int> insertFarmer(FarmerFromServerModel farmer) async {
    final db = await database;

    // Check if farmer already exists
    final existingFarmer = await getFarmerById(farmer.id.toString());
    if (existingFarmer != null) {
      return await updateFarmer(farmer);
    }

    return await db.insert(
      farmersFromServerTable,
      _farmerToMap(farmer),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // CREATE - Insert multiple farmers
  Future<void> insertFarmers(List<FarmerFromServerModel> farmers) async {
    final db = await database;
    final batch = db.batch();

    for (var farmer in farmers) {
      batch.insert(
        farmersFromServerTable,
        _farmerToMap(farmer),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit();
  }

  // READ - Get all farmers
  Future<List<FarmerFromServerModel>> getAllFarmers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      farmersFromServerTable,
      orderBy: 'farmer_name ASC',
    );
    return List.generate(maps.length, (i) => _mapToFarmer(maps[i]));
  }

  // READ - Get farmer by ID
  Future<FarmerFromServerModel?> getFarmerById(String? id) async {
    if (id == null) return null;

    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      farmersFromServerTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return _mapToFarmer(maps.first);
    }
    return null;
  }

  // READ - Get farmers by contact number
  Future<List<FarmerFromServerModel>> getFarmersByContact(
    String contact,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      farmersFromServerTable,
      where: 'contact LIKE ?',
      whereArgs: ['%$contact%'],
      orderBy: 'farmer_name ASC',
    );
    return List.generate(maps.length, (i) => _mapToFarmer(maps[i]));
  }

  // READ - Get farmers by community
  Future<List<FarmerFromServerModel>> getFarmersByCommunity(
    String community,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      farmersFromServerTable,
      where: 'community_name LIKE ?',
      whereArgs: ['%$community%'],
      orderBy: 'farmer_name ASC',
    );
    return List.generate(maps.length, (i) => _mapToFarmer(maps[i]));
  }

  // READ - Search farmers by name, contact, or community
  Future<List<FarmerFromServerModel>> searchFarmers(String query) async {
    if (query.isEmpty) return getAllFarmers();

    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      farmersFromServerTable,
      where: 'farmer_name LIKE ? OR contact LIKE ? OR community_name LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'farmer_name ASC',
    );
    return List.generate(maps.length, (i) => _mapToFarmer(maps[i]));
  }

  // READ - Get farmers with pagination
  Future<List<FarmerFromServerModel>> getFarmersPaginated({
    required int limit,
    required int offset,
    String? searchQuery,
  }) async {
    final db = await database;

    if (searchQuery != null && searchQuery.isNotEmpty) {
      final List<Map<String, dynamic>> maps = await db.query(
        farmersFromServerTable,
        where: 'farmer_name LIKE ? OR contact LIKE ? OR community_name LIKE ?',
        whereArgs: ['%$searchQuery%', '%$searchQuery%', '%$searchQuery%'],
        orderBy: 'farmer_name ASC',
        limit: limit,
        offset: offset,
      );
      return List.generate(maps.length, (i) => _mapToFarmer(maps[i]));
    } else {
      final List<Map<String, dynamic>> maps = await db.query(
        farmersFromServerTable,
        orderBy: 'farmer_name ASC',
        limit: limit,
        offset: offset,
      );
      return List.generate(maps.length, (i) => _mapToFarmer(maps[i]));
    }
  }

  // READ - Get total count of farmers
  Future<int> getFarmersCount({String? searchQuery}) async {
    final db = await database;

    if (searchQuery != null && searchQuery.isNotEmpty) {
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM farmers WHERE farmer_name LIKE ? OR contact LIKE ? OR community_name LIKE ?',
        ['%$searchQuery%', '%$searchQuery%', '%$searchQuery%'],
      );
      return result.first['count'] as int;
    } else {
      final result = await db.rawQuery('SELECT COUNT(*) as count FROM farmers');
      return result.first['count'] as int;
    }
  }

  // UPDATE - Update a farmer
  Future<int> updateFarmer(FarmerFromServerModel farmer) async {
    final db = await database;
    return await db.update(
      farmersFromServerTable,
      _farmerToMap(farmer),
      where: 'id = ?',
      whereArgs: [farmer.id],
    );
  }

  // UPDATE - Update specific fields of a farmer
  Future<int> updateFarmerFields({
    required String id,
    required Map<String, dynamic> fields,
  }) async {
    final db = await database;

    // Add updated_at timestamp
    final updatedFields = Map<String, dynamic>.from(fields);
    updatedFields['updated_at'] = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    return await db.update(
      farmersFromServerTable,
      updatedFields,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE - Delete a farmer by ID
  Future<int> deleteFarmer(String id) async {
    final db = await database;
    return await db.delete(
      farmersFromServerTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE - Delete all farmers
  Future<int> deleteAllFarmers() async {
    final db = await database;
    return await db.delete(farmersFromServerTable);
  }

  // DELETE - Delete farmers by community
  Future<int> deleteFarmersByCommunity(String communityId) async {
    final db = await database;
    return await db.delete(
      farmersFromServerTable,
      where: 'community_id = ?',
      whereArgs: [communityId],
    );
  }

  // Check if farmer exists
  Future<bool> farmerExists(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      farmersFromServerTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty;
  }

  // Get database statistics
  Future<Map<String, dynamic>> getDatabaseStats() async {
    final db = await database;

    final totalFarmers = await getFarmersCount();
    final communitiesResult = await db.rawQuery(
      'SELECT COUNT(DISTINCT community_id) as unique_communities FROM farmers',
    );
    final latestUpdateResult = await db.rawQuery(
      'SELECT MAX(updated_at) as last_updated FROM farmers',
    );

    return {
      'total_farmers': totalFarmers,
      'unique_communities':
          communitiesResult.first['unique_communities'] as int? ?? 0,
      'last_updated': latestUpdateResult.first['last_updated'] as int? ?? 0,
    };
  }

  // Helper method to convert FarmerFromServerModel to Map
  Map<String, dynamic> _farmerToMap(FarmerFromServerModel farmer) {
    return {
      'id': farmer.id,
      'farmer_name': farmer.farmerName,
      'community_name': farmer.communityName,
      'community_id': farmer.communityId,
      'contact': farmer.contact,
      'updated_at': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    };
  }

  // Helper method to convert Map to FarmerFromServerModel
  FarmerFromServerModel _mapToFarmer(Map<String, dynamic> map) {
    return FarmerFromServerModel(
      id: map['id'] ?? 0,
      landscape: map['landscape'] ?? '',
      community: map['community'] ?? 0,
      farmercode: map['farmercode'] ?? '',
      farmerName: map['farmer_name'] ?? '',
      contact: map['contact'] ?? '',
      nationalidType: map['nationalid_type'] ?? '',
      nationalid: map['nationalid'] ?? '',
      membershipRa: map['membership_ra'] == 1 ? true : false,
      cocoaCard: map['cocoa_card'] ?? '',
      photo: map['photo'] ?? '',
      gender: map['gender'] ?? '',
      dob: map['dob'] ?? '',
      age: map['age'] ?? 0,
      smallHolderCategory: map['small_holder_category'] ?? '',
      farmSize: (map['farm_size'] ?? 0.0).toDouble(),
      createdDate: map['created_date'] ?? '',
      communityName: map['community_name'] ?? '',
      communityId: map['community_id'] ?? 0,
      communityLat: map['community_lat']?.toDouble(),
      communityLong: map['community_long']?.toDouble(),
      communityElevation: map['community_elevation']?.toDouble(),
      districtName: map['district_name'] ?? '',
      districtId: map['district_id'] ?? 0,
      districtCode: map['district_code'] ?? '',
      districtPilot: map['district_pilot'] == 1 ? true : false,
      regionName: map['region_name'] ?? '',
      regionId: map['region_id'] ?? 0,
      regionCode: map['region_code'] ?? '',
      regionPilot: map['region_pilot'] == 1 ? true : false,
    );
  }

  // Close the database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  // Bulk insert method with transaction and batch operations for optimal performance
  Future<void> bulkInsertFarmers(
    List<FarmerFromServerModel> farmers, {
    bool replaceExisting = true,
  }) async {
    if (farmers.isEmpty) return;

    final db = await database;

    await db.transaction((txn) async {
      final batch = txn.batch();

      for (var farmer in farmers) {
        batch.insert(
          farmersFromServerTable,
          farmer.toMap(),
          conflictAlgorithm: replaceExisting
              ? ConflictAlgorithm.replace
              : ConflictAlgorithm.ignore,
        );
      }

      await batch.commit();
    });
  }

  // 1. CREATE - Insert single district
  Future<int> insertDistrict(DistrictModel district) async {
    final db = await database;

    try {
      final id = await db.insert(
        districtTable,
        district.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return id;
    } catch (e) {
      throw Exception('Failed to insert district: $e');
    }
  }

  // 2. BULK INSERT - Insert multiple districts
  Future<void> bulkInsertDistricts(List<DistrictModel> districts) async {
    final db = await database;

    final batch = db.batch();

    try {
      for (final district in districts) {
        batch.insert(
          districtTable,
          district.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
    } catch (e) {
      throw Exception('Failed to bulk insert districts: $e');
    }
  }

  // 3. READ - Get all districts
  Future<List<DistrictModel>> getAllDistricts() async {
    final db = await database;

    try {
      final List<Map<String, dynamic>> maps = await db.query(
        districtTable,
        orderBy: 'district_name ASC',
      );

      return List.generate(maps.length, (i) {
        return DistrictModel.fromMap(maps[i]);
      });
    } catch (e) {
      throw Exception('Failed to get all districts: $e');
    }
  }

  // 4. READ - Get district by ID
  Future<DistrictModel?> getDistrictById(int id) async {
    final db = await database;

    try {
      final List<Map<String, dynamic>> maps = await db.query(
        districtTable,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return DistrictModel.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get district by ID: $e');
    }
  }

  // 5. READ - Get district by district_id
  Future<DistrictModel?> getDistrictByDistrictId(int districtId) async {
    final db = await database;

    try {
      final List<Map<String, dynamic>> maps = await db.query(
        districtTable,
        where: 'district_id = ?',
        whereArgs: [districtId],
      );

      if (maps.isNotEmpty) {
        return DistrictModel.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get district by district_id: $e');
    }
  }

  // 6. READ - Get districts by region ID
  Future<List<DistrictModel>> getDistrictsByRegionId(String regionId) async {
    final db = await database;

    try {
      final List<Map<String, dynamic>> maps = await db.query(
        districtTable,
        where: 'region_id = ?',
        whereArgs: [regionId],
        orderBy: 'district_name ASC',
      );

      return List.generate(maps.length, (i) {
        return DistrictModel.fromMap(maps[i]);
      });
    } catch (e) {
      throw Exception('Failed to get districts by region ID: $e');
    }
  }

  // 7. READ - Get districts by region name
  Future<List<DistrictModel>> getDistrictsByRegionName(
    String regionName,
  ) async {
    final db = await database;

    try {
      final List<Map<String, dynamic>> maps = await db.query(
        districtTable,
        where: 'region_name = ?',
        whereArgs: [regionName],
        orderBy: 'district_name ASC',
      );

      return List.generate(maps.length, (i) {
        return DistrictModel.fromMap(maps[i]);
      });
    } catch (e) {
      throw Exception('Failed to get districts by region name: $e');
    }
  }

  // 8. SEARCH - Search districts by name
  Future<List<DistrictModel>> searchDistricts(String query) async {
    final db = await database;

    try {
      final List<Map<String, dynamic>> maps = await db.query(
        districtTable,
        where: 'district_name LIKE ?',
        whereArgs: ['%$query%'],
        orderBy: 'district_name ASC',
      );

      return List.generate(maps.length, (i) {
        return DistrictModel.fromMap(maps[i]);
      });
    } catch (e) {
      throw Exception('Failed to search districts: $e');
    }
  }

  // 9. UPDATE - Update district
  Future<int> updateDistrict(DistrictModel district) async {
    final db = await database;

    try {
      return await db.update(
        districtTable,
        district.toMap(),
        where: 'id = ?',
        whereArgs: [district.id],
      );
    } catch (e) {
      throw Exception('Failed to update district: $e');
    }
  }

  // 10. DELETE - Delete district by ID
  Future<int> deleteDistrict(int id) async {
    final db = await database;

    try {
      return await db.delete(districtTable, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw Exception('Failed to delete district: $e');
    }
  }

  // 11. DELETE - Delete district by district_id
  Future<int> deleteDistrictByDistrictId(int districtId) async {
    final db = await database;

    try {
      return await db.delete(
        districtTable,
        where: 'district_id = ?',
        whereArgs: [districtId],
      );
    } catch (e) {
      throw Exception('Failed to delete district by district_id: $e');
    }
  }

  // 12. DELETE ALL - Clear all districts
  Future<int> deleteAllDistricts() async {
    final db = await database;

    try {
      return await db.delete(districtTable);
    } catch (e) {
      throw Exception('Failed to delete all districts: $e');
    }
  }

  // 13. COUNT - Get total number of districts
  Future<int> getDistrictsCount() async {
    final db = await database;

    try {
      final List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM $districtTable',
      );
      return result.first['count'] as int;
    } catch (e) {
      throw Exception('Failed to get districts count: $e');
    }
  }

  // 14. CHECK EXISTS - Check if district exists by district_id
  Future<bool> districtExists(int districtId) async {
    final db = await database;

    try {
      final List<Map<String, dynamic>> maps = await db.query(
        districtTable,
        where: 'district_id = ?',
        whereArgs: [districtId],
      );

      return maps.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check if district exists: $e');
    }
  }

  // 15. GET UNIQUE REGIONS - Get all unique regions
  Future<List<String>> getUniqueRegions() async {
    final db = await database;

    try {
      final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT DISTINCT region_name FROM $districtTable ORDER BY region_name ASC',
      );

      return List.generate(maps.length, (i) {
        return maps[i]['region_name'] as String;
      });
    } catch (e) {
      throw Exception('Failed to get unique regions: $e');
    }
  }

  // 16. GET DISTRICTS WITH PAGINATION
  Future<List<DistrictModel>> getDistrictsWithPagination({
    required int limit,
    required int offset,
    String? regionId,
  }) async {
    final db = await database;

    try {
      String whereClause = '';
      List<dynamic> whereArgs = [];

      if (regionId != null) {
        whereClause = 'WHERE region_id = ?';
        whereArgs.add(regionId);
      }

      final List<Map<String, dynamic>> maps = await db.rawQuery(
        '''
        SELECT * FROM $districtTable 
        $whereClause 
        ORDER BY district_name ASC 
        LIMIT ? OFFSET ?
      ''',
        [...whereArgs, limit, offset],
      );

      return List.generate(maps.length, (i) {
        return DistrictModel.fromMap(maps[i]);
      });
    } catch (e) {
      throw Exception('Failed to get districts with pagination: $e');
    }
  }

  // Bulk insert
  Future<void> bulkInsertMMDAs(List<MMDAModel> mmdas) async {
    if (mmdas.isEmpty) return;

    final db = await database;

    await db.transaction((txn) async {
      final batch = txn.batch();

      for (var mmda in mmdas) {
        batch.insert(mmdasTable, {
          'id': mmda.id,
          'mmda': mmda.mmda,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }

      await batch.commit();
    });
  }

  // Get all MMDAs
  Future<List<MMDAModel>> getAllMMDAs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      mmdasTable,
      orderBy: 'mmda ASC',
    );
    return maps
        .map(
          (map) =>
              MMDAModel(id: map['id'] as int?, mmda: map['mmda']?.toString()),
        )
        .toList();
  }

  // Delete all MMDAs
  Future<void> deleteAllMMDAs() async {
    final db = await database;
    await db.delete(mmdasTable);
  }

  // Tree Registration CRUD Methods
  Future<int> insertTreeRegistration(TreeRegistrationModel registration) async {
    final db = await database;

    // Start a transaction to handle both registration and trees
    return await db.transaction((txn) async {
      // Insert tree registration
      final registrationJson = registration.toJson();
      registrationJson.remove('id');
      registrationJson.remove(
        'trees',
      ); // Remove trees as they'll be stored separately

      final registrationId = await txn.insert(
        treeRegistrationTable,
        registrationJson,
      );

      // Insert trees if any
      if (registration.trees.isNotEmpty) {
        for (final tree in registration.trees) {
          await txn.insert(treesTable, {
            'tree_registration_id': registrationId,
            'tree_name': tree['tree_name'],
            'pn': tree['pn'],
            'species': tree['species'],
            'size': tree['size'],
            'yo_establishment': tree['yo_establishment'],
            'latitude': tree['latitude'],
            'longitude': tree['longitude'],
            'altitude': tree['altitude'],
            'accuracy': tree['accuracy'],
          });
        }
      }

      return registrationId;
    });
  }

  Future<List<TreeRegistrationModel>> getAllTreeRegistrations() async {
    final db = await database;
    final registrations = await db.query(treeRegistrationTable);

    final result = <TreeRegistrationModel>[];
    for (final reg in registrations) {
      final trees = await getTreesByRegistrationId(reg['id'] as int);
      result.add(TreeRegistrationModel.fromJson({...reg, 'trees': trees}));
    }

    return result;
  }

  Future<TreeRegistrationModel?> getTreeRegistrationById(int id) async {
    final db = await database;
    final maps = await db.query(
      treeRegistrationTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      final trees = await getTreesByRegistrationId(id);
      return TreeRegistrationModel.fromJson({...maps.first, 'trees': trees});
    }
    return null;
  }

  Future<List<TreeRegistrationModel>> getTreeRegistrationsByFarmerId(
    int farmerId,
  ) async {
    final db = await database;
    final maps = await db.query(
      treeRegistrationTable,
      where: 'farmer_id = ?',
      whereArgs: [farmerId],
    );

    final result = <TreeRegistrationModel>[];
    for (final reg in maps) {
      final trees = await getTreesByRegistrationId(reg['id'] as int);
      result.add(TreeRegistrationModel.fromJson({...reg, 'trees': trees}));
    }

    return result;
  }

  Future<List<TreeRegistrationModel>> getUnsyncedTreeRegistrations() async {
    final db = await database;
    final maps = await db.query(
      treeRegistrationTable,
      where: 'is_synced = ?',
      whereArgs: [0],
    );

    final result = <TreeRegistrationModel>[];
    for (final reg in maps) {
      final trees = await getTreesByRegistrationId(reg['id'] as int);
      result.add(TreeRegistrationModel.fromJson({...reg, 'trees': trees}));
    }

    return result;
  }

  Future<int> updateTreeRegistration(TreeRegistrationModel registration) async {
    final db = await database;
    if (registration.id == null) throw Exception('Cannot update without ID');

    return await db.transaction((txn) async {
      // Update registration
      final registrationJson = registration.toJson();
      registrationJson.remove(
        'trees',
      ); // Remove trees as they'll be handled separately
      registrationJson['updated_at'] = DateTime.now().toIso8601String();

      final result = await txn.update(
        treeRegistrationTable,
        registrationJson,
        where: 'id = ?',
        whereArgs: [registration.id],
      );

      // Update trees - delete existing and insert new ones
      await txn.delete(
        treesTable,
        where: 'tree_registration_id = ?',
        whereArgs: [registration.id],
      );

      if (registration.trees.isNotEmpty) {
        for (final tree in registration.trees) {
          await txn.insert(treesTable, {
            'tree_registration_id': registration.id,
            'tree_name': tree['tree_name'],
            'pn': tree['pn'],
            'species': tree['species'],
            'size': tree['size'],
            'yo_establishment': tree['yo_establishment'],
            'latitude': tree['latitude'],
            'longitude': tree['longitude'],
            'altitude': tree['altitude'],
            'accuracy': tree['accuracy'],
          });
        }
      }

      return result;
    });
  }

  Future<int> deleteTreeRegistration(int id) async {
    final db = await database;
    // Trees will be automatically deleted due to CASCADE
    return await db.delete(
      treeRegistrationTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllTreeRegistrations() async {
    final db = await database;
    return await db.delete(treeRegistrationTable);
  }

  Future<int> markTreeRegistrationAsSynced(int id) async {
    final db = await database;
    return await db.update(
      treeRegistrationTable,
      {'is_synced': 1, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getTreeRegistrationCount() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) FROM $treeRegistrationTable',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Trees CRUD Methods
  Future<List<Map<String, dynamic>>> getTreesByRegistrationId(
    int registrationId,
  ) async {
    final db = await database;
    final maps = await db.query(
      treesTable,
      where: 'tree_registration_id = ?',
      whereArgs: [registrationId],
    );
    return maps;
  }

  Future<int> insertTree(Map<String, dynamic> tree, int registrationId) async {
    final db = await database;
    return await db.insert(treesTable, {
      'tree_registration_id': registrationId,
      'tree_name': tree['tree_name'],
      'pn': tree['pn'],
      'species': tree['species'],
      'size': tree['size'],
      'yo_establishment': tree['yo_establishment'],
      'latitude': tree['latitude'],
      'longitude': tree['longitude'],
      'altitude': tree['altitude'],
      'accuracy': tree['accuracy'],
    });
  }

  Future<int> updateTree(Map<String, dynamic> tree, int treeId) async {
    final db = await database;
    return await db.update(
      treesTable,
      tree,
      where: 'id = ?',
      whereArgs: [treeId],
    );
  }

  Future<int> deleteTree(int treeId) async {
    final db = await database;
    return await db.delete(treesTable, where: 'id = ?', whereArgs: [treeId]);
  }

  Future<List<Map<String, dynamic>>> getAllTrees() async {
    final db = await database;
    return await db.query(treesTable);
  }

  Future<int> getTreeCountByRegistrationId(int registrationId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) FROM $treesTable WHERE tree_registration_id = ?',
      [registrationId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // In AppDatabaseHelper class
  Future<int> insertFarmerBiodata(FarmerBiodataModel farmer) async {
    final db = await database;
    return await db.insert(
      localFarmerTable,
      farmer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<FarmerBiodataModel>> getAllFarmerBiodata() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      localFarmerTable,
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => FarmerBiodataModel.fromMap(map)).toList();
  }

  Future<List<FarmerBiodataModel>> getFarmerBiodataByStatus(
    String status,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      localFarmerTable,
      where: 'status = ?',
      whereArgs: [status],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => FarmerBiodataModel.fromMap(map)).toList();
  }

  Future<FarmerBiodataModel?> getFarmerBiodataById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      localFarmerTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return FarmerBiodataModel.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateFarmerBiodata(FarmerBiodataModel farmer) async {
    final db = await database;
    return await db.update(
      localFarmerTable,
      farmer.toMap(),
      where: 'id = ?',
      whereArgs: [farmer.id],
    );
  }

  Future<int> deleteFarmerBiodata(int id) async {
    final db = await database;
    return await db.delete(localFarmerTable, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> bulkInsertFarmerBiodata(List<FarmerBiodataModel> farmers) async {
    final db = await database;
    final batch = db.batch();
    for (final farmer in farmers) {
      batch.insert(
        localFarmerTable,
        farmer.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }

  Future<int> insertReport(DeforestationReportModel report) async {
    final db = await database;
    return await db.insert(deforestationReportsTAble, report.toMap());
  }

  Future<List<DeforestationReportModel>> getAllReports() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      deforestationReportsTAble,
      orderBy: 'created_at DESC',
    );
    return List.generate(maps.length, (i) {
      return DeforestationReportModel.fromMap(maps[i]);
    });
  }

  Future<List<DeforestationReportModel>> getPendingReports() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      deforestationReportsTAble,
      where: 'submission_status = ?',
      whereArgs: ['pending'],
      orderBy: 'created_at DESC',
    );
    return List.generate(maps.length, (i) {
      return DeforestationReportModel.fromMap(maps[i]);
    });
  }

  Future<int> updateReport(DeforestationReportModel report) async {
    final db = await database;
    return await db.update(
      deforestationReportsTAble,
      report.toMap(),
      where: 'id = ?',
      whereArgs: [report.id],
    );
  }

  Future<int> deleteReport(int id) async {
    final db = await database;
    return await db.delete(
      deforestationReportsTAble,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> markAsSubmitted(int id) async {
    final db = await database;
    return await db.update(
      deforestationReportsTAble,
      {
        'submission_status': 'submitted',
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Create
  Future<int> insertTrainingLog(TrainingLogModel trainingLog) async {
    final db = await database;
    trainingLog.createdAt = DateTime.now();
    trainingLog.updatedAt = DateTime.now();

    return await db.insert(trainingLogTable, trainingLog.toMap());
  }

  // Read - Get all training logs
  Future<List<TrainingLogModel>> getAllTrainingLogs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      trainingLogTable,
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) {
      return TrainingLogModel.fromMap(maps[i]);
    });
  }

  // Read - Get training log by ID
  Future<TrainingLogModel?> getTrainingLogById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      trainingLogTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return TrainingLogModel.fromMap(maps.first);
    }
    return null;
  }

  // Read - Get unsynced training logs
  Future<List<TrainingLogModel>> getUnsyncedTrainingLogs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      trainingLogTable,
      where: 'is_synced = ?',
      whereArgs: [0],
      orderBy: 'created_at ASC',
    );

    return List.generate(maps.length, (i) {
      return TrainingLogModel.fromMap(maps[i]);
    });
  }

  // Update
  Future<int> updateTrainingLog(TrainingLogModel trainingLog) async {
    final db = await database;
    trainingLog.updatedAt = DateTime.now();

    return await db.update(
      trainingLogTable,
      trainingLog.toMap(),
      where: 'id = ?',
      whereArgs: [trainingLog.id],
    );
  }

  // Delete
  Future<int> deleteTrainingLog(int id) async {
    final db = await database;
    return await db.delete(trainingLogTable, where: 'id = ?', whereArgs: [id]);
  }

  // Mark as synced
  Future<int> markAsSynced(int id) async {
    final db = await database;
    return await db.update(
      trainingLogTable,
      {'is_synced': 1, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Get training logs by enumerator
  Future<List<TrainingLogModel>> getTrainingLogsByEnumerator(
    int enumeratorId,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      trainingLogTable,
      where: 'enumerator_id = ?',
      whereArgs: [enumeratorId],
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) {
      return TrainingLogModel.fromMap(maps[i]);
    });
  }

  // Get training logs by community
  Future<List<TrainingLogModel>> getTrainingLogsByCommunity(
    int communityId,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      trainingLogTable,
      where: 'community_id = ?',
      whereArgs: [communityId],
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) {
      return TrainingLogModel.fromMap(maps[i]);
    });
  }

  // Get count of training logs
  Future<int> getTrainingLogsCount() async {
    final db = await database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM training_logs'),
    );
    return count ?? 0;
  }

  Future<void> insert(String table, Map<String, Object> data) async {
    final db = await database;
    db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> fetchData(String table) async {
    final db = await database;
    return db.query(table);
  }

  Future<List<Map<String, dynamic>>> fetchData2(String table, field) async {
    final db = await database;
    return db.query(table, groupBy: "$field");
  }

  Future<List<Map<String, dynamic>>> fetchDataWhere(
    String table,
    fieldname,
    id,
  ) async {
    final db = await database;
    return db.query(table, where: "$fieldname = ?", whereArgs: [id]);
  }

  delete(String id) async {
    final db = await database;
    db.delete('forest_app', where: 'ID = ?', whereArgs: [id]);
  }

  deleteMV(String seedlingMonitoringTable, String id) async {
    final db = await database;
    db.delete(seedlingMonitoringTable, where: 'ID = ?', whereArgs: [id]);
  }

  deleteLFD(String seedlingMonitoringTable, String contact) async {
    final db = await database;
    db.delete(seedlingMonitoringTable, where: 'foContact = ?', whereArgs: [contact]);
  }

  //  Future<void> update(String ft, String dn, String ev, String st) async {
  //   final db = await database;
  //   await db.rawUpdate(
  //       'UPDATE first_time_user SET firstTime = ?, displayName = ?, enumeratorValue = ?  WHERE id = ?',
  //       ['$ft', '$dn', '$ev', '$st']);
  // }

  Future<void> updateLog(String logStat, String id) async {
    final db = await database;
    await db.rawUpdate('UPDATE first_time_user SET log = ? WHERE id = ?', [
      logStat,
      id,
    ]);
  }

  //  Future<void> updateFarmerApiList(String logStat, String id) async {
  //   final db = await database;

  //   await db.rawInsert("INSERT IGNORE INTO farmer_api_list ");
  //   await db.rawUpdate(
  //       'UPDATE farmer_api_list SET log = ? WHERE id = ?', ['$logStat', '$id']);
  // }

  Future<void> updateFarmerApiList(
    String table,
    Map<String, Object> data,
  ) async {
    final db = await database;

    // await db.rawInsert("INSERT IGNORE INTO farmer_api_list ");
    // await db.rawUpdate(
    //     'UPDATE farmer_api_list SET log = ? WHERE id = ?', ['$logStat', '$id']);
    db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.ignore);
  }

  Future<void> update(String xx, String id) async {
    final db = await database;
    await db.rawUpdate('UPDATE forest_app SET conStat = ? WHERE id = ?', [
      xx,
      id,
    ]);
  }

  Future<void> updateMView(
    String seedlingMonitoringTable,
    String conName,
    String newCon,
    String id,
  ) async {
    final db = await database;
    await db.rawUpdate('UPDATE $seedlingMonitoringTable SET $conName = ? WHERE id = ?', [
      newCon,
      id,
    ]);
  }

  Future<void> updateGroupBeforeSend(
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
    String id,
  ) async {
    final db = await database;
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
        id,
      ],
    );
  }

  Future<void> updateIndBeforeSend(
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
    String id,
  ) async {
    final db = await database;
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
        id,
      ],
    );
  }

  // /// Insert list of maps into [table] in chunked transactions to avoid locks.
  // /// `records` should already be serializable map values.
  //  Future<int> insertRecords(
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
  //  Future<int> getCount(String table) async {
  //   final db = await database;
  //   final row = await db.rawQuery('SELECT COUNT(*) as c FROM $table');
  //   return sql.Sqflite.firstIntValue(row) ?? 0;
  // }

  //  Future<void> close() async {
  //   if (db != null) {
  //     await db!.close();
  //     _db = null;
  //   }
  // }

// CREATE - Insert a new seedling monitoring record
  Future<int> insertSeedlingMonitoring(SeedlingMonitoringModel model) async {
    final db = await database;

    final data = _modelToMap(model);
    data.remove('id'); // Remove id for auto-increment

    final id = await db.insert(seedlingMonitoringTable, data);
    return id;
  }

  // READ - Get all seedling monitoring records
  Future<List<SeedlingMonitoringModel>> getAllSeedlingMonitoring() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      seedlingMonitoringTable,
      orderBy: 'created_at DESC',
    );

    return maps.map(_mapToModel).toList();
  }

  // READ - Get seedling monitoring by ID
  Future<SeedlingMonitoringModel?> getSeedlingMonitoringById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      seedlingMonitoringTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return _mapToModel(maps.first);
    }
    return null;
  }

  // READ - Get seedling monitoring by submission status
  Future<List<SeedlingMonitoringModel>> getSeedlingMonitoringByStatus(String status) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      seedlingMonitoringTable,
      where: 'submission_status = ?',
      whereArgs: [status],
      orderBy: 'created_at DESC',
    );

    return maps.map(_mapToModel).toList();
  }

  // READ - Get unsynced records (for offline sync)
  Future<List<SeedlingMonitoringModel>> getUnsyncedSeedlingMonitoring() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      seedlingMonitoringTable,
      where: 'submission_status = ? OR connection_status = ?',
      whereArgs: ['draft', 'not connected'],
      orderBy: 'created_at ASC',
    );

    return maps.map(_mapToModel).toList();
  }

  // READ - Search seedling monitoring records
  Future<List<SeedlingMonitoringModel>> searchSeedlingMonitoring(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      seedlingMonitoringTable,
      where: 'farmer_name LIKE ? OR community LIKE ? OR surveyor_name LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'created_at DESC',
    );

    return maps.map(_mapToModel).toList();
  }

  // UPDATE - Update a seedling monitoring record
  Future<int> updateSeedlingMonitoring(SeedlingMonitoringModel model) async {
    if (model.id == null) {
      throw Exception('Cannot update record without ID');
    }

    final db = await database;
    final data = _modelToMap(model);

    return await db.update(
      seedlingMonitoringTable,
      data,
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  // UPDATE - Update specific fields
  Future<int> updateSeedlingMonitoringFields({
    required int id,
    required Map<String, dynamic> fields,
  }) async {
    final db = await database;
    final updatedFields = Map<String, dynamic>.from(fields);
    updatedFields['updated_at'] = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    return await db.update(
      seedlingMonitoringTable,
      updatedFields,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // UPDATE - Mark record as submitted
  Future<int> markSeedlingMonitoringAsSubmitted(int id) async {
    final db = await database;
    return await db.update(
      seedlingMonitoringTable,
      {
        'submission_status': 'submitted',
        'connection_status': 'connected',
        'updated_at': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // UPDATE - Mark record as draft
  Future<int> markAsDraft(int id) async {
    final db = await database;
    return await db.update(
      seedlingMonitoringTable,
      {
        'submission_status': 'draft',
        'updated_at': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE - Delete a seedling monitoring record
  Future<int> deleteSeedlingMonitoring(int id) async {
    final db = await database;
    return await db.delete(
      seedlingMonitoringTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE - Delete all seedling monitoring records
  Future<int> deleteAllSeedlingMonitoring() async {
    final db = await database;
    return await db.delete(seedlingMonitoringTable);
  }

  // COUNT - Get total number of records
  Future<int> getSeedlingMonitoringCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM $seedlingMonitoringTable');
    return result.first['count'] as int;
  }

  // COUNT - Get count by status
  Future<int> getSeedlingMonitoringCountByStatus(String status) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $seedlingMonitoringTable WHERE submission_status = ?',
      [status],
    );
    return result.first['count'] as int;
  }

  // BULK INSERT - Insert multiple records
  Future<void> bulkInsertSeedlingMonitoring(List<SeedlingMonitoringModel> models) async {
    if (models.isEmpty) return;

    final db = await database;
    final batch = db.batch();

    for (final model in models) {
      final data = _modelToMap(model);
      data.remove('id'); // Remove id for auto-increment
      batch.insert(seedlingMonitoringTable, data);
    }

    await batch.commit();
  }

  // Helper method to convert model to map for database
  Map<String, dynamic> _modelToMap(SeedlingMonitoringModel model) {
    return {
      'id': model.id,
      // General Information
      'surveyor_name': model.surveyorName,
      'date_of_survey': model.dateOfSurvey,
      'community': model.community,
      'farmer_name': model.farmerName,
      'farmer_id_number': model.farmerIDNumber,
      'community_not_found': model.communityNotFound == true ? 1 : 0,
      'custom_community_name': model.customCommunityName,

      // Plantation Details
      'plantation_type': model.plantationType,
      'total_size_acres': model.totalSizeAcres,
      'species_provided_planted': model.speciesProvidedPlanted.isNotEmpty
          ? json.encode(model.speciesProvidedPlanted)
          : null,

      // Species Planting Details
      'species_planting_details': model.speciesPlantingDetails.isNotEmpty
          ? json.encode(model.speciesPlantingDetails.map((detail) => detail.toJson()).toList())
          : null,

      // Mapped Area
      'mapped_farm_boundaries': model.mappedFarmBoundaries,
      'mapped_area_hectares': model.mappedAreaHectares,

      // Seedling Survival
      'total_seedlings_alive': model.totalSeedlingsAlive,
      'species_alive': model.speciesAlive.isNotEmpty
          ? json.encode(model.speciesAlive)
          : null,
      'reason_for_death': model.reasonForDeath.isNotEmpty
          ? json.encode(model.reasonForDeath)
          : null,
      'mapped_surviving_seedlings': model.mappedSurvivingSeedlings,

      // Environmental Conditions
      'source_of_water': model.sourceOfWater.isNotEmpty
          ? json.encode(model.sourceOfWater)
          : null,
      'watering_frequency': model.wateringFrequency,
      'has_extreme_weather': model.hasExtremeWeather == true ? 1 : 0,
      'extreme_weathers': model.extremeWeathers.isNotEmpty
          ? json.encode(model.extremeWeathers)
          : null,
      'other_extreme_weather': model.otherExtremeWeather,

      // Final Observations
      'pests_around': model.pestsAround == true ? 1 : 0,
      'pest_description': model.pestDescription,
      'signs_of_disease': model.signsOfDisease == true ? 1 : 0,
      'disease_description': model.diseaseDescription,
      'fertiliser_applied': model.fertiliserApplied == true ? 1 : 0,
      'fertiliser_type': model.fertiliserType,
      'pesticide_applied': model.pesticideApplied == true ? 1 : 0,
      'pesticide_type': model.pesticideType,
      'additional_observations': model.additionalObservations,

      // Metadata
      'farmer_contact': model.farmerContact,
      'enumerator_value': model.enumeratorValue,
      'created_at': model.createdAt?.toIso8601String(),
      'submission_status': model.submissionStatus,
      'connection_status': model.connectionStatus,
    };
  }

  // Helper method to convert map to model
  SeedlingMonitoringModel _mapToModel(Map<String, dynamic> map) {
    return SeedlingMonitoringModel(
      // General Information
      surveyorName: map['surveyor_name'],
      dateOfSurvey: map['date_of_survey'],
      community: map['community'],
      farmerName: map['farmer_name'],
      farmerIDNumber: map['farmer_id_number'],
      communityNotFound: map['community_not_found'] == 1,
      customCommunityName: map['custom_community_name'],

      // Plantation Details
      plantationType: map['plantation_type'],
      totalSizeAcres: map['total_size_acres']?.toDouble(),
      speciesProvidedPlanted: map['species_provided_planted'] != null
          ? List<String>.from(json.decode(map['species_provided_planted']))
          : [],

      // Species Planting Details
      speciesPlantingDetails: map['species_planting_details'] != null
          ? (json.decode(map['species_planting_details']) as List<dynamic>)
          .map((detail) => SpeciesPlantingDetail.fromJson(detail))
          .toList()
          : [],

      // Mapped Area
      mappedFarmBoundaries: map['mapped_farm_boundaries'],
      mappedAreaHectares: map['mapped_area_hectares']?.toDouble(),

      // Seedling Survival
      totalSeedlingsAlive: map['total_seedlings_alive'],
      speciesAlive: map['species_alive'] != null
          ? List<String>.from(json.decode(map['species_alive']))
          : [],
      reasonForDeath: map['reason_for_death'] != null
          ? List<String>.from(json.decode(map['reason_for_death']))
          : [],
      mappedSurvivingSeedlings: map['mapped_surviving_seedlings'],

      // Environmental Conditions
      sourceOfWater: map['source_of_water'] != null
          ? List<String>.from(json.decode(map['source_of_water']))
          : [],
      wateringFrequency: map['watering_frequency'],
      hasExtremeWeather: map['has_extreme_weather'] == 1,
      extremeWeathers: map['extreme_weathers'] != null
          ? List<String>.from(json.decode(map['extreme_weathers']))
          : [],
      otherExtremeWeather: map['other_extreme_weather'],

      // Final Observations
      pestsAround: map['pests_around'] == 1,
      pestDescription: map['pest_description'],
      signsOfDisease: map['signs_of_disease'] == 1,
      diseaseDescription: map['disease_description'],
      fertiliserApplied: map['fertiliser_applied'] == 1,
      fertiliserType: map['fertiliser_type'],
      pesticideApplied: map['pesticide_applied'] == 1,
      pesticideType: map['pesticide_type'],
      additionalObservations: map['additional_observations'],

      // Metadata
      farmerContact: map['farmer_contact'],
      enumeratorValue: map['enumerator_value'],
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      submissionStatus: map['submission_status'],
      connectionStatus: map['connection_status'],
    )..id = map['id'];
  }

}
