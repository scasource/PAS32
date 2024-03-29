object PASDataModule: TPASDataModule
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 408
  Top = 146
  Height = 479
  Width = 741
  object SalesTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISSBLKEY_SALENUMBER'
    ReadOnly = True
    TableName = 'PSalesRec'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 214
    Top = 135
  end
  object TYAssessmentTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    ReadOnly = True
    TableName = 'tpassessrec'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 58
    Top = 17
  end
  object HistoryAssessmentTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    ReadOnly = True
    TableName = 'hpassessrec'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 51
    Top = 5
  end
  object NYAssessmentTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    ReadOnly = True
    TableName = 'npassessrec'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 52
    Top = 34
  end
  object HistoryExemptionCodeTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYEXCODE'
    ReadOnly = True
    TableName = 'HExCodeTbl'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 179
    Top = 2
  end
  object TYExemptionCodeTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYEXCODE'
    ReadOnly = True
    TableName = 'TExCodeTbl'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 184
    Top = 14
  end
  object NYExemptionCodeTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYEXCODE'
    ReadOnly = True
    TableName = 'NExCodeTbl'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 177
    Top = 26
  end
  object NYExemptionTable: TwwTable
    DatabaseName = 'PASSystem'
    IndexName = 'BYYEAR_SWISSBLKEY_EXCODE'
    ReadOnly = True
    TableName = 'NPExemptionRec'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 309
    Top = 24
  end
  object TYExemptionTable: TwwTable
    DatabaseName = 'PASSystem'
    IndexName = 'BYYEAR_SWISSBLKEY_EXCODE'
    ReadOnly = True
    TableName = 'TPExemptionRec'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 306
    Top = 16
  end
  object HistoryExemptionTable: TwwTable
    DatabaseName = 'PASSystem'
    IndexName = 'BYYEAR_SWISSBLKEY_EXCODE'
    ReadOnly = True
    TableName = 'HPExemptionRec'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 304
    Top = 7
  end
  object TYSpecialDistrictTable: TwwTable
    DatabaseName = 'PASSystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY_SD'
    ReadOnly = True
    TableName = 'TPSpclDistRec'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 262
    Top = 87
  end
  object HistorySpecialDistrictTable: TwwTable
    DatabaseName = 'PASSystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY_SD'
    ReadOnly = True
    TableName = 'HPSpclDistRec'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 257
    Top = 76
  end
  object NYSpecialDistrictTable: TwwTable
    DatabaseName = 'PASSystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY_SD'
    ReadOnly = True
    TableName = 'NPSpclDistRec'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 259
    Top = 100
  end
  object HistoryClassTable: TwwTable
    DatabaseName = 'PASSystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'HPClassRec'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 379
    Top = 75
  end
  object HistoryParcelTable: TwwTable
    DatabaseName = 'PASSystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    ReadOnly = True
    TableName = 'hparcelrec'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 129
    Top = 78
  end
  object TYParcelTable: TwwTable
    DatabaseName = 'PASSystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    ReadOnly = True
    TableName = 'tparcelrec'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 128
    Top = 88
  end
  object NYParcelTable: TwwTable
    DatabaseName = 'PASSystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    ReadOnly = True
    TableName = 'nparcelrec'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 130
    Top = 106
  end
  object TYClassTable: TwwTable
    DatabaseName = 'PASSystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'tpclassrec'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 383
    Top = 108
  end
  object HistorySwisCodeTable: TwwTable
    DatabaseName = 'PASSystem'
    IndexName = 'BYSWISCODE'
    TableName = 'HSwisTbl'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 480
    Top = 111
  end
  object TYSwisCodeTable: TwwTable
    DatabaseName = 'PASSystem'
    IndexName = 'BYSWISCODE'
    TableName = 'tswistbl'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 481
    Top = 125
  end
  object NYSwisCodeTable: TwwTable
    DatabaseName = 'PASSystem'
    IndexName = 'BYSWISCODE'
    TableName = 'NSwisTbl'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 477
    Top = 140
  end
  object HistoryAssessmentYearControlTable: TwwTable
    DatabaseName = 'PASSystem'
    TableName = 'HAssmtYrCtlFile'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 72
    Top = 121
  end
  object TYAssessmentYearControlTable: TwwTable
    DatabaseName = 'PASSystem'
    TableName = 'TAssmtYrCtlFile'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 77
    Top = 135
  end
  object NYAssessmentYearControlTable: TwwTable
    DatabaseName = 'PASSystem'
    TableName = 'NAssmtYrCtlFile'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 68
    Top = 147
  end
  object NYClassTable: TwwTable
    DatabaseName = 'PASSystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'NPClassRec'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 385
    Top = 100
  end
  object HistorySpecialDistrictCodeTable: TwwTable
    DatabaseName = 'PASSystem'
    TableName = 'HSDCodeTbl'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 317
    Top = 196
  end
  object HistoryResidentialSiteTable: TwwTable
    DatabaseName = 'PASSystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'hpresidentialsite'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 65
    Top = 199
  end
  object TYResidentialSiteTable: TwwTable
    DatabaseName = 'PASSystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'tpresidentialsite'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 62
    Top = 208
  end
  object NYResidentialSiteTable: TwwTable
    DatabaseName = 'PASSystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'npresidentialsite'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 65
    Top = 216
  end
  object TYSpecialDistrictCodeTable: TwwTable
    DatabaseName = 'PASSystem'
    TableName = 'TSDCodeTbl'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 314
    Top = 166
  end
  object HistoryCommercialSiteTable: TwwTable
    DatabaseName = 'PASSystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'hpcommercialsite'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 59
    Top = 259
  end
  object TYCommercialSiteTable: TwwTable
    DatabaseName = 'PASSystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'tpcommercialsite'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 62
    Top = 268
  end
  object NYCommercialSiteTable: TwwTable
    DatabaseName = 'PASSystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'npcommercialsite'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 89
    Top = 200
  end
  object NYSpecialDistrictCodeTable: TwwTable
    DatabaseName = 'PASSystem'
    TableName = 'NSDCodeTbl'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 321
    Top = 180
  end
  object PASDatabase: TDatabase
    AliasName = 'PropertyAssessmentSystem'
    Connected = True
    DatabaseName = 'PASsystem'
    SessionName = 'Default'
    Left = 30
    Top = 87
  end
  object SalesResidentialSiteTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISSBLKEY_SALESNUMBER_SITE'
    ReadOnly = True
    TableName = 'SPResidentialSite'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 65
    Top = 225
  end
  object HistoryResidentialBuildingTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY_SITE'
    ReadOnly = True
    TableName = 'HPResidentialBldg'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 202
    Top = 245
  end
  object TYResidentialBuildingTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY_SITE'
    ReadOnly = True
    TableName = 'TPResidentialBldg'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 203
    Top = 222
  end
  object NYResidentialBuildingTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY_SITE'
    ReadOnly = True
    TableName = 'NPResidentialBldg'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 203
    Top = 244
  end
  object SalesResidentialBuildingTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISSBLKEY_SALESNUMBER_SITE'
    ReadOnly = True
    TableName = 'SPResidentialBldg'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 206
    Top = 256
  end
  object HistoryResidentialLandTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SBL_SITE_LANDNUM'
    ReadOnly = True
    TableName = 'HPResidentialLand'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 303
    Top = 293
  end
  object TYResidentialLandTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SBL_SITE_LANDNUM'
    ReadOnly = True
    TableName = 'TPResidentialLand'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 307
    Top = 306
  end
  object NYResidentialLandTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SBL_SITE_LANDNUM'
    ReadOnly = True
    TableName = 'NPResidentialLand'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 319
    Top = 310
  end
  object SalesResidentialLandTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSBL_SALENUM_SITE_LANDNUM'
    ReadOnly = True
    TableName = 'SPResidentialLand'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 315
    Top = 324
  end
  object HistoryResidentialImprovementTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SBL_SITE_IMPNO'
    ReadOnly = True
    TableName = 'HPResidentialImprove'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 424
    Top = 242
  end
  object TYResidentialImprovementTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SBL_SITE_IMPNO'
    ReadOnly = True
    TableName = 'TPResidentialImprove'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 423
    Top = 235
  end
  object SalesResidentialImprovementTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSBL_SALENO_SITE_IMPNO'
    ReadOnly = True
    TableName = 'SPResidentialImprove'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 429
    Top = 252
  end
  object NYResidentialImprovementTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SBL_SITE_IMPNO'
    ReadOnly = True
    TableName = 'NPResidentialImprove'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 430
    Top = 276
  end
  object TYCommercialImprovementTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SBL_SITE_IMPNO'
    ReadOnly = True
    TableName = 'TPCommercialImprove'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 457
    Top = 318
  end
  object HistoryCommercialIncomeExpenseTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SBL_SITE'
    ReadOnly = True
    TableName = 'hpcommercialincexp'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 54
    Top = 349
  end
  object TYCommercialRentTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SBL_SITE_USE'
    ReadOnly = True
    TableName = 'TPCommercialRent'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 450
    Top = 408
  end
  object SalesCommercialLandTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSBL_SALENUM_SITE_LANDNUM'
    ReadOnly = True
    TableName = 'SPCommercialLand'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 302
    Top = 418
  end
  object NYCommercialImprovementTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SBL_SITE_IMPNO'
    ReadOnly = True
    TableName = 'NPCommercialImprove'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 465
    Top = 337
  end
  object SalesCommercialIncomeExpenseTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISSBLKEY_SALESNUMBER'
    ReadOnly = True
    TableName = 'SPCommercialIncExp'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 60
    Top = 396
  end
  object TYCommercialIncomeExpenseTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SBL_SITE'
    ReadOnly = True
    TableName = 'tpcommercialincexp'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 54
    Top = 366
  end
  object HistoryCommercialBuildingTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYYEAR_SBL_SITE_BLDGNUM_SECT'
    ReadOnly = True
    TableName = 'Hpcommercialbldg'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 196
    Top = 313
  end
  object NYCommercialRentTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SBL_SITE_USE'
    ReadOnly = True
    TableName = 'NPCommercialRent'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 451
    Top = 423
  end
  object NYCommercialLandTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SBL_SITE_LANDNUM'
    ReadOnly = True
    TableName = 'NPCommercialLand'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 303
    Top = 406
  end
  object TYCommercialBuildingTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYYEAR_SBL_SITE_BLDGNUM_SECT'
    ReadOnly = True
    TableName = 'tpcommercialbldg'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 196
    Top = 332
  end
  object NYCommercialIncomeExpenseTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SBL_SITE'
    ReadOnly = True
    TableName = 'npcommercialincexp'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 59
    Top = 380
  end
  object HistoryCommercialImprovementTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SBL_SITE_IMPNO'
    ReadOnly = True
    TableName = 'HPCommercialImprove'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 458
    Top = 300
  end
  object SalesCommercialRentTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSBL_SALES_SITE_USE'
    ReadOnly = True
    TableName = 'SPCommercialRent'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 456
    Top = 433
  end
  object HistoryCommercialLandTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SBL_SITE_LANDNUM'
    ReadOnly = True
    TableName = 'HPCommercialLand'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 298
    Top = 381
  end
  object NYCommercialBuildingTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYYEAR_SBL_SITE_BLDGNUM_SECT'
    ReadOnly = True
    TableName = 'Npcommercialbldg'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 196
    Top = 346
  end
  object SalesCommercialBuildingTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSBL_SALES_SITE_BLDGNO_SECT'
    ReadOnly = True
    TableName = 'SPCommercialBldg'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 197
    Top = 362
  end
  object TYCommercialLandTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SBL_SITE_LANDNUM'
    ReadOnly = True
    TableName = 'TPCommercialLand'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 304
    Top = 395
  end
  object HistoryCommercialRentTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SBL_SITE_USE'
    ReadOnly = True
    TableName = 'HPCommercialRent'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 450
    Top = 396
  end
  object SalesCommercialImprovementTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSBL_SALENO_SITE_IMPNO'
    ReadOnly = True
    TableName = 'SPCommercialImprove'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 465
    Top = 351
  end
  object HistorySchoolCodeTable: TwwTable
    DatabaseName = 'PASsystem'
    ReadOnly = True
    TableName = 'HSchoolTbl'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 182
    Top = 241
  end
  object TYSchoolCodeTable: TwwTable
    DatabaseName = 'PASsystem'
    ReadOnly = True
    TableName = 'TSchoolTbl'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 178
    Top = 223
  end
  object NYSchoolCodeTable: TwwTable
    DatabaseName = 'PASsystem'
    ReadOnly = True
    TableName = 'NSchoolTbl'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 182
    Top = 172
  end
  object HistoryResidentialForestTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SBL_SITE_FOREST'
    ReadOnly = True
    TableName = 'HPResidentialForest'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 472
    Top = 189
  end
  object TYResidentialForestTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SBL_SITE_FOREST'
    ReadOnly = True
    TableName = 'TPResidentialForest'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 484
    Top = 203
  end
  object NYResidentialForestTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SBL_SITE_FOREST'
    TableName = 'NPResidentialForest'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 523
    Top = 192
  end
  object SalesResidentialForestTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSBL_SALESNUM_SITE_FOREST'
    TableName = 'SPResidentialForest'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 504
    Top = 222
  end
  object SalesCommercialSiteTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISSBLKEY_SALESNUMBER'
    TableName = 'SPCommercialSite'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 53
    Top = 216
  end
  object DocumentTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISSBLKEY_DOCUMENTNUMBER'
    TableName = 'pdocumentrec'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 412
    Top = 23
  end
  object PictureTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISSBLKEY_PICTURENUMBER'
    TableName = 'ppicturerec'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 92
    Top = 58
  end
  object SketchTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISSBLKEY_SKETCHNUMBER'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 194
    Top = 72
  end
  object PropertyCardTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISSBLKEY_DOCUMENTNUMBER'
    TableName = 'ppropertycard'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 465
    Top = 54
  end
  object tb_CertiorariDocument: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISSBLKEY_DOCUMENTNUMBER'
    TableType = ttDBase
    Left = 245
    Top = 59
  end
end
