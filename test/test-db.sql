/*
 Navicat Premium Data Transfer

 Source Server         : 1/3-2012
 Source Server Type    : SQLite
 Source Server Version : 3007010
 Source Database       : main

 Target Server Type    : SQLite
 Target Server Version : 3007010
 File Encoding         : utf-8

 Date: 03/06/2012 08:54:41 AM
*/

PRAGMA foreign_keys = false;

-- ----------------------------
--  Table structure for "DMI_COMPANY"
-- ----------------------------
DROP TABLE IF EXISTS "DMI_COMPANY";
CREATE TABLE DMI_COMPANY (

	dmiId INTEGER NOT NULL,

	companyId  INTEGER NOT NULL, 

	type  INTEGER NOT NULL,

	code_ref_labo VARCHAR(50),

	name_ref_labo VARCHAR(255),

  PRIMARY KEY (dmiId, companyId, type)

);

-- ----------------------------
--  Table structure for "DMI_LPP"
-- ----------------------------
DROP TABLE IF EXISTS "DMI_LPP";
CREATE TABLE DMI_LPP (

	dmiId INTEGER NOT NULL,

	lpprId INTEGER NOT NULL,

	nbLppr INTEGER,

  PRIMARY KEY (dmiId, lpprId)

);

-- ----------------------------
--  Table structure for "PRODUCTDMI"
-- ----------------------------
DROP TABLE IF EXISTS "PRODUCTDMI";
CREATE TABLE PRODUCTDMI (

  productDmiId INTEGER NOT NULL,

  name VARCHAR(255) NOT NULL,

  shortName VARCHAR(45) NOT NULL,

  componentComplement VARCHAR(45),

  formComplement VARCHAR(45),

  useComplement VARCHAR(45),

  ceClassName VARCHAR(32),

  cladimedClassificationId INTEGER ,

  sempClassId INTEGER DEFAULT NULL,

  PRIMARY KEY(productDmiId)

);

-- ----------------------------
--  Table structure for "accessoryRange"
-- ----------------------------
DROP TABLE IF EXISTS "accessoryRange";
CREATE TABLE accessoryRange (

  accessoryRangeId INTEGER NOT NULL,

  name TEXT NOT NULL,

  marketStatus INTEGER NOT NULL CHECK (marketStatus IN (0, 1,3,4)),

  best_doc_type TINYINT CHECK (best_doc_type IS NULL OR  best_doc_type = 4),

  PRIMARY KEY (accessoryRangeId)

);

-- ----------------------------
--  Table structure for "adaptedPosology"
-- ----------------------------
DROP TABLE IF EXISTS "adaptedPosology";
CREATE TABLE adaptedPosology (

  adaptedPosologyId INTEGER NOT NULL,

  rg INTEGER NOT NULL CHECK (rg > 0), -- FIXME Unused

  posologyId INTEGER NOT NULL,

  domain CHAR(2) NOT NULL CHECK (domain in ('IH', 'IR', 'SA')),

  calculMode INTEGER NOT NULL CHECK (calculMode IN (1, 2, 3, 4, 5, 8)),

  lowValue DOUBLE NOT NULL CHECK (lowValue >= 0),

  highValue DOUBLE NOT NULL CHECK (highValue == 0 OR highValue > lowValue),

  coeff DOUBLE NOT NULL CHECK (coeff >= 0),

  unitId INTEGER NOT NULL CHECK (unitId > 0),

  -- FIXME nunitmax = 0 => null

  nunitMax DOUBLE NOT NULL CHECK (nunitMax >= 0),

  divisi INTEGER CHECK (divisi IS NULL OR divisi IN (0, 1, 2, 3, 4, 5)),

  cont INTEGER NOT NULL CHECK (cont >= 0), -- FIXME Unused

  dosage DOUBLE NOT NULL CHECK (dosage >= 0),

  -- FIXME uniDos should not be null when dosage > 0

  uniDos CHAR(4) CHECK (uniDos IS NULL OR uniDos IN ('KU', 'MU', 'U', 'g', 'mcg', 'mg', 'ml', 'mmol')),

  posoMoy DOUBLE NOT NULL CHECK (posoMoy >= 0),

  pmType INTEGER NOT NULL CHECK (pmType IN (1, 2, 3, 4, 5)),

  -- FIXME mTher 0 => null, mther >= 1

  mTher DOUBLE NOT NULL CHECK (mTher >= 0),

  -- FIXME mTher2 = 0 => null, mther2 >= 1

  mTher2 DOUBLE NOT NULL CHECK (mTher2 >= 0 OR mther2 in (-1, -2, -3, -4)),

  posoMax DOUBLE NOT NULL CHECK (posoMax >= 0),

  -- FIXME pmaxType should not be null when posoMax > 0

  pMaxType INTEGER CHECK (pmaxType IS NULL OR pmaxType IN (1, 2, 3, 4, 5)),

  posoUnitMax DOUBLE NOT NULL CHECK (posoUnitMax >= 0),

  -- FIXME puMaxType should not be null when posoUnitMax > 0

  puMaxType INTEGER CHECK (puMaxType IS NULL OR puMaxType IN (1, 2, 3, 4, 5)),

  pmoyj CHAR(1) NOT NULL CHECK (pmoyj IN (0, 1)),

  freqAd INTEGER NOT NULL CHECK (freqAd >= 0),

  freqAd2 INTEGER NOT NULL CHECK (freqAd2 >= 0),

  freqAd3 INTEGER NOT NULL CHECK (freqAd3 >= 0),

  freqType CHAR(2) CHECK (freqType IS NULL OR freqType IN ('24', '2J', '44', '46', '66', 'AN', 'HE', 'HO', 'JO', 'ME', 'MI', 'NH', 'UN')),

  freqComp INTEGER NOT NULL CHECK (freqComp IN (0, 1)),

  comm TEXT,

  conseil TEXT, -- FIXME Unused

  info TEXT, -- FIXME Unused

  posoFixe TEXT,

  PRIMARY KEY (adaptedPosologyId),

  FOREIGN KEY (posologyId) REFERENCES posology(posologyId),

  FOREIGN KEY (unitId) REFERENCES posologyUnit(unitId)

);

-- ----------------------------
--  Table structure for "ald"
-- ----------------------------
DROP TABLE IF EXISTS "ald";
CREATE TABLE ald (

  aldId INTEGER NOT NULL,

  name TEXT NOT NULL,

  PRIMARY KEY (aldId)

);

-- ----------------------------
--  Table structure for "allergy"
-- ----------------------------
DROP TABLE IF EXISTS "allergy";
CREATE TABLE allergy ( -- FIXME allergyClass

  allergyId INTEGER NOT NULL,

  name TEXT NOT NULL,

  PRIMARY KEY (allergyId)

);

-- ----------------------------
--  Table structure for "allergy_hierarchy"
-- ----------------------------
DROP TABLE IF EXISTS "allergy_hierarchy";
CREATE TABLE allergy_hierarchy (

  parentId INTEGER NOT NULL,

  allergyId INTEGER NOT NULL,

  PRIMARY KEY (allergyId, parentId),

  FOREIGN KEY (allergyId) REFERENCES allergy(allergyId),

  FOREIGN KEY (parentId) REFERENCES allergy(allergyId)

);

-- ----------------------------
--  Table structure for "allergy_molecule"
-- ----------------------------
DROP TABLE IF EXISTS "allergy_molecule";
CREATE TABLE allergy_molecule (

  allergyId INTEGER NOT NULL,

  moleculeId INTEGER NOT NULL,

  PRIMARY KEY (allergyId,moleculeId),

  FOREIGN KEY (allergyId) REFERENCES allergy(allergyId),

  FOREIGN KEY (moleculeId) REFERENCES molecule(moleculeId)

);

-- ----------------------------
--  Table structure for "aratds"
-- ----------------------------
DROP TABLE IF EXISTS "aratds";
CREATE TABLE aratds (

  aratdsId INTEGER NOT NULL,

  atcCode TEXT,

  cnt SMALLINT,

  poids SMALLINT,

  condi_ap TEXT,

  dosage DOUBLE,

  unit TEXT,

  dosage_moy DOUBLE,

  pdd_moy DOUBLE,

  pdd_moy_unit TEXT,

  pdd_moy_time_unit DOUBLE,

  pdd_max DOUBLE,

  pdd_max_unit TEXT,

  pdd_max_time_unit DOUBLE,

  q_min DOUBLE,

  q_moy DOUBLE,

  q_max DOUBLE,

  route CHAR(1),

  PRIMARY KEY (aratdsId)

);

-- ----------------------------
--  Table structure for "asmr"
-- ----------------------------
DROP TABLE IF EXISTS "asmr";
CREATE TABLE asmr (

  asmrId INTEGER NOT NULL,

  productId INTEGER NOT NULL,

  degree SMALLINT NOT NULL CHECK (degree IN (1, 2, 3, 4, 5, 6)),

  comment TEXT NOT NULL,

  date DATE NOT NULL,

  url TEXT NOT NULL,

  PRIMARY KEY (asmrId),

  FOREIGN KEY (productId) REFERENCES product(productId)

);

-- ----------------------------
--  Table structure for "atcClass"
-- ----------------------------
DROP TABLE IF EXISTS "atcClass";
CREATE TABLE atcClass (

  atcClassId INTEGER NOT NULL,

  parentId INTEGER,

  name TEXT NOT NULL,

  code TEXT,

  PRIMARY KEY (atcClassId),

  FOREIGN KEY (parentId) REFERENCES atcClass(atcClassId)

);

-- ----------------------------
--  Table structure for "atc_ald"
-- ----------------------------
DROP TABLE IF EXISTS "atc_ald";
CREATE TABLE atc_ald (

  atcClassId INTEGER NOT NULL,

  aldId INTEGER NOT NULL,

  hasOpinion TEXT NOT NULL,

  PRIMARY KEY (atcClassId,aldId),

  FOREIGN KEY (atcClassId) REFERENCES atcClass(atcClassId),

  FOREIGN KEY (aldId) REFERENCES ald(aldId)

);

-- ----------------------------
--  Table structure for "baseColor"
-- ----------------------------
DROP TABLE IF EXISTS "baseColor";
CREATE TABLE baseColor (

  baseColorId INTEGER NOT NULL,

  name TEXT NOT NULL,

  PRIMARY KEY (baseColorId)

);

-- ----------------------------
--  Table structure for "ci_epp"
-- ----------------------------
DROP TABLE IF EXISTS "ci_epp";
CREATE TABLE ci_epp (

  contraIndicationId INTEGER NOT NULL,

  epp INTEGER NOT NULL CHECK (epp IN (1, 2, 3, 4, 5, 6)),

  min_value INTEGER NOT NULL,

  max_value INTEGER NOT NULL CHECK (max_value = 0 OR min_value < max_value),

  PRIMARY KEY (contraIndicationId,epp),

  FOREIGN KEY (contraIndicationId) REFERENCES contraindication(contraIndicationId)

);

-- ----------------------------
--  Table structure for "cim10"
-- ----------------------------
DROP TABLE IF EXISTS "cim10";
CREATE TABLE cim10 (

  cim10Id INTEGER NOT NULL,

  parentId INTEGER,

  code TEXT,

  name TEXT NOT NULL,

  PRIMARY KEY (cim10Id),

  FOREIGN KEY (parentId) REFERENCES cim10(cim10Id)

);

-- ----------------------------
--  Table structure for "cim10_contraindication"
-- ----------------------------
DROP TABLE IF EXISTS "cim10_contraindication";
CREATE TABLE cim10_contraindication (

  contraIndicationId INTEGER NOT NULL,

  cim10Id INTEGER NOT NULL,

  PRIMARY KEY (cim10Id,contraIndicationId),

  FOREIGN KEY (contraIndicationId) REFERENCES contraindication(contraIndicationId),

  FOREIGN KEY (cim10Id) REFERENCES cim10(cim10Id)

);

-- ----------------------------
--  Table structure for "cim10_indicationGroup"
-- ----------------------------
DROP TABLE IF EXISTS "cim10_indicationGroup";
CREATE TABLE cim10_indicationGroup (

  indicationGroupId INTEGER NOT NULL,

  cim10Id INTEGER NOT NULL,

  PRIMARY KEY (cim10Id,indicationGroupId),

  FOREIGN KEY (indicationGroupId) REFERENCES indicationGroup(indicationGroupId),

  FOREIGN KEY (cim10Id) REFERENCES cim10(cim10Id)

);

-- ----------------------------
--  Table structure for "cisp"
-- ----------------------------
DROP TABLE IF EXISTS "cisp";
CREATE TABLE cisp (

  cispId INTEGER NOT NULL,

  parentId INTEGER,

  code TEXT,

  name TEXT NOT NULL,

  PRIMARY KEY (cispId),

  FOREIGN KEY (parentId) REFERENCES cisp(cispId)

);

-- ----------------------------
--  Table structure for "cisp_indicationGroup"
-- ----------------------------
DROP TABLE IF EXISTS "cisp_indicationGroup";
CREATE TABLE cisp_indicationGroup (

  cispId INTEGER NOT NULL,

  indicationGroupId INTEGER NOT NULL,

  PRIMARY KEY (cispId,indicationGroupId),

  FOREIGN KEY (indicationGroupId) REFERENCES indicationGroup(indicationGroupId),

  FOREIGN KEY (cispId) REFERENCES cisp(cispId)

);

-- ----------------------------
--  Table structure for "cladimedClassification"
-- ----------------------------
DROP TABLE IF EXISTS "cladimedClassification";
CREATE TABLE cladimedClassification (

   cladimedClassificationId INTEGER NOT NULL,

   name VARCHAR(255) NOT NULL,

   code VARCHAR(7),

   parentId INTEGER,

  PRIMARY KEY (cladimedClassificationId)

);

-- ----------------------------
--  Table structure for "color"
-- ----------------------------
DROP TABLE IF EXISTS "color";
CREATE TABLE color (

  colorId INTEGER NOT NULL,

  name TEXT NOT NULL,

  PRIMARY KEY (colorId)

);

-- ----------------------------
--  Table structure for "color_baseColor"
-- ----------------------------
DROP TABLE IF EXISTS "color_baseColor";
CREATE TABLE color_baseColor (

  baseColorId INTEGER NOT NULL,

  colorId INTEGER NOT NULL,

  PRIMARY KEY (baseColorId,colorId),

  FOREIGN KEY (baseColorId) REFERENCES baseColor(baseColorId),

  FOREIGN KEY (colorId) REFERENCES color(colorId)

);

-- ----------------------------
--  Table structure for "commonNameGroup"
-- ----------------------------
DROP TABLE IF EXISTS "commonNameGroup";
CREATE TABLE commonNameGroup (

  commonNameGroupId INTEGER NOT NULL,

  name TEXT NOT NULL,

  notHomogeneousByIndications BOOLEAN NOT NULL CHECK (notHomogeneousByIndications IN (0, 1)),

  notHomogeneousByInteractions BOOLEAN NOT NULL CHECK (notHomogeneousByInteractions IN (0, 1)),

  galenicFormId INTEGER NOT NULL,

  drugInSport BOOLEAN NOT NULL CHECK (drugInSport IN (0, 1)),

  PRIMARY KEY (commonNameGroupId),

  FOREIGN KEY (galenicFormId) REFERENCES galenicForm(formId)

);

-- ----------------------------
--  Table structure for "commonNameGroup_composition"
-- ----------------------------
DROP TABLE IF EXISTS "commonNameGroup_composition";
CREATE TABLE commonNameGroup_composition(

  commonNameGroupId INTEGER NOT NULL,

  moleculeId INTEGER NOT NULL,

  perVolume  DECIMAL(16,5),

  perVolumeUnit TEXT,

  type SMALLINT NOT NULL CHECK (type IN (1, 2, 4)),

  PRIMARY KEY(commonNameGroupId, moleculeId)

  FOREIGN KEY (commonNameGroupId) REFERENCES commonNameGroup(commonNameGroupId),

  FOREIGN KEY (moleculeId) REFERENCES molecule(moleculeId)

);

-- ----------------------------
--  Table structure for "commonNameGroup_document"
-- ----------------------------
DROP TABLE IF EXISTS "commonNameGroup_document";
CREATE TABLE commonNameGroup_document (

  commonNameGroupId INTEGER NOT NULL,

  documentId INTEGER NOT NULL,

  PRIMARY KEY (commonNameGroupId, documentId)

  FOREIGN KEY (commonNameGroupId) REFERENCES commonNameGroup(commonNameGroupId),

  FOREIGN KEY (documentId) REFERENCES document(documentId)

);

-- ----------------------------
--  Table structure for "commonNameGroup_route"
-- ----------------------------
DROP TABLE IF EXISTS "commonNameGroup_route";
CREATE TABLE commonNameGroup_route (

  commonNameGroupId INTEGER NOT NULL,

  routeId INTEGER NOT NULL,

  PRIMARY KEY(commonNameGroupId, routeId)

  FOREIGN KEY (commonNameGroupId) REFERENCES commonNameGroup(commonNameGroupId),

  FOREIGN KEY (routeId) REFERENCES route(routeId)

);

-- ----------------------------
--  Table structure for "commonnamegroup_atc"
-- ----------------------------
DROP TABLE IF EXISTS "commonnamegroup_atc";
CREATE TABLE commonnamegroup_atc (

  atcClassId INTEGER NOT NULL,

  commonnamegroupId INTEGER NOT NULL,

  PRIMARY KEY (commonnamegroupId,atcClassId),

  FOREIGN KEY (atcClassId) REFERENCES atcClass(atcClassId),

  FOREIGN KEY (commonnamegroupId) REFERENCES commonNameGroup(commonNameGroupId)

);

-- ----------------------------
--  Table structure for "commonnamegroup_contraindication"
-- ----------------------------
DROP TABLE IF EXISTS "commonnamegroup_contraindication";
CREATE TABLE commonnamegroup_contraindication (

  contraIndicationId INTEGER NOT NULL,

  commonNameGroupId INTEGER NOT NULL,

  type SMALLINT NOT NULL CHECK (type IN (0, 1)),

  PRIMARY KEY (commonNameGroupId,contraIndicationId),

  FOREIGN KEY (contraIndicationId) REFERENCES contraindication(contraIndicationId),

  FOREIGN KEY (commonNameGroupId) REFERENCES commonNameGroup(commonNameGroupId)

);

-- ----------------------------
--  Table structure for "commonnamegroup_drugInteractionClass"
-- ----------------------------
DROP TABLE IF EXISTS "commonnamegroup_drugInteractionClass";
CREATE TABLE commonnamegroup_drugInteractionClass (

  drugInteractionClassId INTEGER NOT NULL,

  commonnamegroupId INTEGER NOT NULL,

  PRIMARY KEY (commonnamegroupId,drugInteractionClassId),

  FOREIGN KEY (drugInteractionClassId) REFERENCES drugInteractionClass(drugInteractionClassId),

  FOREIGN KEY (commonnamegroupId) REFERENCES commonNameGroup(commonNameGroupId)

);

-- ----------------------------
--  Table structure for "commonnamegroup_foodInteraction"
-- ----------------------------
DROP TABLE IF EXISTS "commonnamegroup_foodInteraction";
CREATE TABLE commonnamegroup_foodInteraction (

  commonnamegroupId INTEGER NOT NULL,

  foodInteractionId INTEGER NOT NULL,

  comment TEXT,

  PRIMARY KEY (commonnamegroupId,foodInteractionId),

  FOREIGN KEY (commonnamegroupId) REFERENCES commonNameGroup(commonNameGroupId),

  FOREIGN KEY (foodInteractionId) REFERENCES foodInteraction(foodInteractionId)

);

-- ----------------------------
--  Table structure for "commonnamegroup_indication"
-- ----------------------------
DROP TABLE IF EXISTS "commonnamegroup_indication";
CREATE TABLE commonnamegroup_indication (

  indicationId INTEGER NOT NULL,

  commonnamegroupId INTEGER NOT NULL,

  PRIMARY KEY (commonnamegroupId,indicationId),

  FOREIGN KEY (indicationId) REFERENCES indication(indicationId),

  FOREIGN KEY (commonnamegroupId) REFERENCES commonnamegroup(commonnamegroupId)

);

-- ----------------------------
--  Table structure for "commonnamegroup_physicoChemicalInteraction"
-- ----------------------------
DROP TABLE IF EXISTS "commonnamegroup_physicoChemicalInteraction";
CREATE TABLE commonnamegroup_physicoChemicalInteraction (

  commonnamegroupId INTEGER NOT NULL,

  physicoChemicalInteractionId INTEGER NOT NULL,

  comment TEXT,

  PRIMARY KEY (commonnamegroupId,physicoChemicalInteractionId),

  FOREIGN KEY (commonnamegroupId) REFERENCES commonNameGroup(commonNameGroupId),

  FOREIGN KEY (physicoChemicalInteractionId) REFERENCES physicoChemicalInteraction(physicoChemicalInteractionId)

);

-- ----------------------------
--  Table structure for "commonnamegroup_precaution"
-- ----------------------------
DROP TABLE IF EXISTS "commonnamegroup_precaution";
CREATE TABLE commonnamegroup_precaution (

  commonNameGroupId INTEGER NOT NULL,

  precautionId INTEGER NOT NULL,

  comment TEXT,

  PRIMARY KEY (commonNameGroupId,precautionId),

  FOREIGN KEY (commonNameGroupId) REFERENCES commonNameGroup(commonNameGroupId),

  FOREIGN KEY (precautionId) REFERENCES precaution(precautionId)

);

-- ----------------------------
--  Table structure for "commonnamegroup_redundant_molecule"
-- ----------------------------
DROP TABLE IF EXISTS "commonnamegroup_redundant_molecule";
CREATE TABLE commonnamegroup_redundant_molecule (

  commonNameGroupId INTEGER NOT NULL,

  moleculeId INTEGER NOT NULL,

  PRIMARY KEY (commonNameGroupId,moleculeId),

  FOREIGN KEY (moleculeId) REFERENCES molecule(moleculeId),

  FOREIGN KEY (commonNameGroupId) REFERENCES commonNameGroup(commonNameGroupId)

);

-- ----------------------------
--  Table structure for "commonnamegroup_sideEffect"
-- ----------------------------
DROP TABLE IF EXISTS "commonnamegroup_sideEffect";
CREATE TABLE commonnamegroup_sideEffect (

  commonnamegroupId INTEGER NOT NULL,

  sideEffectId INTEGER NOT NULL,

  frequency INTEGER CHECK (frequency IS NULL OR frequency IN (1, 2, 3, 4, 5, 6, 7, 8, 9)),

  sideEffectOrder INTEGER CHECK (sideEffectOrder > 0),

  PRIMARY KEY (commonnamegroupId,sideEffectId),

  FOREIGN KEY (commonnamegroupId) REFERENCES commonNameGroup(commonNameGroupId),

  FOREIGN KEY (sideEffectId) REFERENCES sideEffect(sideEffectId)

);

-- ----------------------------
--  Table structure for "commonnamegroup_surveillance"
-- ----------------------------
DROP TABLE IF EXISTS "commonnamegroup_surveillance";
CREATE TABLE commonnamegroup_surveillance (

  commonnamegroupId INTEGER NOT NULL,

  surveillanceId INTEGER NOT NULL,

  comment TEXT,

  PRIMARY KEY (commonnamegroupId,surveillanceId),

  FOREIGN KEY (commonnamegroupId) REFERENCES commonNameGroup(commonNameGroupId),

  FOREIGN KEY (surveillanceId) REFERENCES surveillance(surveillanceId)

);

-- ----------------------------
--  Table structure for "commonnamegroup_warning"
-- ----------------------------
DROP TABLE IF EXISTS "commonnamegroup_warning";
CREATE TABLE commonnamegroup_warning (

  commonnamegroupId INTEGER NOT NULL,

  warningId INTEGER NOT NULL,

  comment TEXT,

  PRIMARY KEY (commonnamegroupId,warningId),

  FOREIGN KEY (commonnamegroupId) REFERENCES commonNameGroup(commonNameGroupId),

  FOREIGN KEY (warningId) REFERENCES warning(warningId)

);

-- ----------------------------
--  Table structure for "company"
-- ----------------------------
DROP TABLE IF EXISTS "company";
CREATE TABLE company (

  companyId INTEGER NOT NULL,

  name TEXT NOT NULL,

  address TEXT NOT NULL,

  PRIMARY KEY (companyId)

);

-- ----------------------------
--  Table structure for "composition"
-- ----------------------------
DROP TABLE IF EXISTS "composition";
CREATE TABLE composition (

  compositionId INTEGER NOT NULL,

  itemId INTEGER NOT NULL,

  moleculeId INTEGER NOT NULL,

  perVolumeUnit TEXT,

  type SMALLINT NOT NULL CHECK (type IN (1, 2, 4)),

  perVolume DECIMAL(16,5) CHECK (perVolume IS NULL OR perVolumeUnit IS NOT NULL),

  PRIMARY KEY (compositionId),

  FOREIGN KEY (itemId) REFERENCES item(itemId),

  FOREIGN KEY (moleculeId) REFERENCES molecule(moleculeId)

);

-- ----------------------------
--  Table structure for "concentration"
-- ----------------------------
DROP TABLE IF EXISTS "concentration";
CREATE TABLE concentration(

  concentrationId INTEGER NOT NULL,

  ucdId INTEGER NOT NULL,

  itemId INTEGER NOT NULL,

  moleculeId INTEGER NULL,

  quantity DECIMAL(14,3) CHECK (quantity IS NULL OR quantityUnitId IS NOT NULL),

  quantityUnitId INTEGER NULL,

  activeSubstanceInformation DECIMAL(15,5) NULL,

  activeSubstanceInformationUnitId INTEGER NULL,

  PRIMARY KEY (concentrationId),

  FOREIGN KEY (itemId) REFERENCES item(itemId),

  FOREIGN KEY (moleculeId) REFERENCES molecule(moleculeId),

  FOREIGN KEY (quantityUnitId) REFERENCES posologyunit(unitId),

  FOREIGN KEY (activeSubstanceInformationUnitId) REFERENCES posologyunit(unitId)

);

-- ----------------------------
--  Table structure for "contraindication"
-- ----------------------------
DROP TABLE IF EXISTS "contraindication";
CREATE TABLE contraindication (

  contraIndicationId INTEGER NOT NULL,

  name TEXT NOT NULL,

  PRIMARY KEY (contraIndicationId)

);

-- ----------------------------
--  Table structure for "country"
-- ----------------------------
DROP TABLE IF EXISTS "country";
CREATE TABLE country (

  countryId INTEGER NOT NULL,

  regionId INTEGER NOT NULL,

  code CHAR(2) NOT NULL,

  name TEXT NOT NULL,

  enabled TEXT NOT NULL,

  PRIMARY KEY (countryId),

  FOREIGN KEY (regionId) REFERENCES region(regionId)

);

-- ----------------------------
--  Table structure for "dmi"
-- ----------------------------
DROP TABLE IF EXISTS "dmi";
CREATE TABLE dmi (

	dmiId INTEGER NOT NULL,

	productDmiId INTEGER ,

	name VARCHAR(255), 

	conditioning VARCHAR(50),

    vatRate  DECIMAL(8,2)  default  NULL,

	gtin VARCHAR(13),

	marketStatus INTEGER ,

	ceClassName VARCHAR(32),

	cladimedClassificationId INTEGER ,

	colorComplement VARCHAR(50),

	sizeComplement VARCHAR(50),

	isImplantable BOOLEAN NOT NULL DEFAULT 0,

	isSterile BOOLEAN NOT NULL DEFAULT 0,

	isTracable BOOLEAN NOT NULL DEFAULT 0,

	PRIMARY KEY(dmiId)

);

-- ----------------------------
--  Table structure for "document"
-- ----------------------------
DROP TABLE IF EXISTS "document";
CREATE TABLE document (

  documentId INTEGER NOT NULL,

  type INTEGER NOT NULL CHECK (type IN (1, 2, 4, 5, 6, 7, 30, 31, 32,33, 1002, 1003, 1004, 1005, 1006, 1007, 1008)),

  name TEXT NOT NULL,

  title TEXT NOT NULL,

  multi BOOLEAN NOT NULL CHECK (multi IN (0, 1)),

  PRIMARY KEY (documentId)

);

-- ----------------------------
--  Table structure for "document_image"
-- ----------------------------
DROP TABLE IF EXISTS "document_image";
CREATE TABLE document_image (

  imageId INTEGER NOT NULL,

  documentId INTEGER NOT NULL,

  PRIMARY KEY (documentId,imageId),

  FOREIGN KEY (imageId) REFERENCES image(imageId),

  FOREIGN KEY (documentId) REFERENCES document(documentId)

);

-- ----------------------------
--  Table structure for "domain"
-- ----------------------------
DROP TABLE IF EXISTS "domain";
CREATE TABLE domain (

  domainId INTEGER NOT NULL,

  name TEXT NOT NULL,

  type SMALLINT NOT NULL CHECK (type IN (1, 2)),

  PRIMARY KEY (domainId)

);

-- ----------------------------
--  Table structure for "drugInteractionClass"
-- ----------------------------
DROP TABLE IF EXISTS "drugInteractionClass";
CREATE TABLE drugInteractionClass (

  drugInteractionClassId INTEGER NOT NULL,

  name TEXT NOT NULL,

  PRIMARY KEY (drugInteractionClassId)

);

-- ----------------------------
--  Table structure for "ephmraClass"
-- ----------------------------
DROP TABLE IF EXISTS "ephmraClass";
CREATE TABLE ephmraClass (

  ephmraClassId INTEGER NOT NULL,

  parentId INTEGER,

  nom TEXT NOT NULL,

  code TEXT,

  PRIMARY KEY (ephmraClassId),

  FOREIGN KEY (parentId) REFERENCES ephmraClass(ephmraClassId)

);

-- ----------------------------
--  Table structure for "externallink"
-- ----------------------------
DROP TABLE IF EXISTS "externallink";
CREATE TABLE externallink (

  externalLinkId INTEGER NOT NULL,

  label TEXT,

  type INTEGER NOT NULL,

  ExternalId INTEGER,

  PRIMARY KEY  (externalLinkId)

);

-- ----------------------------
--  Table structure for "foodInteraction"
-- ----------------------------
DROP TABLE IF EXISTS "foodInteraction";
CREATE TABLE foodInteraction (

  foodInteractionId INTEGER NOT NULL,

  name TEXT NOT NULL,

  PRIMARY KEY (foodInteractionId)

);

-- ----------------------------
--  Table structure for "foreignProduct"
-- ----------------------------
DROP TABLE IF EXISTS "foreignProduct";
CREATE TABLE foreignProduct (

  foreignProductId INTEGER NOT NULL,

  formId INTEGER NOT NULL,

  countryId INTEGER NOT NULL,

  atcClassId INTEGER NOT NULL,

  name TEXT NOT NULL,

  PRIMARY KEY (foreignProductId),

  FOREIGN KEY (formId) REFERENCES galenicForm(formId),

  FOREIGN KEY (countryId) REFERENCES country(countryId),

  FOREIGN KEY (atcClassId) REFERENCES atcClass(atcClassId)

);

-- ----------------------------
--  Table structure for "foreignProduct_route"
-- ----------------------------
DROP TABLE IF EXISTS "foreignProduct_route";
CREATE TABLE foreignProduct_route (

  foreignProductId INTEGER NOT NULL,

  routeId INTEGER NOT NULL,

  PRIMARY KEY (foreignProductId,routeId),

  FOREIGN KEY (foreignProductId) REFERENCES foreignProduct(foreignProductId),

  FOREIGN KEY (routeId) REFERENCES route(routeId)

);

-- ----------------------------
--  Table structure for "galenicForm"
-- ----------------------------
DROP TABLE IF EXISTS "galenicForm";
CREATE TABLE galenicForm (

  formId INTEGER NOT NULL,

  parentId INTEGER,

  name TEXT NOT NULL,

  class TEXT NOT NULL,

  search BOOLEAN NOT NULL CHECK (search IN (0, 1)),

  shortName TEXT NOT NULL,

  PRIMARY KEY (formId),

  FOREIGN KEY (parentId) REFERENCES galenicForm(formId)

);

-- ----------------------------
--  Table structure for "genericGroup"
-- ----------------------------
DROP TABLE IF EXISTS "genericGroup";
CREATE TABLE genericGroup (

  genericGroupId INTEGER NOT NULL,

  name TEXT NOT NULL,

  een_code CHAR(1) NOT NULL CHECK (een_code IN (0, 1, 2)),

  PRIMARY KEY (genericGroupId)

);

-- ----------------------------
--  Table structure for "gi_lexiqueGi"
-- ----------------------------
DROP TABLE IF EXISTS "gi_lexiqueGi";
CREATE TABLE gi_lexiqueGi (

  indicationGroupId INTEGER NOT NULL,

  lexiqueId INTEGER NOT NULL,

  PRIMARY KEY (indicationGroupId,lexiqueId),

  FOREIGN KEY (indicationGroupId) REFERENCES indicationGroup(indicationGroupId),

  FOREIGN KEY (lexiqueId) REFERENCES lexiqueGi(lexiqueId)

);

-- ----------------------------
--  Table structure for "igLinked"
-- ----------------------------
DROP TABLE IF EXISTS "igLinked";
CREATE TABLE igLinked (

  indicationGroupId INTEGER NOT NULL,

  indicationGroupLinkedId INTEGER NOT NULL,

  PRIMARY KEY (indicationGroupId,indicationGroupLinkedId),

  FOREIGN KEY (indicationGroupId) REFERENCES indicationGroup(indicationGroupId),

  FOREIGN KEY (indicationGroupLinkedId) REFERENCES indicationGroup(indicationGroupId)

);

-- ----------------------------
--  Table structure for "image"
-- ----------------------------
DROP TABLE IF EXISTS "image";
CREATE TABLE image (

  imageId INTEGER NOT NULL,

  name TEXT NOT NULL,

  PRIMARY KEY (imageId)

);

-- ----------------------------
--  Table structure for "indication"
-- ----------------------------
DROP TABLE IF EXISTS "indication";
CREATE TABLE indication (

  indicationId INTEGER NOT NULL,

  name TEXT NOT NULL,

  PRIMARY KEY (indicationId)

);

-- ----------------------------
--  Table structure for "indicationGroup"
-- ----------------------------
DROP TABLE IF EXISTS "indicationGroup";
CREATE TABLE indicationGroup (

  indicationGroupId INTEGER NOT NULL,

  name TEXT NOT NULL,

  pathoLinked BOOLEAN NOT NULL CHECK (pathoLinked IN (0, 1)),

  recoLinked BOOLEAN NOT NULL CHECK (recoLinked IN (0, 1)),

  PRIMARY KEY (indicationGroupId)

);

-- ----------------------------
--  Table structure for "indicationGroup_indication"
-- ----------------------------
DROP TABLE IF EXISTS "indicationGroup_indication";
CREATE TABLE indicationGroup_indication (

  indicationGroupId INTEGER NOT NULL,

  indicationId INTEGER NOT NULL,

  PRIMARY KEY (indicationGroupId,indicationId),

  FOREIGN KEY (indicationGroupId) REFERENCES indicationGroup(indicationGroupId),

  FOREIGN KEY (indicationId) REFERENCES indication(indicationId)

);

-- ----------------------------
--  Table structure for "indicator"
-- ----------------------------
DROP TABLE IF EXISTS "indicator";
CREATE TABLE indicator(

	indicatorId int NOT NULL,

	indicator varchar(30) NOT NULL,

	PRIMARY KEY (indicatorId)

);

-- ----------------------------
--  Table structure for "interaction"
-- ----------------------------
DROP TABLE IF EXISTS "interaction";
CREATE TABLE interaction (

  interactionId INTEGER NOT NULL,

  drugInteractionClassId1 INTEGER NOT NULL,

  drugInteractionClassId2 INTEGER NOT NULL,

  riskComment TEXT NOT NULL,

  precautionComment TEXT,

  severity INTEGER NOT NULL CHECK (severity IN (10, 20, 30, 40)),

  PRIMARY KEY (interactionId,drugInteractionClassId1,drugInteractionClassId2),

  FOREIGN KEY (drugInteractionClassId1) REFERENCES drugInteractionClass(drugInteractionClassId),

  FOREIGN KEY (drugInteractionClassId2) REFERENCES drugInteractionClass(drugInteractionClassId)

);

-- ----------------------------
--  Table structure for "item"
-- ----------------------------
DROP TABLE IF EXISTS "item";
CREATE TABLE item (

  itemId INTEGER NOT NULL,

  productId INTEGER NOT NULL,

  name TEXT,

  reconstituted BOOLEAN NOT NULL CHECK (reconstituted IN (0, 1)),

  headername TEXT,

  PRIMARY KEY (itemId),

  FOREIGN KEY (productId) REFERENCES product(productId)

);

-- ----------------------------
--  Table structure for "item_color"
-- ----------------------------
DROP TABLE IF EXISTS "item_color";
CREATE TABLE item_color (

  itemId INTEGER NOT NULL,

  colorId INTEGER NOT NULL,

  PRIMARY KEY (itemId,colorId),

  FOREIGN KEY (itemId) REFERENCES item(itemId),

  FOREIGN KEY (colorId) REFERENCES color(colorId)

);

-- ----------------------------
--  Table structure for "lexiqueGi"
-- ----------------------------
DROP TABLE IF EXISTS "lexiqueGi";
CREATE TABLE lexiqueGi (

  lexiqueId INTEGER NOT NULL,

  name TEXT NOT NULL,

  PRIMARY KEY (lexiqueId)

);

-- ----------------------------
--  Table structure for "license"
-- ----------------------------
DROP TABLE IF EXISTS "license";
CREATE TABLE license (

  id INTEGER NOT NULL,

  date_jaune TEXT NOT NULL,

  date_orange TEXT NOT NULL,

  date_kill TEXT NOT NULL,

  year TEXT NOT NULL,

  version TEXT NOT NULL,

  product_line TEXT NOT NULL,

  can_register BOOLEAN NOT NULL CHECK (can_register IN (0, 1)),

  can_update BOOLEAN NOT NULL CHECK (can_update IN (0, 1)),

  dateExtractFront TEXT NOT NULL,

  dateExtractCD TEXT NOT NULL,

  PRIMARY KEY(id)

);

-- ----------------------------
--  Table structure for "lppr"
-- ----------------------------
DROP TABLE IF EXISTS "lppr";
CREATE TABLE lppr (

  lpprId INTEGER NOT NULL,

  code TEXT,

  name TEXT NOT NULL,

  refundBase DECIMAL(8,2),

  refundRate CHAR(1) CHECK (refundRate in ('T', NULL)),

  salePriceLimit DECIMAL(8,2),

  actCode TEXT,

  actCodeName TEXT,

  service CHAR(1) CHECK (service IN ('A', 'L', 'E', 'R', 'V', 'S', NULL)), 

  priorarrangement BOOLEAN,

  lppclassificationId INT,

  date DATE,

  ranking INT,

  PRIMARY KEY (lpprId)

);

-- ----------------------------
--  Table structure for "lpprRefundList"
-- ----------------------------
DROP TABLE IF EXISTS "lpprRefundList";
CREATE TABLE lpprRefundList (

  lpprRefundListId INTEGER NOT NULL,

  lpprId INTEGER NOT NULL,

  startDate DATE,

  refundBase  DECIMAL(10,2),

  transferPrice DECIMAL(10,2),

  salePriceLimit DECIMAL(10,2),

  referenceName VARCHAR(255),

  referenceDate DATE,

  referenceType VARCHAR(50),

  PRIMARY KEY (lpprRefundListId)

);

-- ----------------------------
--  Table structure for "lpprRegistrationCouple"
-- ----------------------------
DROP TABLE IF EXISTS "lpprRegistrationCouple";
CREATE TABLE lpprRegistrationCouple (

  lpprRegistrationCoupleId INTEGER NOT NULL,

  lpprId INTEGER NOT NULL,

  -- incription du LPP :

  startDate DATE,

  registrationName VARCHAR(255), -- N°NOR du JO

  registrationDate DATE, -- date du JO

  registrationType VARCHAR(50), -- JO

  -- suppression du LPP :

  endDate DATE,

  expiryName VARCHAR(255), -- N°NOR du JO

  expiryDate DATE, -- date du JO 

  expirySourceType VARCHAR(50), -- JO de suppression

  PRIMARY KEY (lpprRegistrationCoupleId)

);

-- ----------------------------
--  Table structure for "molecule"
-- ----------------------------
DROP TABLE IF EXISTS "molecule";
CREATE TABLE molecule (

  moleculeId INTEGER NOT NULL,

  name TEXT NOT NULL,

  homeopathy BOOLEAN NOT NULL CHECK (homeopathy IN (0, 1)),

  mediaVidalIndex BOOLEAN NOT NULL CHECK (mediaVidalIndex IN (0, 1)),

  allergenicMoleculeId INTEGER,

  allergyAlert BOOLEAN NOT NULL CHECK (allergyAlert IN (0, 1)),

  role INTEGER NOT NULL CHECK (role IN (0, 1, 2)),

  useInComposition BOOLEAN NOT NULL CHECK (useInComposition IN (0, 1)),

  pharmacologypropertyId INT,

  pharmacologypropertycomment TEXT,

  PRIMARY KEY (moleculeId),

  FOREIGN KEY (allergenicMoleculeId) REFERENCES molecule(moleculeId)

);

-- ----------------------------
--  Table structure for "moleculeSynonym"
-- ----------------------------
DROP TABLE IF EXISTS "moleculeSynonym";
CREATE TABLE moleculeSynonym (

  moleculeSynonymId INTEGER NOT NULL,

  name TEXT NOT NULL,

  PRIMARY KEY (moleculeSynonymId)

);

-- ----------------------------
--  Table structure for "molecule_externallink"
-- ----------------------------
DROP TABLE IF EXISTS "molecule_externallink";
CREATE TABLE molecule_externallink (
  moleculeId INTEGER NOT NULL,
  externalLinkId INTEGER NOT NULL,
  primary key(moleculeId, externalLinkId)
);

-- ----------------------------
--  Table structure for "molecule_hmk"
-- ----------------------------
DROP TABLE IF EXISTS "molecule_hmk";
CREATE TABLE molecule_hmk (
  moleculeId INTEGER NOT NULL,
  HMKId INTEGER NOT NULL,
  primary key(moleculeId, HMKId)
);

-- ----------------------------
--  Table structure for "molecule_molecule"
-- ----------------------------
DROP TABLE IF EXISTS "molecule_molecule";
CREATE TABLE molecule_molecule (

  moleculeId INTEGER NOT NULL,

  parentId INTEGER NOT NULL,

  PRIMARY KEY (moleculeId,parentId),

  FOREIGN KEY (moleculeId) REFERENCES molecule(moleculeId),

  FOREIGN KEY (parentId) REFERENCES molecule(moleculeId)

);

-- ----------------------------
--  Table structure for "molecule_moleculeSynonym"
-- ----------------------------
DROP TABLE IF EXISTS "molecule_moleculeSynonym";
CREATE TABLE molecule_moleculeSynonym (

  moleculeSynonymId INTEGER NOT NULL,

  moleculeId INTEGER NOT NULL,

  PRIMARY KEY (moleculeSynonymId,moleculeId),

  FOREIGN KEY (moleculeSynonymId) REFERENCES moleculeSynonym(moleculeSynonymId),

  FOREIGN KEY (moleculeId) REFERENCES molecule(moleculeId)

);

-- ----------------------------
--  Table structure for "package"
-- ----------------------------
DROP TABLE IF EXISTS "package";
CREATE TABLE package (

  packageId INTEGER NOT NULL,

  productId INTEGER NOT NULL,

  ucdId INTEGER,

  cip CHAR(7)  NULL,

  cip13 TEXT,

  cis TEXT,

  name TEXT NOT NULL,

  commercialName TEXT NOT NULL,

  shortName TEXT default NULL,

  marketStatus INTEGER NOT NULL CHECK (marketStatus IN (0, 1, 2, 3, 4, 5)),

  publicPrice DECIMAL(8,2) CHECK (publicPrice IS NULL OR typePrix IS NOT NULL),

  refundingBase DECIMAL(8,2),

  refundingRate CHAR(1) CHECK (refundingRate IS NULL OR refundingRate IN ('T', 'N', '2', '4', '7', '1')),

  manufacturerPrice DECIMAL(8,2),

  pharmacistPrice DECIMAL(8,2),

  vatRate  DECIMAL(8,2)  default  NULL,

  actCode TEXT,

  actCodeName TEXT,

  list CHAR(1) CHECK (list IS NULL OR list IN ('1', '2', 'S')),

  tfr BOOLEAN NOT NULL CHECK (tfr IN (0, 1)),

  dose TEXT CHECK (dose IS NULL OR doseUnit IS NOT NULL),

  doseUnit TEXT,

  pricePerDose DECIMAL(8,2) CHECK (pricePerDose IS NULL OR dose IS NOT NULL),

  communityAgrement BOOLEAN NOT NULL CHECK (communityAgrement IN (0, 1)),

  genericType CHAR(1) CHECK (genericType IS NULL OR genericType IN ('G', 'R')),

  accessoryRangeId INTEGER,

  image TEXT,

  typePrix INTEGER CHECK (typePrix IS NULL OR typePrix IN (5, 6, 7)),

  substitutePackageId INTEGER,

  narcoticPrescription BOOLEAN NOT NULL CHECK (narcoticPrescription IN (0, 1)),

  dispensationPlace INTEGER CHECK (dispensationPlace IS NULL OR dispensationPlace IN (8, 14)),

  maxPrescriptionDuration INTEGER CHECK (maxPrescriptionDuration IS NULL OR maxPrescriptionDuration IN (1, 2, 3, 5, 7, 8, 9)),

  ean TEXT,

  netWeight DECIMAL(10),

  netVolume DECIMAL(14, 4),

  sempCode TEXT default NULL,

  type SMALLINT NOT NULL CHECK (type IN (0, 2, 3, 4, 5, 6, 7, 8)),

  hasSafetyAlert BOOLEAN NOT NULL CHECK (hasSafetyAlert IN (0, 1)),

  ephmra BOOLEAN NOT NULL CHECK (ephmra IN (0, 1)),

  otc BOOLEAN NOT NULL CHECK (otc IN (0, 1)),

  withoutprescr BOOLEAN NOT NULL CHECK (withoutprescr IN (0, 1)),

  bestDocType TINYINT CHECK (bestDocType IS NULL OR bestDocType IN (1, 2, 4, 5, 6, 7,32)),

  ghs BOOLEAN NOT NULL CHECK (ghs IN(0,1)),

  PRIMARY KEY (packageId),

  FOREIGN KEY (productId) REFERENCES product(productId),

  FOREIGN KEY (ucdId) REFERENCES ucd(ucdId),

  FOREIGN KEY (accessoryRangeId) REFERENCES accessoryRange(accessoryRangeId),

  FOREIGN KEY (substitutePackageId) REFERENCES package(packageId)

);

-- ----------------------------
--  Table structure for "packageConservation"
-- ----------------------------
DROP TABLE IF EXISTS "packageConservation";
CREATE TABLE packageConservation (

  packageConservationId INTEGER NOT NULL,

  packageId INTEGER NOT NULL,

  unpacked BOOLEAN NOT NULL CHECK (unpacked IN (0, 1)),

  tmin INTEGER,

  tmax INTEGER CHECK (tmax >= tmin),

  conservationDuration INTEGER CHECK (conservationDuration IS NULL OR (conservationDuration > 0 AND conservationDurationUnit IS NOT NULL)),

  conservationDurationUnit INTEGER CHECK (conservationDurationUnit IS NULL OR conservationDurationUnit IN (22, 41, 44, 59, 62, 77)),

  PRIMARY KEY (packageConservationId),

  FOREIGN KEY (packageId) REFERENCES package(packageId)

);

-- ----------------------------
--  Table structure for "packagePriceScheduleList"
-- ----------------------------
DROP TABLE IF EXISTS "packagePriceScheduleList";
CREATE TABLE packagePriceScheduleList (

packagePriceScheduleListId INTEGER NOT NULL,

packageId INTEGER,

manufacturerPrice DECIMAL(10,2),

publicPrice DECIMAL(10,2),

refundBase DECIMAL(10,2),

vatRate  DECIMAL(8,2)  default  NULL,

startDate DATE,

endDate DATE,

referenceName VARCHAR(255),

referenceDate DATE,

referenceType VARCHAR(50),

PRIMARY KEY (packagePriceScheduleListId)

);

-- ----------------------------
--  Table structure for "packageRefundScheduleList"
-- ----------------------------
DROP TABLE IF EXISTS "packageRefundScheduleList";
CREATE TABLE packageRefundScheduleList (

packageRefundScheduleListId INTEGER NOT NULL,

packageId INTEGER,

refundRate CHAR(1),

actCode CHAR(3),

startDate DATE,

endDate DATE,

referenceName VARCHAR(255),

referenceDate DATE,

referenceType VARCHAR(50),

PRIMARY KEY (packageRefundScheduleListId)

);

-- ----------------------------
--  Table structure for "package_company"
-- ----------------------------
DROP TABLE IF EXISTS "package_company";
CREATE TABLE package_company (

  packageId INTEGER NOT NULL,

  companyId INTEGER NOT NULL,

  type INTEGER NOT NULL CHECK (type IN (1, 2, 3, 4, 5)),

  reference TEXT,

  PRIMARY KEY (packageId, companyId, type),

  FOREIGN KEY (packageId) REFERENCES package(packageId),

  FOREIGN KEY (companyId) REFERENCES company(companyId)

);

-- ----------------------------
--  Table structure for "package_document"
-- ----------------------------
DROP TABLE IF EXISTS "package_document";
CREATE TABLE package_document (

  packageId INTEGER NOT NULL,

  documentId INTEGER NOT NULL,

  anchor	TEXT NULL,

  PRIMARY KEY (packageId,documentId,anchor),

  FOREIGN KEY (packageId) REFERENCES package(packageId),

  FOREIGN KEY (documentId) REFERENCES document(documentId)

);

-- ----------------------------
--  Table structure for "package_ephmra"
-- ----------------------------
DROP TABLE IF EXISTS "package_ephmra";
CREATE TABLE package_ephmra (

  packageId INTEGER NOT NULL,

  ephmraClassId INTEGER NOT NULL,

  PRIMARY KEY (packageId,ephmraClassId),

  FOREIGN KEY (packageId) REFERENCES package(packageId),

  FOREIGN KEY (ephmraClassId) REFERENCES ephmraClass(ephmraClassId)

);

-- ----------------------------
--  Table structure for "package_indication"
-- ----------------------------
DROP TABLE IF EXISTS "package_indication";
CREATE TABLE package_indication (

  packageId INTEGER NOT NULL,

  indicationId INTEGER NOT NULL,

  refundRate CHAR(1) NOT NULL CHECK (refundRate IN ('2', '4', '7', '1')),

  PRIMARY KEY (packageId,indicationId),

  FOREIGN KEY (packageId) REFERENCES package(packageId),

  FOREIGN KEY (indicationId) REFERENCES indication(indicationId)

);

-- ----------------------------
--  Table structure for "package_lppr"
-- ----------------------------
DROP TABLE IF EXISTS "package_lppr";
CREATE TABLE package_lppr (

  packageId INTEGER NOT NULL,

  lpprId INTEGER NOT NULL,

  nbLppr INTEGER NOT NULL CHECK (nbLppr > 0),

  PRIMARY KEY (packageId,lpprId),

  FOREIGN KEY (packageId) REFERENCES package(packageId),

  FOREIGN KEY (lpprId) REFERENCES lppr(lpprId)

);

-- ----------------------------
--  Table structure for "package_wholeSaleDealer"
-- ----------------------------
DROP TABLE IF EXISTS "package_wholeSaleDealer";
CREATE TABLE package_wholeSaleDealer (

  packageId INTEGER NOT NULL,

  wholeSaleDealerId INTEGER NOT NULL,

  wholeSaleDealerPrice DECIMAL(8,2),

  codeVidal TEXT,

  internalCode TEXT,

  PRIMARY KEY (packageId,wholeSaleDealerId),

  FOREIGN KEY (packageId) REFERENCES package(packageId),

  FOREIGN KEY (wholeSaleDealerId) REFERENCES wholeSaleDealer(wholeSaleDealerId)

);

-- ----------------------------
--  Table structure for "pe_epp"
-- ----------------------------
DROP TABLE IF EXISTS "pe_epp";
CREATE TABLE pe_epp (

  precautionId INTEGER NOT NULL,

  epp INTEGER NOT NULL CHECK (epp IN (1, 2, 3, 4, 5, 6)),

  min_value INTEGER NOT NULL,

  max_value INTEGER NOT NULL CHECK (max_value = 0 OR min_value < max_value),

  PRIMARY KEY (precautionId,epp),

  FOREIGN KEY (precautionId) REFERENCES precaution(precautionId)

);

-- ----------------------------
--  Table structure for "physicoChemicalInteraction"
-- ----------------------------
DROP TABLE IF EXISTS "physicoChemicalInteraction";
CREATE TABLE physicoChemicalInteraction (

  physicoChemicalInteractionId INTEGER NOT NULL,

  name TEXT NOT NULL,

  PRIMARY KEY (physicoChemicalInteractionId)

);

-- ----------------------------
--  Table structure for "posology"
-- ----------------------------
DROP TABLE IF EXISTS "posology";
CREATE TABLE posology (

  posologyId INTEGER NOT NULL,

  productId INTEGER NOT NULL,

  rg INTEGER NOT NULL CHECK (rg > 0), -- FIXME Unused

  unitId INTEGER NOT NULL CHECK (unitId > 0),

  -- FIXME nunitmax = 0 => null

  nunitMax DOUBLE NOT NULL CHECK (nunitMax >= 0),

  divisi INTEGER CHECK (divisi IS NULL OR divisi IN (0, 1, 2, 3, 4, 5)),

  cont INTEGER NOT NULL CHECK (cont >= 0), -- FIXME Unused

  ageMin DOUBLE NOT NULL CHECK (ageMin >= 0),

  ageMax DOUBLE NOT NULL CHECK (ageMax > ageMin), -- FIXME DEFAULT 150

  sexe INTEGER CHECK (sexe IS NULL OR sexe IN (1, 2)),

  poidsMin INTEGER NOT NULL CHECK (poidsMin >= 0),

  poidsMax INTEGER NOT NULL CHECK (poidsMax > poidsMin), -- FIXME DEFAULT 500

  dosage DOUBLE NOT NULL CHECK (dosage >= 0),

  -- FIXME uniDos should not be null when dosage > 0

  uniDos CHAR(4) CHECK (uniDos IS NULL OR uniDos IN ('KU', 'MU', 'U', 'g', 'mcg', 'mg', 'ml', 'mmol')),

  posoMoy DOUBLE NOT NULL CHECK (posoMoy >= 0),

  pmType INTEGER NOT NULL CHECK (pmType IN (1, 2, 3, 4, 5)),

  -- FIXME mTher 0 => null, mther >= 1

  mTher DOUBLE NOT NULL CHECK (mTher >= 0),

  -- FIXME mTher2 = 0 => null, mther2 >= 1 or mther2 in (-1, -2, -3, -4)

  mTher2 DOUBLE NOT NULL CHECK (mTher2 >= 0 OR mther2 in (-1, -2, -3, -4)),

  posoMax DOUBLE NOT NULL CHECK (posoMax >= 0),

  -- FIXME pmaxType should not be null when posoMax > 0

  pmaxType INTEGER CHECK (pmaxType IS NULL OR pmaxType IN (1, 2, 3, 4, 5)),

  posoUnitMax DOUBLE NOT NULL CHECK (posoUnitMax >= 0),

  -- FIXME puMaxType should not be null when posoUnitMax > 0

  puMaxType INTEGER CHECK (puMaxType IS NULL OR puMaxType IN (1, 2, 3, 4, 5)),

  pmoyj INTEGER NOT NULL CHECK (pmoyj IN (0, 1)),

  freqAd INTEGER NOT NULL CHECK (freqAd >= 0), -- FIXME DEFAULT 1

  -- FIXME freqAd2 = 0 => null

  freqAd2 INTEGER NOT NULL CHECK (freqAd2 >= 0),

  -- FIXME freqAd3 should be null/0 when freqType <> 'NH'

  freqAd3 INTEGER NOT NULL CHECK (freqAd3 >= 0),

  -- FIXME freqType should not be null!!!

  freqType CHAR(2) CHECK (freqType IS NULL OR freqType IN ('24', '2J', '44', '46', '66', 'AN', 'HE', 'HO', 'JO', 'ME', 'MI', 'NH', 'UN')),

  freqComp INTEGER NOT NULL CHECK (freqComp IN (0, 1)),

  durAd INTEGER NOT NULL CHECK (durAd >= 0 AND durAd <= 100),

  durType CHAR(2) CHECK (durType IS NULL OR durType IN ('JO', 'MO', 'SE', 'HE', 'MI')),

  durComp INTEGER NOT NULL CHECK (durComp >= 0), -- FIXME Unused

  durAd2 INTEGER NOT NULL CHECK (durAd2 >= 0),

  durType2 CHAR(2) CHECK (durType2 IS NULL OR durType2 IN ('HE', 'JO', 'MI', 'MO', 'SE')),

  durAd3 INTEGER NOT NULL CHECK (durAd3 >= 0),

  durType3 CHAR(2) CHECK (durType3 IS NULL OR durType3 IN ('HE', 'JO', 'MI', 'MO', 'SE')),

  cumulMax DOUBLE NOT NULL CHECK (cumulMax >= 0),

  cmType INTEGER CHECK (cmType IS NULL OR cmType IN (1, 2, 3, 4, 5)),

  dureeMin INTEGER NOT NULL CHECK (dureeMin >= 0),

  dureeMin_Type CHAR(2) CHECK (dureeMin_Type IS NULL OR dureeMin_Type IN ('AN', 'JO', 'MI', 'MO', 'SE')),

  dureeUsuelleMin INTEGER NOT NULL CHECK (dureeUsuelleMin >= 0),

  dur_Us_Min_Type CHAR(2) CHECK (dur_Us_Min_Type IS NULL OR dur_Us_Min_Type IN ('AN', 'HE', 'JO', 'MI', 'MO', 'SE')),

  dureeMax INTEGER NOT NULL CHECK (dureeMax >= 0),

  dureeMax_Type CHAR(2) CHECK (dureeMax_Type IS NULL OR dureeMax_Type IN ('AN', 'HE', 'JO', 'MI', 'MO', 'SE')),

  dureeUsuelleMax INTEGER CHECK (dureeUsuelleMax >= 0),

  dur_Us_Max_Type CHAR(2) CHECK (dur_Us_Max_Type IS NULL OR dur_Us_Max_Type IN ('AN', 'HE', 'JO', 'MI', 'MO', 'SE')),

  phase CHAR(1) NOT NULL,

  posoFixe TEXT,

  ir INTEGER NOT NULL CHECK (ir IN (0, 1, 2, 3, 8, 9)),

  ih INTEGER NOT NULL CHECK (ih IN (0, 1, 2)),

  sa INTEGER NOT NULL CHECK (sa IN (0, 1, 2)),

  conditions TEXT,

  dest_ad BOOLEAN NOT NULL CHECK (dest_ad IN (0, 1)), -- FIXME Temporary

  dest_ge BOOLEAN NOT NULL CHECK (dest_ge IN (0, 1)),

  dest_je BOOLEAN NOT NULL CHECK (dest_je IN (0, 1)),

  dest_no BOOLEAN NOT NULL CHECK (dest_no IN (0, 1)),

  PRIMARY KEY (posologyId),

  FOREIGN KEY (productId) REFERENCES product(productId),

  FOREIGN KEY (unitId) REFERENCES posologyUnit(unitId),

  FOREIGN KEY (phase) REFERENCES posologyPhase(code)

);

-- ----------------------------
--  Table structure for "posologyAmm"
-- ----------------------------
DROP TABLE IF EXISTS "posologyAmm";
CREATE TABLE posologyAmm (

  productId INTEGER NOT NULL,

  posoamm TEXT,

  PRIMARY KEY (productId),

  FOREIGN KEY (productId) REFERENCES product (productId)

);

-- ----------------------------
--  Table structure for "posologyPhase"
-- ----------------------------
DROP TABLE IF EXISTS "posologyPhase";
CREATE TABLE posologyPhase (

  code CHAR(1) NOT NULL,

  name TEXT NOT NULL,

  PRIMARY KEY (code)

);

-- ----------------------------
--  Table structure for "posologyUnit"
-- ----------------------------
DROP TABLE IF EXISTS "posologyUnit";
CREATE TABLE posologyUnit (

  unitId INTEGER NOT NULL,

  unit TEXT NOT NULL,

  PRIMARY KEY (unitId)

);

-- ----------------------------
--  Table structure for "posology_indication"
-- ----------------------------
DROP TABLE IF EXISTS "posology_indication";
CREATE TABLE posology_indication (

  posologyId INTEGER NOT NULL,

  indicationId INTEGER NOT NULL,

  PRIMARY KEY (posologyId,indicationId),

  FOREIGN KEY (posologyId) REFERENCES posology(posologyId),

  FOREIGN KEY (indicationId) REFERENCES indication(indicationId)

);

-- ----------------------------
--  Table structure for "posology_route"
-- ----------------------------
DROP TABLE IF EXISTS "posology_route";
CREATE TABLE posology_route (

  posologyId INTEGER NOT NULL,

  routeId INTEGER NOT NULL,

  PRIMARY KEY (posologyId,routeId),

  FOREIGN KEY (posologyId) REFERENCES posology(posologyId),

  FOREIGN KEY (routeId) REFERENCES route(routeId)

);

-- ----------------------------
--  Table structure for "precaution"
-- ----------------------------
DROP TABLE IF EXISTS "precaution";
CREATE TABLE precaution (

  precautionId INTEGER NOT NULL,

  name TEXT NOT NULL,

  PRIMARY KEY (precautionId)

);

-- ----------------------------
--  Table structure for "precaution_pathology"
-- ----------------------------
DROP TABLE IF EXISTS "precaution_pathology";
CREATE TABLE precaution_pathology (

  precautionId INTEGER NOT NULL,

  cim10Id INTEGER NOT NULL,

  PRIMARY KEY (precautionId,cim10Id),

  FOREIGN KEY (precautionId) REFERENCES precaution(precautionId),

  FOREIGN KEY (cim10Id) REFERENCES cim10(cim10Id)

);

-- ----------------------------
--  Table structure for "prescriptionMode"
-- ----------------------------
DROP TABLE IF EXISTS "prescriptionMode";
CREATE TABLE prescriptionMode (

  prescriptionModeId INTEGER NOT NULL,

  prescribedByHospital BOOLEAN NOT NULL CHECK (prescribedByHospital IN (0, 1)),

  prescribedBySpecialist BOOLEAN NOT NULL CHECK (prescribedBySpecialist IN (0, 1)),

  initiallyPrescribedByHospital BOOLEAN NOT NULL CHECK (initiallyPrescribedByHospital IN (0, 1)),

  initiallyPrescribedBySpecialist BOOLEAN NOT NULL CHECK (initiallyPrescribedBySpecialist IN (0, 1)),

  deliveryRestrictedToHospital BOOLEAN NOT NULL CHECK (deliveryRestrictedToHospital IN (0, 1)),

  specificMonitoring BOOLEAN NOT NULL CHECK (specificMonitoring IN (0, 1)),

  renewalBySpecialist BOOLEAN NOT NULL CHECK (renewalBySpecialist IN (0, 1)),

  duration INTEGER CHECK (duration IS NULL OR (duration > 0 AND unit IS NOT NULL)),

  unit INTEGER CHECK (unit IS NULL OR unit IN (22, 44, 62, 77)),

  PRIMARY KEY (prescriptionModeId)

);

-- ----------------------------
--  Table structure for "preservationCaution"
-- ----------------------------
DROP TABLE IF EXISTS "preservationCaution";
CREATE TABLE preservationCaution (

  preservationCautionId INTEGER NOT NULL,

  packageConservationId INTEGER NOT NULL,

  libelle TEXT NOT NULL,

  PRIMARY KEY (preservationCautionId,packageConservationId),

  FOREIGN KEY (packageConservationId) REFERENCES packageConservation(packageConservationId)

);

-- ----------------------------
--  Table structure for "product"
-- ----------------------------
DROP TABLE IF EXISTS "product";
CREATE TABLE product (

  productId INTEGER NOT NULL,

  cis TEXT,

  name TEXT NOT NULL,

  shortName VARCHAR(45) not null,

  commercial_name TEXT NOT NULL,

  productRangeId INTEGER,

  type SMALLINT NOT NULL CHECK (type IN (0, 2, 3, 4, 5, 6, 7, 8)),

  genericType CHAR(1) CHECK (genericType IS NULL OR genericType IN ('G', 'R')),

  drugInSport BOOLEAN NOT NULL CHECK (drugInSport IN (0, 1)),

  commonNameGroupId INTEGER,

  perVolume TEXT,

  formId INTEGER,

  flavor TEXT,

  marketStatus INTEGER NOT NULL CHECK (marketStatus IN (0, 1, 2, 3, 4, 5)),

  companyId INTEGER,

  midwife BOOLEAN CHECK (midwife IN (0, 1)),

  ald BOOLEAN NOT NULL CHECK (ald IN (0, 1)),

  vigilanceId INTEGER CHECK (vigilanceId IS NULL OR vigilanceId IN (1, 2, 3, 4, 5)),

  exceptional BOOLEAN NOT NULL CHECK (exceptional IN (0, 1)),

  ammType TINYINT,

  surveillance BOOLEAN NOT NULL CHECK (surveillance IN (0, 1)),

  genericGroup BOOLEAN NOT NULL CHECK (genericGroup = 1 OR (genericGroup = 0 AND genericType IS NULL)),

  smr BOOLEAN NOT NULL CHECK (smr IN (0, 1)),

  semp BOOLEAN NOT NULL CHECK (semp IN (0, 1)),

  saumon BOOLEAN NOT NULL CHECK (saumon IN (0, 1)),

  vidal BOOLEAN NOT NULL CHECK (vidal IN (0, 1)),

  atc BOOLEAN NOT NULL CHECK (atc IN (0, 1)),

  withoutprescr BOOLEAN NOT NULL CHECK (withoutprescr IN (0, 1)),

  ard BOOLEAN NOT NULL CHECK (ard IN (0, 1)),

  prescriptionModeId INTEGER,

  ipc BOOLEAN NOT NULL CHECK (ipc IN (0, 1)),

  iam BOOLEAN NOT NULL CHECK (iam IN (0, 1)),

  best_doc_type TINYINT CHECK (best_doc_type IS NULL OR best_doc_type IN (1, 2, 4, 5, 6, 7,32)),

  commonNameGroup BOOLEAN NOT NULL CHECK (commonNameGroup = 0 OR (commonNameGroup = 1 AND commonNameGroupId IS NOT NULL)),

  list CHAR(1),

  refundingRate CHAR(1),

  beCarefull BOOLEAN NOT NULL CHECK (beCarefull IN (0, 1)),

  dispensationPlace INTEGER,

  hasSafetyAlert BOOLEAN NOT NULL CHECK (hasSafetyAlert IN (0, 1)),

  maxPrescriptionDuration INTEGER,

  narcoticPrescription BOOLEAN NOT NULL CHECK (narcoticPrescription IN (0, 1)),

  ghs BOOLEAN NOT NULL CHECK (ghs IN (0, 1)),

  retrocession BOOLEAN NOT NULL CHECK (retrocession IN (0, 1)),

  communityAgrement BOOLEAN NOT NULL CHECK (communityAgrement IN (0, 1)),

  documentId INTEGER,

  PRIMARY KEY (productId),

  FOREIGN KEY (commonNameGroupId) REFERENCES commonNameGroup(commonNameGroupId),

  FOREIGN KEY (formId) REFERENCES galenicForm(formId),

  FOREIGN KEY (companyId) REFERENCES company(companyId),

  FOREIGN KEY (prescriptionModeId) REFERENCES prescriptionMode(prescriptionModeId)

);

-- ----------------------------
--  Table structure for "productRange"
-- ----------------------------
DROP TABLE IF EXISTS "productRange";
CREATE TABLE productRange (

  productRangeId INTEGER NOT NULL,

  name TEXT NOT NULL,

  PRIMARY KEY(productRangeId)

);

-- ----------------------------
--  Table structure for "product_activePrinciple"
-- ----------------------------
DROP TABLE IF EXISTS "product_activePrinciple";
CREATE TABLE product_activePrinciple (

  moleculeId INTEGER NOT NULL,

  productId INTEGER NOT NULL,

  PRIMARY KEY (productId,moleculeId),

  FOREIGN KEY (moleculeId) REFERENCES molecule(moleculeId),

  FOREIGN KEY (productId) REFERENCES product(productId)

);

-- ----------------------------
--  Table structure for "product_atc"
-- ----------------------------
DROP TABLE IF EXISTS "product_atc";
CREATE TABLE product_atc (

  atcClassId INTEGER NOT NULL,

  productId INTEGER NOT NULL,

  PRIMARY KEY (productId,atcClassId),

  FOREIGN KEY (atcClassId) REFERENCES atcClass(atcClassId),

  FOREIGN KEY (productId) REFERENCES product(productId)

);

-- ----------------------------
--  Table structure for "product_contraindication"
-- ----------------------------
DROP TABLE IF EXISTS "product_contraindication";
CREATE TABLE product_contraindication (

  contraIndicationId INTEGER NOT NULL,

  productId INTEGER NOT NULL,

  type SMALLINT NOT NULL CHECK (type IN (0, 1)),

  PRIMARY KEY (productId,contraIndicationId),

  FOREIGN KEY (contraIndicationId) REFERENCES contraindication(contraIndicationId),

  FOREIGN KEY (productId) REFERENCES product(productId)

);

-- ----------------------------
--  Table structure for "product_drugInteractionClass"
-- ----------------------------
DROP TABLE IF EXISTS "product_drugInteractionClass";
CREATE TABLE product_drugInteractionClass (

  drugInteractionClassId INTEGER NOT NULL,

  productId INTEGER NOT NULL,

  PRIMARY KEY (productId,drugInteractionClassId),

  FOREIGN KEY (drugInteractionClassId) REFERENCES drugInteractionClass(drugInteractionClassId),

  FOREIGN KEY (productId) REFERENCES product(productId)

);

-- ----------------------------
--  Table structure for "product_een"
-- ----------------------------
DROP TABLE IF EXISTS "product_een";
CREATE TABLE product_een (

  moleculeId INTEGER NOT NULL,

  productId INTEGER NOT NULL,

  PRIMARY KEY (productId,moleculeId),

  FOREIGN KEY (moleculeId) REFERENCES molecule(moleculeId),

  FOREIGN KEY (productId) REFERENCES product(productId)

);

-- ----------------------------
--  Table structure for "product_foodInteraction"
-- ----------------------------
DROP TABLE IF EXISTS "product_foodInteraction";
CREATE TABLE product_foodInteraction (

  productId INTEGER NOT NULL,

  foodInteractionId INTEGER NOT NULL,

  comment TEXT,

  PRIMARY KEY (productId,foodInteractionId),

  FOREIGN KEY (productId) REFERENCES product(productId),

  FOREIGN KEY (foodInteractionId) REFERENCES foodInteraction(foodInteractionId)

);

-- ----------------------------
--  Table structure for "product_genericGroup"
-- ----------------------------
DROP TABLE IF EXISTS "product_genericGroup";
CREATE TABLE product_genericGroup (

  productId INTEGER NOT NULL,

  genericGroupId INTEGER NOT NULL,

  mainGroup BOOLEAN NOT NULL CHECK (mainGroup IN (0, 1)),

  PRIMARY KEY (productId,genericGroupId),

  FOREIGN KEY (productId) REFERENCES product(productId),

  FOREIGN KEY (genericGroupId) REFERENCES genericGroup(genericGroupId)

);

-- ----------------------------
--  Table structure for "product_indication"
-- ----------------------------
DROP TABLE IF EXISTS "product_indication";
CREATE TABLE product_indication (

  indicationId INTEGER NOT NULL,

  productId INTEGER NOT NULL,

  PRIMARY KEY (productId,indicationId),

  FOREIGN KEY (indicationId) REFERENCES indication(indicationId),

  FOREIGN KEY (productId) REFERENCES product(productId)

);

-- ----------------------------
--  Table structure for "product_indication_contraindication"
-- ----------------------------
DROP TABLE IF EXISTS "product_indication_contraindication";
CREATE TABLE product_indication_contraindication (

  productId INTEGER NOT NULL,

  indicationId INTEGER NOT NULL,

  contraindicationId INTEGER NOT NULL,

  PRIMARY KEY(productId, indicationId, contraindicationId)

  FOREIGN KEY (productId) REFERENCES product(productId),

  FOREIGN KEY (indicationId) REFERENCES indication(indicationId),

  FOREIGN KEY (contraindicationId) REFERENCES contraindication(contraIndicationId)

);

-- ----------------------------
--  Table structure for "product_molecule"
-- ----------------------------
DROP TABLE IF EXISTS "product_molecule";
CREATE TABLE product_molecule (

  moleculeId INTEGER NOT NULL,

  productId INTEGER NOT NULL,

  PRIMARY KEY (productId,moleculeId),

  FOREIGN KEY (moleculeId) REFERENCES molecule(moleculeId),

  FOREIGN KEY (productId) REFERENCES product(productId)

);

-- ----------------------------
--  Table structure for "product_physicoChemicalInteraction"
-- ----------------------------
DROP TABLE IF EXISTS "product_physicoChemicalInteraction";
CREATE TABLE product_physicoChemicalInteraction (

  productId INTEGER NOT NULL,

  physicoChemicalInteractionId INTEGER NOT NULL,

  comment TEXT,

  PRIMARY KEY (productId,physicoChemicalInteractionId),

  FOREIGN KEY (productId) REFERENCES product(productId),

  FOREIGN KEY (physicoChemicalInteractionId) REFERENCES physicoChemicalInteraction(physicoChemicalInteractionId)

);

-- ----------------------------
--  Table structure for "product_posologyunit"
-- ----------------------------
DROP TABLE IF EXISTS "product_posologyunit";
CREATE TABLE product_posologyunit (

  productId INTEGER NOT NULL,

  unitId INTEGER NOT NULL,

  PRIMARY KEY (productId,unitId)

  );

-- ----------------------------
--  Table structure for "product_precaution"
-- ----------------------------
DROP TABLE IF EXISTS "product_precaution";
CREATE TABLE product_precaution (

  productId INTEGER NOT NULL,

  precautionId INTEGER NOT NULL,

  comment TEXT,

  PRIMARY KEY (productId,precautionId),

  FOREIGN KEY (productId) REFERENCES product(productId),

  FOREIGN KEY (precautionId) REFERENCES precaution(precautionId)

);

-- ----------------------------
--  Table structure for "product_reco"
-- ----------------------------
DROP TABLE IF EXISTS "product_reco";
CREATE TABLE product_reco (

  productId INTEGER NOT NULL,

  recoId INTEGER NOT NULL,

  PRIMARY KEY (productId,recoId),

  FOREIGN KEY (productId) REFERENCES product(productId),

  FOREIGN KEY (recoId) REFERENCES reco(recoId)

);

-- ----------------------------
--  Table structure for "product_redundant_molecule"
-- ----------------------------
DROP TABLE IF EXISTS "product_redundant_molecule";
CREATE TABLE product_redundant_molecule (

  productId INTEGER NOT NULL,

  moleculeId INTEGER NOT NULL,

  PRIMARY KEY (productId,moleculeId),

  FOREIGN KEY (moleculeId) REFERENCES molecule(moleculeId),

  FOREIGN KEY (productId) REFERENCES product(productId)

);

-- ----------------------------
--  Table structure for "product_route"
-- ----------------------------
DROP TABLE IF EXISTS "product_route";
CREATE TABLE product_route (

  productId INTEGER NOT NULL,

  routeId INTEGER NOT NULL,

  PRIMARY KEY (productId,routeId),

  FOREIGN KEY (productId) REFERENCES product(productId),

  FOREIGN KEY (routeId) REFERENCES route(routeId)

);

-- ----------------------------
--  Table structure for "product_saumon"
-- ----------------------------
DROP TABLE IF EXISTS "product_saumon";
CREATE TABLE product_saumon (

  productId INTEGER NOT NULL,

  saumonClassId INTEGER NOT NULL,

  PRIMARY KEY (productId,saumonClassId),

  FOREIGN KEY (productId) REFERENCES product(productId),

  FOREIGN KEY (saumonClassId) REFERENCES saumonClass(saumonClassId)

);

-- ----------------------------
--  Table structure for "product_semp"
-- ----------------------------
DROP TABLE IF EXISTS "product_semp";
CREATE TABLE product_semp (

  productId INTEGER NOT NULL,

  sempClassId INTEGER NOT NULL,

  PRIMARY KEY (productId,sempClassId),

  FOREIGN KEY (productId) REFERENCES product(productId),

  FOREIGN KEY (sempClassId) REFERENCES sempClass(sempClassId)

);

-- ----------------------------
--  Table structure for "product_sideEffect"
-- ----------------------------
DROP TABLE IF EXISTS "product_sideEffect";
CREATE TABLE product_sideEffect (

  productId INTEGER NOT NULL,

  sideEffectId INTEGER NOT NULL,

  frequency INTEGER CHECK (frequency IS NULL OR frequency IN (1, 2, 3, 4, 5, 6, 7, 8, 9)),

  sideEffectOrder INTEGER CHECK (sideEffectOrder > 0),

  PRIMARY KEY (productId,sideEffectId),

  FOREIGN KEY (productId) REFERENCES product(productId),

  FOREIGN KEY (sideEffectId) REFERENCES sideEffect(sideEffectId)

);

-- ----------------------------
--  Table structure for "product_specialist"
-- ----------------------------
DROP TABLE IF EXISTS "product_specialist";
CREATE TABLE product_specialist (

  productId INTEGER NOT NULL,

  specialistId INTEGER NOT NULL,

  PRIMARY KEY (productId,specialistId),

  FOREIGN KEY (productId) REFERENCES product(productId),

  FOREIGN KEY (specialistId) REFERENCES specialist(specialistId)

);

-- ----------------------------
--  Table structure for "product_specialistCenter"
-- ----------------------------
DROP TABLE IF EXISTS "product_specialistCenter";
CREATE TABLE product_specialistCenter (

  productId INTEGER NOT NULL,

  specialistCenterId INTEGER NOT NULL,

  PRIMARY KEY (productId,specialistCenterId),

  FOREIGN KEY (productId) REFERENCES product(productId),

  FOREIGN KEY (specialistCenterId) REFERENCES specialistCenter(specialistCenterId)

);

-- ----------------------------
--  Table structure for "product_specialistrenewal"
-- ----------------------------
DROP TABLE IF EXISTS "product_specialistrenewal";
CREATE TABLE product_specialistrenewal (

  productId INTEGER NOT NULL,

  specialistId INTEGER NOT NULL,

  PRIMARY KEY (productId,specialistId),

  FOREIGN KEY (productId) REFERENCES product(productId),

  FOREIGN KEY (specialistId) REFERENCES specialist(specialistId)

);

-- ----------------------------
--  Table structure for "product_surveillance"
-- ----------------------------
DROP TABLE IF EXISTS "product_surveillance";
CREATE TABLE product_surveillance (

  productId INTEGER NOT NULL,

  surveillanceId INTEGER NOT NULL,

  comment TEXT,

  PRIMARY KEY (productId,surveillanceId),

  FOREIGN KEY (productId) REFERENCES product(productId),

  FOREIGN KEY (surveillanceId) REFERENCES surveillance(surveillanceId)

);

-- ----------------------------
--  Table structure for "product_toxin"
-- ----------------------------
DROP TABLE IF EXISTS "product_toxin";
CREATE TABLE product_toxin (

  productId INTEGER NOT NULL,

  toxinId INTEGER NOT NULL,

  PRIMARY KEY (productId,toxinId),

  FOREIGN KEY (productId) REFERENCES product(productId),

  FOREIGN KEY (toxinId) REFERENCES toxin(toxinId)

);

-- ----------------------------
--  Table structure for "product_ucd"
-- ----------------------------
DROP TABLE IF EXISTS "product_ucd";
CREATE TABLE product_ucd (

  ucdId INTEGER NOT NULL,

  productId INTEGER NOT NULL,

  PRIMARY KEY (productId,ucdId),

  FOREIGN KEY (productId) REFERENCES product(productId),

  FOREIGN KEY (ucdId) REFERENCES ucd(ucdId)

);

-- ----------------------------
--  Table structure for "product_vidal"
-- ----------------------------
DROP TABLE IF EXISTS "product_vidal";
CREATE TABLE product_vidal (

  productId INTEGER NOT NULL,

  vidalClassId INTEGER NOT NULL,

  PRIMARY KEY (productId,vidalClassId),

  FOREIGN KEY (productId) REFERENCES product(productId),

  FOREIGN KEY (vidalClassId) REFERENCES vidalClass(vidalClassId)

);

-- ----------------------------
--  Table structure for "product_warning"
-- ----------------------------
DROP TABLE IF EXISTS "product_warning";
CREATE TABLE product_warning (

  productId INTEGER NOT NULL,

  warningId INTEGER NOT NULL,

  comment TEXT,

  PRIMARY KEY (productId,warningId),

  FOREIGN KEY (productId) REFERENCES product(productId),

  FOREIGN KEY (warningId) REFERENCES warning(warningId)

);

-- ----------------------------
--  Table structure for "reco"
-- ----------------------------
DROP TABLE IF EXISTS "reco";
CREATE TABLE reco (

  recoId INTEGER NOT NULL,

  name TEXT NOT NULL,

  PRIMARY KEY (recoId)

);

-- ----------------------------
--  Table structure for "reco_domain"
-- ----------------------------
DROP TABLE IF EXISTS "reco_domain";
CREATE TABLE reco_domain (

  recoId INTEGER NOT NULL,

  domainId INTEGER NOT NULL,

  PRIMARY KEY (recoId,domainId),

  FOREIGN KEY (recoId) REFERENCES reco(recoId),

  FOREIGN KEY (domainId) REFERENCES domain(domainId)

);

-- ----------------------------
--  Table structure for "reco_indicationGroup"
-- ----------------------------
DROP TABLE IF EXISTS "reco_indicationGroup";
CREATE TABLE reco_indicationGroup (

  recoId INTEGER NOT NULL,

  indicationGroupId INTEGER NOT NULL,

  PRIMARY KEY (recoId,indicationGroupId),

  FOREIGN KEY (recoId) REFERENCES reco(recoId),

  FOREIGN KEY (indicationGroupId) REFERENCES indicationGroup(indicationGroupId)

);

-- ----------------------------
--  Table structure for "region"
-- ----------------------------
DROP TABLE IF EXISTS "region";
CREATE TABLE region (

  regionId INTEGER NOT NULL,

  name TEXT NOT NULL,

  PRIMARY KEY (regionId)

);

-- ----------------------------
--  Table structure for "route"
-- ----------------------------
DROP TABLE IF EXISTS "route";
CREATE TABLE route (

  routeId INTEGER NOT NULL,

  parentId INTEGER,

  name TEXT NOT NULL,

  atc CHAR(1),

  PRIMARY KEY (routeId),

  FOREIGN KEY (parentId) REFERENCES route(routeId)

);

-- ----------------------------
--  Table structure for "saumonClass"
-- ----------------------------
DROP TABLE IF EXISTS "saumonClass";
CREATE TABLE saumonClass (

  saumonClassId INTEGER NOT NULL,

  parentId INTEGER,

  name TEXT NOT NULL,

  PRIMARY KEY (saumonClassId),

  FOREIGN KEY (parentId) REFERENCES saumonClass(saumonClassId)

);

-- ----------------------------
--  Table structure for "saumon_indicationGroup"
-- ----------------------------
DROP TABLE IF EXISTS "saumon_indicationGroup";
CREATE TABLE saumon_indicationGroup (

  indicationGroupId INTEGER NOT NULL,

  saumonClassId INTEGER NOT NULL,

  PRIMARY KEY (indicationGroupId,saumonClassId),

  FOREIGN KEY (indicationGroupId) REFERENCES indicationGroup(indicationGroupId),

  FOREIGN KEY (saumonClassId) REFERENCES saumonClass(saumonClassId)

);

-- ----------------------------
--  Table structure for "sempClass"
-- ----------------------------
DROP TABLE IF EXISTS "sempClass";
CREATE TABLE sempClass (

  sempClassId INTEGER NOT NULL,

  parentId INTEGER,

  name TEXT NOT NULL,

  code TEXT,

  PRIMARY KEY (sempClassId),

  FOREIGN KEY (parentId) REFERENCES sempClass(sempClassId)

);

-- ----------------------------
--  Table structure for "sfmg"
-- ----------------------------
DROP TABLE IF EXISTS "sfmg";
CREATE TABLE sfmg (

  sfmgId INTEGER NOT NULL,

  code TEXT,

  name TEXT NOT NULL,

  PRIMARY KEY (sfmgId)

);

-- ----------------------------
--  Table structure for "sfmg_contraindication"
-- ----------------------------
DROP TABLE IF EXISTS "sfmg_contraindication";
CREATE TABLE sfmg_contraindication (

  sfmgId INTEGER NOT NULL,

  contraIndicationId INTEGER NOT NULL,

  PRIMARY KEY (sfmgId,contraIndicationId),

  FOREIGN KEY (sfmgId) REFERENCES sfmg(sfmgId),

  FOREIGN KEY (contraIndicationId) REFERENCES contraindication(contraIndicationId)

);

-- ----------------------------
--  Table structure for "sfmg_indicationGroup"
-- ----------------------------
DROP TABLE IF EXISTS "sfmg_indicationGroup";
CREATE TABLE sfmg_indicationGroup (

  sfmgId INTEGER NOT NULL,

  indicationGroupId INTEGER NOT NULL,

  PRIMARY KEY (sfmgId,indicationGroupId),

  FOREIGN KEY (sfmgId) REFERENCES sfmg(sfmgId),

  FOREIGN KEY (indicationGroupId) REFERENCES indicationGroup(indicationGroupId)

);

-- ----------------------------
--  Table structure for "sideEffect"
-- ----------------------------
DROP TABLE IF EXISTS "sideEffect";
CREATE TABLE sideEffect (

  sideEffectId INTEGER NOT NULL,

  apparatusId INTEGER,

  name TEXT NOT NULL,

  PRIMARY KEY (sideEffectId),

  FOREIGN KEY (apparatusId) REFERENCES sideEffect(sideEffectId)

);

-- ----------------------------
--  Table structure for "smr"
-- ----------------------------
DROP TABLE IF EXISTS "smr";
CREATE TABLE smr (

  smrId INTEGER NOT NULL,

  productId INTEGER NOT NULL,

  degree SMALLINT NOT NULL CHECK (degree IN (0, 1, 2, 3, 4, 5)),

  comment TEXT NOT NULL,

  date DATE NOT NULL,

  url TEXT NOT NULL,

  PRIMARY KEY (smrId),

  FOREIGN KEY (productId) REFERENCES product(productId)

);

-- ----------------------------
--  Table structure for "smr_asmr"
-- ----------------------------
DROP TABLE IF EXISTS "smr_asmr";
CREATE TABLE smr_asmr (

  smrId INTEGER NOT NULL,

  asmrId INTEGER NOT NULL,

  PRIMARY KEY (smrId,asmrId),

  FOREIGN KEY (smrId) REFERENCES smr(smrId),

  FOREIGN KEY (asmrId) REFERENCES asmr(asmrId)

);

-- ----------------------------
--  Table structure for "specialist"
-- ----------------------------
DROP TABLE IF EXISTS "specialist";
CREATE TABLE specialist (

  specialistId INTEGER NOT NULL,

  name TEXT NOT NULL,

  code varchar(10),

  PRIMARY KEY(specialistId)

);

-- ----------------------------
--  Table structure for "specialistCenter"
-- ----------------------------
DROP TABLE IF EXISTS "specialistCenter";
CREATE TABLE specialistCenter (

  specialistCenterId INTEGER NOT NULL,

  name TEXT NOT NULL,

  PRIMARY KEY(specialistCenterId)

);

-- ----------------------------
--  Table structure for "surveillance"
-- ----------------------------
DROP TABLE IF EXISTS "surveillance";
CREATE TABLE surveillance (

  surveillanceId INTEGER NOT NULL,

  name TEXT NOT NULL,

  PRIMARY KEY (surveillanceId)

);

-- ----------------------------
--  Table structure for "toxin"
-- ----------------------------
DROP TABLE IF EXISTS "toxin";
CREATE TABLE toxin (

  toxinId INTEGER NOT NULL,

  name TEXT NOT NULL,

  path TEXT NOT NULL,

  PRIMARY KEY (toxinId)

);

-- ----------------------------
--  Table structure for "ucd"
-- ----------------------------
DROP TABLE IF EXISTS "ucd";
CREATE TABLE ucd (

  ucdId INTEGER NOT NULL,

  code CHAR(7) NOT NULL,

  code13 CHAR(13) NOT NULL,

  name TEXT NOT NULL,

  commercial_name TEXT NOT NULL,

  refundingRate int,

  ghs BOOLEAN NOT NULL CHECK (ghs IN (0, 1)),

  retrocession BOOLEAN NOT NULL CHECK (retrocession IN (0, 1)),

  ghsPrice DECIMAL(8,3) CHECK (ghsPrice IS NULL OR ghs = 1),

  retrocessionPrice DECIMAL(8,3) CHECK (retrocessionPrice IS NULL OR retrocession = 1),

  ghsEffectiveDate DATE default NULL,

  retrocessionEffectiveDate DATE default NULL,

  marketStatus TINYINT NOT NULL CHECK (marketStatus IN (0, 1, 2, 3, 4, 5)),

  best_doc_type TINYINT CHECK (best_doc_type IS NULL OR best_doc_type IN (1, 2, 4, 5, 6, 7,32)),

  hasSafetyAlert BOOLEAN NOT NULL CHECK (hasSafetyAlert IN (0, 1)),

  PRIMARY KEY (ucdId)

);

-- ----------------------------
--  Table structure for "ucd_indicator"
-- ----------------------------
DROP TABLE IF EXISTS "ucd_indicator";
CREATE TABLE ucd_indicator(

  ucdId INTEGER NOT NULL,

  indicatorId INTEGER NOT NULL,

  PRIMARY KEY (ucdId, indicatorId),

  FOREIGN KEY (ucdId) REFERENCES ucd(ucdId)

);

-- ----------------------------
--  Table structure for "ucd_posologyunit"
-- ----------------------------
DROP TABLE IF EXISTS "ucd_posologyunit";
CREATE TABLE ucd_posologyunit (

  ucdId INTEGER NOT NULL,

  unitId INTEGER NOT NULL,

  dispensingUnitId INTEGER  NULL,

  ucdItemVolume DECIMAL(14,3)  NULL,

  ucdItemVolumeUnitId INTEGER  NULL,

  ucdItemQuantity DECIMAL(14,3)  NULL,

  ucdItemQuantityUnitId INTEGER NULL, 

  ratioOfPosologyUnitOverDispensingUnit DECIMAL(15,5) NULL,

  PRIMARY KEY (ucdId,unitId),

  FOREIGN KEY (unitId) REFERENCES posologyunit(unitId),

  FOREIGN KEY (dispensingUnitId) REFERENCES posologyunit(unitId),

  FOREIGN KEY (ucdItemQuantityUnitId) REFERENCES posologyunit(unitId),

  FOREIGN KEY (ucdItemVolumeUnitId) REFERENCES posologyunit(unitId)

);

-- ----------------------------
--  Table structure for "vidalClass"
-- ----------------------------
DROP TABLE IF EXISTS "vidalClass";
CREATE TABLE vidalClass (

  vidalClassId INTEGER NOT NULL,

  parentId INTEGER,

  name TEXT NOT NULL,

  PRIMARY KEY (vidalClassId),

  FOREIGN KEY (parentId) REFERENCES vidalClass(vidalClassId)

);

-- ----------------------------
--  Table structure for "warning"
-- ----------------------------
DROP TABLE IF EXISTS "warning";
CREATE TABLE warning (

  warningId INTEGER NOT NULL,

  name TEXT NOT NULL,

  PRIMARY KEY (warningId)

);

-- ----------------------------
--  Table structure for "warning_epp"
-- ----------------------------
DROP TABLE IF EXISTS "warning_epp";
CREATE TABLE warning_epp (

  id INTEGER NOT NULL, 

  warningId INTEGER NOT NULL,

  epp INTEGER NOT NULL CHECK (epp IN (1, 2, 3, 4, 5, 6)),

  min_value INTEGER NOT NULL,

  max_value INTEGER NOT NULL CHECK (max_value = 0 OR min_value < max_value),

  PRIMARY KEY (id),

  FOREIGN KEY (warningId) REFERENCES warning(warningId)

);

-- ----------------------------
--  Table structure for "wholeSaleDealer"
-- ----------------------------
DROP TABLE IF EXISTS "wholeSaleDealer";
CREATE TABLE wholeSaleDealer (

  wholeSaleDealerId INTEGER NOT NULL,

  name TEXT NOT NULL,

  codeVidal TEXT NOT NULL,

  PRIMARY KEY (wholeSaleDealerId)

);

PRAGMA foreign_keys = true;
