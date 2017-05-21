/* -----------------------------------------------------------------------------
TABRAJO FINAL
ADMINISTRACION DE BASE DE DATOS AVANZADA
NOMBRES: ANDRES ALBANES
         ANDRES ARISTIZABAL
         LINA CASTAÑEDA
 -----------------------------------------------------------------------------*/
 -- Creación de usuarios roles y tablespace
 CREATE TABLESPACE vehicles_fleet DATAFILE 
'D:\ORACLE\DATAFILE\vehicles_fleet1.dbf' SIZE 500M,
'D:\ORACLE\DATAFILE\vehicles_fleet2.dbf' SIZE 500M
AUTOEXTEND ON NEXT 500k MAXSIZE 1000M 
EXTENT MANAGEMENT LOCAL 
SEGMENT SPACE MANAGEMENT AUTO ONLINE;

CREATE TABLESPACE test_purposes DATAFILE 
'D:\ORACLE\DATAFILE\test_purposes1.dbf' SIZE 500M
AUTOEXTEND ON NEXT 500k MAXSIZE 2000M 
EXTENT MANAGEMENT LOCAL 
SEGMENT SPACE MANAGEMENT AUTO ONLINE;

CREATE USER AdminUser IDENTIFIED BY "AdminUser23" 
DEFAULT TABLESPACE vehicles_fleet QUOTA UNLIMITED ON vehicles_fleet;

GRANT CONNECT, RESOURCE TO DBA; 
GRANT DBA TO AdminUser;

CREATE PROFILE AdminProfile LIMIT PASSWORD_REUSE_MAX 10 PASSWORD_REUSE_TIME 30;
CREATE PROFILE DeveloperProfile LIMIT PASSWORD_REUSE_MAX 10 PASSWORD_REUSE_TIME 30;
CREATE PROFILE TestProfile LIMIT PASSWORD_REUSE_MAX 10 PASSWORD_REUSE_TIME 30;

CREATE PROFILE manager_profile LIMIT 
   SESSIONS_PER_USER           1 
   CPU_PER_SESSION             UNLIMITED 
   CPU_PER_CALL                UNLIMITED 
   CONNECT_TIME                240 
   IDLE_TIME                   15
   PRIVATE_SGA                 15K
   FAILED_LOGIN_ATTEMPTS       4
   PASSWORD_LIFE_TIME          40
   PASSWORD_REUSE_TIME         12
   PASSWORD_REUSE_MAX          5
   PASSWORD_LOCK_TIME          1
   PASSWORD_GRACE_TIME         2; 
   
CREATE PROFILE finance_profile LIMIT 
   SESSIONS_PER_USER           1 
   CPU_PER_SESSION             UNLIMITED 
   CPU_PER_CALL                UNLIMITED 
   CONNECT_TIME                240 
   IDLE_TIME                   5
   PRIVATE_SGA                 15K
   FAILED_LOGIN_ATTEMPTS       2
   PASSWORD_LIFE_TIME          15
   PASSWORD_REUSE_TIME         12
   PASSWORD_REUSE_MAX          5
   PASSWORD_LOCK_TIME          1
   PASSWORD_GRACE_TIME         2; 
   
CREATE PROFILE service_profile LIMIT 
   SESSIONS_PER_USER           1 
   CPU_PER_SESSION             UNLIMITED 
   CPU_PER_CALL                UNLIMITED 
   CONNECT_TIME                240 
   IDLE_TIME                   10
   PRIVATE_SGA                 15K
   FAILED_LOGIN_ATTEMPTS       3
   PASSWORD_LIFE_TIME          20
   PASSWORD_REUSE_TIME         12
   PASSWORD_REUSE_MAX          5
   PASSWORD_LOCK_TIME          1
   PASSWORD_GRACE_TIME         2; 
   
CREATE PROFILE development LIMIT 
   SESSIONS_PER_USER           2 
   CPU_PER_SESSION             UNLIMITED 
   CPU_PER_CALL                UNLIMITED 
   CONNECT_TIME                240 
   IDLE_TIME                   30
   PRIVATE_SGA                 15K
   FAILED_LOGIN_ATTEMPTS       UNLIMITED
   PASSWORD_LIFE_TIME          100
   PASSWORD_REUSE_TIME         12
   PASSWORD_REUSE_MAX          5
   PASSWORD_LOCK_TIME          1
   PASSWORD_GRACE_TIME         2; 

CREATE ROLE without_privileges;

--REVOKE ALL PRIVILEGES FROM without_privileges;

--USUARIO 1
CREATE USER Firulais IDENTIFIED BY "Firulais12" 
DEFAULT TABLESPACE vehicles_fleet QUOTA UNLIMITED ON vehicles_fleet;
--USUARIO 2
CREATE USER Tarzan IDENTIFIED BY "Tarzan23" 
DEFAULT TABLESPACE vehicles_fleet QUOTA UNLIMITED ON vehicles_fleet;
--USUARIO 3
CREATE USER Sammy IDENTIFIED BY "Sammy34" 
DEFAULT TABLESPACE vehicles_fleet QUOTA UNLIMITED ON vehicles_fleet;
--USUARIO 4
CREATE USER Canela IDENTIFIED BY "Canela45" 
DEFAULT TABLESPACE vehicles_fleet QUOTA UNLIMITED ON vehicles_fleet;

--PERMISO DE LOGIN
GRANT CREATE SESSION TO Firulais;
GRANT CREATE SESSION TO Tarzan;
GRANT CREATE SESSION TO Sammy;
GRANT CREATE SESSION TO Canela;

--ASIGNAR LOS ROLES
ALTER USER Firulais DEFAULT ROLE without_privileges;
ALTER USER Tarzan DEFAULT ROLE without_privileges;
ALTER USER Sammy DEFAULT ROLE without_privileges;
    
--ASIGNAR LOS PROFILES
ALTER USER Firulais PROFILE manager_profile; 
ALTER USER Tarzan PROFILE finance_profile; 
ALTER USER Sammy PROFILE service_profile; 
ALTER USER Canela PROFILE development;


/* 1. Normalize and attach entity relationship diagram (imagen, git) (1.0) */
-- Nombre del archivo: 
-- Url del git: en txt

/* 2. Create tables with its columns according to your normalization. 
      Create sequences for every primary key, create constraints for columns which 
      are "status". Create primary and foreign keys. */
CREATE SEQUENCE SeqDrivers START WITH 1 INCREMENT BY 1;
CREATE TABLE Drivers 
( 
  IdDriver NUMERIC(10),
  FullnameDriver VARCHAR2(50) NOT NULL,
  AddressDriver VARCHAR2(100) NOT NULL,
  PhoneDriver VARCHAR2(10) NOT NULL,
  CellphoneDriver VARCHAR2(10) NOT NULL,
  CONSTRAINT PkDrivers PRIMARY KEY (IdDriver)
);
              
CREATE SEQUENCE SeqVehicleTypes START WITH 1 INCREMENT BY 1;
CREATE TABLE VehicleTypes 
(
  IdVehicleType NUMBER(10),
  DescriptionVehicleType VARCHAR2(30) UNIQUE,
  SpecialQualification VARCHAR(1) NOT NULL ,
  CONSTRAINT PkVehicleTypes PRIMARY KEY (IdVehicleType)
);

CREATE SEQUENCE SeqVehicles START WITH 1 INCREMENT BY 1;
CREATE TABLE Vehicles 
(
  IdVehicle NUMBER(10),
  NumberVehicle VARCHAR(20) NOT NULL UNIQUE,
  PlateVehicle VARCHAR(10) NULL UNIQUE,
  StateVehicle VARCHAR(20) NOT NULL,
  MileageVehicle VARCHAR(7) NOT NULL,
  ModelVehicle VARCHAR(5) NOT NULL,
  CurrentValueVehicle NUMBER(12,2) NOT NULL,
  ReplacementValueVehicle NUMBER(12,2) NOT NULL,
  TaxedDateVehicle DATE NOT NULL,
  BoughtDateVehicle DATE NOT NULL,
  VehicleType NUMBER(10) NOT NULL,
  NumberPolicyVehicle VARCHAR(20) NOT NULL,
  WrittenOfVehicle VARCHAR(100) NOT NULL,
  CONSTRAINT PkVehicles PRIMARY KEY (IdVehicle),
  CONSTRAINT FkVehi_VehicleTypes FOREIGN KEY (VehicleType) REFERENCES VehicleTypes(IdVehicleType),
  CONSTRAINT CoStateVehicle CHECK(StateVehicle IN ('Active', 'Inactive', 'Repairing', 'Sold')),
  CONSTRAINT CoModelVehicle CHECK(ModelVehicle IN ('2010', '2011'))
);

CREATE SEQUENCE SeqDriverQualifications START WITH 1 INCREMENT BY 1;
CREATE TABLE DriverQualifications 
(
  IdDriverQualification NUMBER(10),
  Driver NUMBER(10) NOT NULL,
  VehicleType NUMBER(10) NOT NULL,
  CreatedDateQualification DATE NOT NULL,
  StateQualification VARCHAR(20) NOT NULL,
  CONSTRAINT PkDriverQualifications PRIMARY KEY (IdDriverQualification),
  CONSTRAINT FkDrQu_Drivers FOREIGN KEY (Driver) REFERENCES Drivers(IdDriver),
  CONSTRAINT FkDrQu_VehicleTypes FOREIGN KEY (VehicleType) REFERENCES VehicleTypes(IdVehicleType),
  CONSTRAINT CoStateQualification CHECK(StateQualification IN ('Active', 'Inactive', 'Expired', 'Disqualified'))
);

CREATE SEQUENCE SeqVehiclesPerDriver START WITH 1 INCREMENT BY 1;
CREATE TABLE VehiclesPerDriver
(
  IdVehiclePerDriver NUMBER(10),
  Driver NUMBER(10) NOT NULL,
  Vehicle NUMBER(10) NOT NULL,
  CONSTRAINT PkVehiclesPerDriver PRIMARY KEY (IdVehiclePerDriver),
  CONSTRAINT FkVeDr_Drivers FOREIGN KEY (Driver) REFERENCES Drivers(IdDriver),
  CONSTRAINT FkVeDr_Vehicles FOREIGN KEY (Vehicle) REFERENCES Vehicles(IdVehicle)
);

CREATE SEQUENCE SeqServiceTypes START WITH 1 INCREMENT BY 1;
CREATE TABLE ServiceTypes
(
  IdServiceType NUMBER(10),
  DescriptionServiceType VARCHAR2(30) UNIQUE,
  CONSTRAINT PkServiceTypes PRIMARY KEY (IdServiceType)
);

CREATE SEQUENCE SeqServices START WITH 1 INCREMENT BY 1;
CREATE TABLE Services
(
  IdService NUMBER(10),
  NameService VARCHAR(50) NOT NULL,
  Vehicle NUMBER(10) NOT NULL,
  IssueDate DATE NOT NULL,
  DescriptionService VARCHAR(2000) NOT NULL,
  StatusService VARCHAR(20) NOT NULL,
  TotalService NUMBER(11,2) NOT NULL,
  CONSTRAINT PkServices PRIMARY KEY (IdService),
  CONSTRAINT FkServ_Vehicles FOREIGN KEY (Vehicle) REFERENCES Vehicles(IdVehicle),
  CONSTRAINT CoStatusService CHECK(StatusService IN ('Pending', 'Scheduled', 'Ok'))
);

CREATE SEQUENCE SeqServiceDetails START WITH 1 INCREMENT BY 1;
CREATE TABLE ServiceDetails
(
  IdServiceDetail NUMBER(10),
  Service NUMBER(10) NOT NULL,
  ServiceType NUMBER(10) NOT NULL,
  StatusServiceDetail VARCHAR(20) NULL,
  ValueServiceDetail NUMBER(11,2) NOT NULL,
  CONSTRAINT PkServiceDetails PRIMARY KEY (IdServiceDetail),
  CONSTRAINT FkSeDe_Services FOREIGN KEY (Service) REFERENCES Services(IdService),
  CONSTRAINT FkSeDe_ServiceTypes FOREIGN KEY (ServiceType) REFERENCES ServiceTypes(IdServiceType),
  CONSTRAINT CoStatusServiceDetail CHECK(StatusServiceDetail IN ('OK', 'Pending', 'Needs_repair', 'Observations'))
);

CREATE SEQUENCE SeqRepairCosts START WITH 1 INCREMENT BY 1;
CREATE TABLE RepairCosts
(
  IdRepairCost NUMBER(10),
  Vehicle NUMBER(10) NOT NULL,
  DateRepairCost DATE NOT NULL,
  DescriptionRepairCost VARCHAR(150) NOT NULL,
  AmountRepairCost NUMBER(11,2) NOT NULL,
  StatusRepairCost VARCHAR(10) NULL,
  CONSTRAINT PkRepairCosts PRIMARY KEY (IdRepairCost),
  CONSTRAINT FkReCo_Vehicles FOREIGN KEY (Vehicle) REFERENCES Vehicles(IdVehicle),
  CONSTRAINT CoStatusRepairCost CHECK(StatusRepairCost IN ('Pending', 'Paid'))
);

CREATE SEQUENCE SeqInsuranceClaims START WITH 1 INCREMENT BY 1;
CREATE TABLE InsuranceClaims
(
  IdInsuranceClaim NUMBER(10),
  Vehicle NUMBER(10) NOT NULL,
  PolicyNumberInsuranceClaim VARCHAR(15) NOT NULL,
  LossDateInsuranceClaim DATE NOT NULL,
  IssueDateInsuranceClaim DATE NOT NULL,
  NaturePaymentInsuranceClaim VARCHAR(400),
  DamagesInsuranceClaim VARCHAR(400),
  CONSTRAINT PkInsuranceClaims PRIMARY KEY (IdInsuranceClaim),
  CONSTRAINT FkInCl_Vehicles FOREIGN KEY (Vehicle) REFERENCES Vehicles(IdVehicle)
);

CREATE TRIGGER TriSeqDrivers BEFORE INSERT ON Drivers FOR EACH ROW
BEGIN
  SELECT SeqDrivers.NEXTVAL INTO :new.IdDriver FROM DUAL;
END;
CREATE TRIGGER TriSeqVehicleTypes BEFORE INSERT ON VehicleTypes FOR EACH ROW
BEGIN
  SELECT SeqVehicleTypes.NEXTVAL INTO :new.IdVehicleType FROM DUAL;
END;
CREATE TRIGGER TriSeqVehicles BEFORE INSERT ON Vehicles FOR EACH ROW
BEGIN
  SELECT SeqVehicles.NEXTVAL INTO :new.IdVehicle FROM DUAL;
END;
CREATE TRIGGER TriSeqDriverQualifications BEFORE INSERT ON DriverQualifications FOR EACH ROW
BEGIN
  SELECT SeqDriverQualifications.NEXTVAL INTO :new.IdDriverQualification FROM DUAL;
END;
CREATE TRIGGER TriSeqVehiclesPerDriver BEFORE INSERT ON VehiclesPerDriver FOR EACH ROW
BEGIN
  SELECT SeqVehiclesPerDriver.NEXTVAL INTO :new.IdVehiclePerDriver FROM DUAL;
END;
CREATE TRIGGER TriSeqServiceTypes BEFORE INSERT ON ServiceTypes FOR EACH ROW
BEGIN
  SELECT SeqServiceTypes.NEXTVAL INTO :new.IdServiceType FROM DUAL;
END;
CREATE TRIGGER TriSeqServices BEFORE INSERT ON Services FOR EACH ROW
BEGIN
  SELECT SeqServices.NEXTVAL INTO :new.IdService FROM DUAL;
END;
CREATE TRIGGER TriSeqServiceDetails BEFORE INSERT ON ServiceDetails FOR EACH ROW
BEGIN
  SELECT SeqServiceDetails.NEXTVAL INTO :new.IdServiceDetail FROM DUAL;
END;
CREATE TRIGGER TriSeqRepairCosts BEFORE INSERT ON RepairCosts FOR EACH ROW
BEGIN
  SELECT SeqRepairCosts.NEXTVAL INTO :new.IdRepairCost FROM DUAL;
END;
CREATE TRIGGER TriSeqInsuranceClaims BEFORE INSERT ON InsuranceClaims FOR EACH ROW
BEGIN
  SELECT SeqInsuranceClaims.NEXTVAL INTO :new.IdInsuranceClaim FROM DUAL;
END;

INSERT INTO ServiceTypes(DescriptionServiceType) VALUES ('Automatic Transmission Fluid');
INSERT INTO ServiceTypes(DescriptionServiceType) VALUES ('Battery and Cables');
INSERT INTO ServiceTypes(DescriptionServiceType) VALUES ('Belts');
INSERT INTO ServiceTypes(DescriptionServiceType) VALUES ('Brakes');
INSERT INTO ServiceTypes(DescriptionServiceType) VALUES ('Cabin Air Filter');
INSERT INTO ServiceTypes(DescriptionServiceType) VALUES ('Chassis Lubrication');
INSERT INTO ServiceTypes(DescriptionServiceType) VALUES ('Dashboard Indicator Light On');
INSERT INTO ServiceTypes(DescriptionServiceType) VALUES ('Coolant (Antifreeze)');
INSERT INTO ServiceTypes(DescriptionServiceType) VALUES ('Engine Air Filter');
INSERT INTO ServiceTypes(DescriptionServiceType) VALUES ('Engine Oil');
INSERT INTO ServiceTypes(DescriptionServiceType) VALUES ('Exhaust'); 
INSERT INTO ServiceTypes(DescriptionServiceType) VALUES ('Hoses'); 
INSERT INTO ServiceTypes(DescriptionServiceType) VALUES ('Lights'); 
INSERT INTO ServiceTypes(DescriptionServiceType) VALUES ('Power Steering Fluid'); 
INSERT INTO ServiceTypes(DescriptionServiceType) VALUES ('Steering and Suspension'); 
INSERT INTO ServiceTypes(DescriptionServiceType) VALUES ('Tire Inflation and Condition'); 
INSERT INTO ServiceTypes(DescriptionServiceType) VALUES ('Wheel Alignment'); 
INSERT INTO ServiceTypes(DescriptionServiceType) VALUES ('Windshield Washer Fluid'); 
INSERT INTO ServiceTypes(DescriptionServiceType) VALUES ('Wiper Blades'); 
COMMIT;

INSERT INTO VehicleTypes (DescriptionVehicleType, SpecialQualification) VALUES ('Moped', 'N');
INSERT INTO VehicleTypes (DescriptionVehicleType, SpecialQualification) VALUES ('Motorcycle', 'N');
INSERT INTO VehicleTypes (DescriptionVehicleType, SpecialQualification) VALUES ('Trike motorcycle', 'N');
INSERT INTO VehicleTypes (DescriptionVehicleType, SpecialQualification) VALUES ('Car', 'N');
INSERT INTO VehicleTypes (DescriptionVehicleType, SpecialQualification) VALUES ('Light rigid heavy vehicle', 'Y');
INSERT INTO VehicleTypes (DescriptionVehicleType, SpecialQualification) VALUES ('Medium rigid heavy vehicle', 'Y');
INSERT INTO VehicleTypes (DescriptionVehicleType, SpecialQualification) VALUES ('Heavy rigid vehicle', 'Y');
INSERT INTO VehicleTypes (DescriptionVehicleType, SpecialQualification) VALUES ('Tractor', 'Y');
INSERT INTO VehicleTypes (DescriptionVehicleType, SpecialQualification) VALUES ('Wheelchair vehicle', 'Y');
COMMIT;

/* 2. Insert at least 20 vehicles (At least one of each class), 50 drivers, 10 
      insurance claims, 5 services (Go to http://www.generatedata.com/). This 
      should be a functional single script (.sql) (Better if you generate sql 
      through sql developer) (0.5) */
INSERT INTO Vehicles (NumberVehicle, PlateVehicle, StateVehicle, MileageVehicle, ModelVehicle,
  CurrentValueVehicle, ReplacementValueVehicle, TaxedDateVehicle, BoughtDateVehicle, VehicleType, 
  NumberPolicyVehicle, WrittenOfVehicle) 
SELECT '874387599', 'TUD-345', 'Active', '65000','2011',23000000,19000000,
        TO_DATE('2011-08-27', 'yyyy-mm-dd'), TO_DATE('2011-08-25', 'yyyy-mm-dd'),
        IdVehicleType, 'V89FGF889', 'N'
FROM VehicleTypes
WHERE DescriptionVehicleType = 'Car';
INSERT INTO Vehicles (NumberVehicle, PlateVehicle, StateVehicle, MileageVehicle, ModelVehicle,
  CurrentValueVehicle, ReplacementValueVehicle, TaxedDateVehicle, BoughtDateVehicle, VehicleType, 
  NumberPolicyVehicle, WrittenOfVehicle) 
SELECT '124387599', 'TUD-675', 'Inactive', '30000','2011',29000000,22000000,
        TO_DATE('2011-12-05', 'yyyy-mm-dd'), TO_DATE('2011-12-11', 'yyyy-mm-dd'),
        IdVehicleType, 'VG93G4889', 'N'
FROM VehicleTypes
WHERE DescriptionVehicleType = 'Car';
INSERT INTO Vehicles (NumberVehicle, PlateVehicle, StateVehicle, MileageVehicle, ModelVehicle,
  CurrentValueVehicle, ReplacementValueVehicle, TaxedDateVehicle, BoughtDateVehicle, VehicleType, 
  NumberPolicyVehicle, WrittenOfVehicle) 
SELECT '794387599', 'ERD-123', 'Repairing', '99000','2010',16000000,14000000,
        TO_DATE('2010-03-01', 'yyyy-mm-dd'), TO_DATE('2010-03-06', 'yyyy-mm-dd'),
        IdVehicleType, 'ERG93G48TG', 'Y'
FROM VehicleTypes
WHERE DescriptionVehicleType = 'Car';
INSERT INTO Vehicles (NumberVehicle, PlateVehicle, StateVehicle, MileageVehicle, ModelVehicle,
  CurrentValueVehicle, ReplacementValueVehicle, TaxedDateVehicle, BoughtDateVehicle, VehicleType, 
  NumberPolicyVehicle, WrittenOfVehicle) 
SELECT '123764298', 'ASD-82B', 'Active', '9000','2011',200000,1800000,
        TO_DATE('2011-09-22', 'yyyy-mm-dd'), TO_DATE('2011-09-30', 'yyyy-mm-dd'),
        IdVehicleType, 'AJG93G48TG', 'Y'
FROM VehicleTypes
WHERE DescriptionVehicleType = 'Motorcycle';
INSERT INTO Vehicles (NumberVehicle, PlateVehicle, StateVehicle, MileageVehicle, ModelVehicle,
  CurrentValueVehicle, ReplacementValueVehicle, TaxedDateVehicle, BoughtDateVehicle, VehicleType, 
  NumberPolicyVehicle, WrittenOfVehicle) 
SELECT '950764298', 'RTD-35A', 'Sold', '12000','2010',200000,1800000,
        TO_DATE('2010-04-22', 'yyyy-mm-dd'), TO_DATE('2010-04-30', 'yyyy-mm-dd'),
        IdVehicleType, 'FHG53G48TG', 'Y'
FROM VehicleTypes
WHERE DescriptionVehicleType = 'Motorcycle';
INSERT INTO Vehicles (NumberVehicle, PlateVehicle, StateVehicle, MileageVehicle, ModelVehicle,
  CurrentValueVehicle, ReplacementValueVehicle, TaxedDateVehicle, BoughtDateVehicle, VehicleType, 
  NumberPolicyVehicle, WrittenOfVehicle) 
SELECT '987764298', 'AFG-43B', 'Inactive', '9000','2011',300000,2600000,
        TO_DATE('2011-09-22', 'yyyy-mm-dd'), TO_DATE('2011-09-30', 'yyyy-mm-dd'),
        IdVehicleType, 'FVG67G48TG', 'N'
FROM VehicleTypes
WHERE DescriptionVehicleType = 'Motorcycle';
INSERT INTO Vehicles (NumberVehicle, PlateVehicle, StateVehicle, MileageVehicle, ModelVehicle,
  CurrentValueVehicle, ReplacementValueVehicle, TaxedDateVehicle, BoughtDateVehicle, VehicleType, 
  NumberPolicyVehicle, WrittenOfVehicle) 
SELECT '567764298', 'GJE-42C', 'Repairing', '10000','2011',600000,4800000,
        TO_DATE('2011-10-25', 'yyyy-mm-dd'), TO_DATE('2011-10-20', 'yyyy-mm-dd'),
        IdVehicleType, '23G93G89RT', 'N'
FROM VehicleTypes
WHERE DescriptionVehicleType = 'Motorcycle';
INSERT INTO Vehicles (NumberVehicle, PlateVehicle, StateVehicle, MileageVehicle, ModelVehicle,
  CurrentValueVehicle, ReplacementValueVehicle, TaxedDateVehicle, BoughtDateVehicle, VehicleType, 
  NumberPolicyVehicle, WrittenOfVehicle) 
SELECT '951234298', 'QWE-35H', 'Sold', '12000','2010',700000,5800000,
        TO_DATE('2010-04-22', 'yyyy-mm-dd'), TO_DATE('2010-04-30', 'yyyy-mm-dd'),
        IdVehicleType, 'ITL53G48TG', 'Y'
FROM VehicleTypes
WHERE DescriptionVehicleType = 'Motorcycle';
INSERT INTO Vehicles (NumberVehicle, PlateVehicle, StateVehicle, MileageVehicle, ModelVehicle,
  CurrentValueVehicle, ReplacementValueVehicle, TaxedDateVehicle, BoughtDateVehicle, VehicleType, 
  NumberPolicyVehicle, WrittenOfVehicle) 
SELECT '987123298', 'DVG-34D', 'Inactive', '9000','2011',200000,1600000,
        TO_DATE('2011-09-22', 'yyyy-mm-dd'), TO_DATE('2011-09-30', 'yyyy-mm-dd'),
        IdVehicleType, 'LMJ67G48TG', 'N'
FROM VehicleTypes
WHERE DescriptionVehicleType = 'Motorcycle';
INSERT INTO Vehicles (NumberVehicle, PlateVehicle, StateVehicle, MileageVehicle, ModelVehicle,
  CurrentValueVehicle, ReplacementValueVehicle, TaxedDateVehicle, BoughtDateVehicle, VehicleType, 
  NumberPolicyVehicle, WrittenOfVehicle) 
SELECT '567764123', 'TYH-34R', 'Active', '10000','2010',400000,2800000,
        TO_DATE('2011-01-02', 'yyyy-mm-dd'), TO_DATE('2011-01-03', 'yyyy-mm-dd'),
        IdVehicleType, '23G93FTTRT', 'Y'
FROM VehicleTypes
WHERE DescriptionVehicleType = 'Motorcycle';
INSERT INTO Vehicles (NumberVehicle, PlateVehicle, StateVehicle, MileageVehicle, ModelVehicle,
  CurrentValueVehicle, ReplacementValueVehicle, TaxedDateVehicle, BoughtDateVehicle, VehicleType, 
  NumberPolicyVehicle, WrittenOfVehicle) 
SELECT '874387122', 'TUD-234', 'Active', '255000','2011',63000000,49000000,
        TO_DATE('2011-08-27', 'yyyy-mm-dd'), TO_DATE('2011-08-25', 'yyyy-mm-dd'),
        IdVehicleType, 'TY9FRR889', 'Y'
FROM VehicleTypes
WHERE DescriptionVehicleType = 'Light rigid heavy vehicle';
INSERT INTO Vehicles (NumberVehicle, PlateVehicle, StateVehicle, MileageVehicle, ModelVehicle,
  CurrentValueVehicle, ReplacementValueVehicle, TaxedDateVehicle, BoughtDateVehicle, VehicleType, 
  NumberPolicyVehicle, WrittenOfVehicle) 
SELECT '898387599', 'VVV-675', 'Inactive', '30000','2011',99000000,92000000,
        TO_DATE('2011-12-05', 'yyyy-mm-dd'), TO_DATE('2011-12-11', 'yyyy-mm-dd'),
        IdVehicleType, 'NN93G4889', 'N'
FROM VehicleTypes
WHERE DescriptionVehicleType = 'Light rigid heavy vehicle';
INSERT INTO Vehicles (NumberVehicle, PlateVehicle, StateVehicle, MileageVehicle, ModelVehicle,
  CurrentValueVehicle, ReplacementValueVehicle, TaxedDateVehicle, BoughtDateVehicle, VehicleType, 
  NumberPolicyVehicle, WrittenOfVehicle) 
SELECT '734587599', 'EER-123', 'Repairing', '99000','2010',84000000,80000000,
        TO_DATE('2010-03-01', 'yyyy-mm-dd'), TO_DATE('2010-03-06', 'yyyy-mm-dd'),
        IdVehicleType, 'BBG93G48TG', 'Y'
FROM VehicleTypes
WHERE DescriptionVehicleType = 'Light rigid heavy vehicle';
INSERT INTO Vehicles (NumberVehicle, PlateVehicle, StateVehicle, MileageVehicle, ModelVehicle,
  CurrentValueVehicle, ReplacementValueVehicle, TaxedDateVehicle, BoughtDateVehicle, VehicleType, 
  NumberPolicyVehicle, WrittenOfVehicle) 
SELECT '122764298', 'UYU-824', 'Active', '9000','2011',89000000,72000000,
        TO_DATE('2011-09-22', 'yyyy-mm-dd'), TO_DATE('2011-09-30', 'yyyy-mm-dd'),
        IdVehicleType, 'EDG93G48TG', 'Y'
FROM VehicleTypes
WHERE DescriptionVehicleType = 'Light rigid heavy vehicle';
INSERT INTO Vehicles (NumberVehicle, PlateVehicle, StateVehicle, MileageVehicle, ModelVehicle,
  CurrentValueVehicle, ReplacementValueVehicle, TaxedDateVehicle, BoughtDateVehicle, VehicleType, 
  NumberPolicyVehicle, WrittenOfVehicle) 
SELECT '111764298', 'AAA-344', 'Sold', '12000','2010',89000000,72000000,
        TO_DATE('2010-04-22', 'yyyy-mm-dd'), TO_DATE('2010-04-30', 'yyyy-mm-dd'),
        IdVehicleType, '11153G48TG', 'Y'
FROM VehicleTypes
WHERE DescriptionVehicleType = 'Tractor';
INSERT INTO Vehicles (NumberVehicle, PlateVehicle, StateVehicle, MileageVehicle, ModelVehicle,
  CurrentValueVehicle, ReplacementValueVehicle, TaxedDateVehicle, BoughtDateVehicle, VehicleType, 
  NumberPolicyVehicle, WrittenOfVehicle) 
SELECT '333764298', 'QQQ-43B', 'Inactive', '9000','2011',159000000,142000000,
        TO_DATE('2011-09-22', 'yyyy-mm-dd'), TO_DATE('2011-09-30', 'yyyy-mm-dd'),
        IdVehicleType, '33367G48TG', 'N'
FROM VehicleTypes
WHERE DescriptionVehicleType = 'Tractor';
INSERT INTO Vehicles (NumberVehicle, PlateVehicle, StateVehicle, MileageVehicle, ModelVehicle,
  CurrentValueVehicle, ReplacementValueVehicle, TaxedDateVehicle, BoughtDateVehicle, VehicleType, 
  NumberPolicyVehicle, WrittenOfVehicle) 
SELECT '555764298', 'TTT-42C', 'Repairing', '10000','2011',89000000,72000000,
        TO_DATE('2011-10-25', 'yyyy-mm-dd'), TO_DATE('2011-10-20', 'yyyy-mm-dd'),
        IdVehicleType, '55593G89RT', 'N'
FROM VehicleTypes
WHERE DescriptionVehicleType = 'Tractor';
INSERT INTO Vehicles (NumberVehicle, PlateVehicle, StateVehicle, MileageVehicle, ModelVehicle,
  CurrentValueVehicle, ReplacementValueVehicle, TaxedDateVehicle, BoughtDateVehicle, VehicleType, 
  NumberPolicyVehicle, WrittenOfVehicle) 
SELECT '888234298', 'VVV-35H', 'Sold', '12000','2010',99000000,92000000,
        TO_DATE('2010-04-22', 'yyyy-mm-dd'), TO_DATE('2010-04-30', 'yyyy-mm-dd'),
        IdVehicleType, '88853G48TG', 'Y'
FROM VehicleTypes
WHERE DescriptionVehicleType = 'Tractor';
INSERT INTO Vehicles (NumberVehicle, PlateVehicle, StateVehicle, MileageVehicle, ModelVehicle,
  CurrentValueVehicle, ReplacementValueVehicle, TaxedDateVehicle, BoughtDateVehicle, VehicleType, 
  NumberPolicyVehicle, WrittenOfVehicle) 
SELECT '222333298', 'EEE-34D', 'Inactive', '9000','2011',79000000,62000000,
        TO_DATE('2011-09-22', 'yyyy-mm-dd'), TO_DATE('2011-09-30', 'yyyy-mm-dd'),
        IdVehicleType, '2223338TG', 'N'
FROM VehicleTypes
WHERE DescriptionVehicleType = 'Heavy rigid vehicle';
INSERT INTO Vehicles (NumberVehicle, PlateVehicle, StateVehicle, MileageVehicle, ModelVehicle,
  CurrentValueVehicle, ReplacementValueVehicle, TaxedDateVehicle, BoughtDateVehicle, VehicleType, 
  NumberPolicyVehicle, WrittenOfVehicle) 
SELECT '998224123', 'UUU-34R', 'Active', '10000','2010',89000000,72000000,
        TO_DATE('2011-01-02', 'yyyy-mm-dd'), TO_DATE('2011-01-03', 'yyyy-mm-dd'),
        IdVehicleType, '99893FSTRT', 'Y'
FROM VehicleTypes
WHERE DescriptionVehicleType = 'Heavy rigid vehicle';
COMMIT;

INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Andres Felipe Albanes Gaviria', 'Call 45 # 09 - 33', '4673489','3009849843');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Pablo Andrey Gaviria Estrada', 'Car 23 # 44 - 57', '4673489','3110987654');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Felipe Ariztizabal Rios', 'Call 45 # 23 - 2 Sur', '4750978','3124567890');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Juan Pable Rios Rios', 'Ave 34 # 09 - 22', '4356786','3002359843');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Stiben Borja Hernandes', 'Call 12 # 43 - 33', '4568907','3009678843');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Estiben Andres Gaviria Aguirre', 'Car 78 # 23 - 54', '4562342','3023449843');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Laura Correa Salvador', 'Call 67 # 67 - 38', '4655641','3001009843');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Luisa Fernanda Hincapie', 'Car 56 # 76 - 46', '4712345','3007779843');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Luz Roldan Lopez', 'Car 56 # 45 - 50', '4784532','3004449843');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Eliana Zapata Arias', 'Call 32 # 11 - 12', '4561232','3009222843');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Natalia Rodriguez Gomez', 'Call 11 # 09 - 23', '4673111','3009849111');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Camilo Garcia Garcia', 'Car 23 # 44 - 34', '4673222','3110987222');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Rafael Gomez Sanchez', 'Call 44 # 23 - 54 Sur', '4750333','3124567333');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Sindy Tatiana Rios Rios', 'Ave 55 # 09 - 66', '4356444','3002359444');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Edwin Hernandes Ramirez', 'Call 66 # 43 - 23', '4568555','3009678555');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Estephanie Perez Dias', 'Car 77 # 23 - 87', '4562666','3023449666');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Sindy Torres Ortiz', 'Call 88 # 67 - 99', '4655777','3001009777');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Sebastian Valencia Morales', 'Car 99 # 76 - 66', '4712888','3007779888');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Astrid Giraldo Gil', 'Car 12 # 45 - 12', '4784999','3004449999');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Marlos Alvarez Mejia', 'Call 13 # 11 - 33', '4561000','3009222000');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Marta Albanes Gaviria', 'Ave 4 # 09 - 33', '4611189','3009841143');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Angie Paola Gaviria Estrada', 'Car 2 # 44 - 57', '4622289','3110922654');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Jairo Ariztizabal Rios', 'Call 4 # 23 - 2 Sur', '4753378','3124565590');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Mauricio Rios Rios', 'Ave 6 # 09 - 22', '4354486','3002359843');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Jhonny Andrey Borja Hernandes', 'Call 7 # 43 - 33', '4564407','3009633843');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Josefina Gaviria Aguirre', 'Car 4 # 23 - 54', '4561142','3023444443');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Estela Correa Salvador', 'Call 7 # 67 - 38', '4655441','3001005553');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Maria Fernanda Hincapie', 'Car 8 # 76 - 46', '4717745','3007776663');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Imelda Roldan Lopez', 'Car 9 # 45 - 50', '4784992','3004447773');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Flor Zapata Arias', 'Call 1 # 11 - 12', '4560032','3009222993');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Gloria Rodriguez Gomez', 'Ave 2 # 09 - 23', '4673100','3009849100');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Obed Garcia Garcia', 'Car 56 # 44 - 34', '4673200','3110987200');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Bertulfo Gomez Sanchez', 'Call 3 # 23 - 54 Sur', '4750300','3124567300');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Jhoan Rios Rios', 'Ave 7 # 09 - 66', '4356400','3002359400');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Victor Hernandes Ramirez', 'Call 3 # 43 - 23', '4568500','3009678500');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Jonatan Perez Dias', 'Car 9 # 23 - 87', '4562600','3023449600');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Carlos Torres Ortiz', 'Call 14 # 67 - 99', '4655700','3001009700');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Javier Valencia Morales', 'Car 34 # 76 - 66', '4712800','3007779800');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Lesli Giraldo Gil', 'Car 66 # 45 - 12', '4784900','3004449900');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Cesar Alvarez Mejia', 'Call 55 # 11 - 33', '4561011','3009222011');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Marleny Rodriguez Gomez', 'Call 12 # 09 - 2', '4673456','3009849123');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Orlando Garcia Garcia', 'Ave 23 # 44 - 4', '4673565','3110987234');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Jesus Gomez Sanchez', 'Car 34 # 23 - 6 Sur', '4750453','3124567345');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Jose Fernando Rios Rios', 'Call 45 # 09 - 7', '4356345','3002359456');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Alexander Hernandes Ramirez', 'Ave 56 # 43 - 84', '4568456','3009678567');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Alex Perez Dias', 'Car 67 # 23 - 23', '4562456','3023449678');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Carlonia Torres Ortiz', 'Call 78 # 67 - 12', '4655456','300100923');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Santiago Valencia Morales', 'Ave 89 # 76 - 23', '4712234','3007779340');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Mario Giraldo Gil', 'Car 90 # 45 - 43', '4784675','3004449340');
INSERT INTO Drivers (FullnameDriver, AddressDriver, PhoneDriver, CellphoneDriver) 
       VALUES ('Maria Jose Alvarez Mejia', 'Call 10 # 11 - 23', '4561456','3009222451');
COMMIT;

INSERT INTO Services (NameService, Vehicle, IssueDate, DescriptionService, StatusService, TotalService) 
       VALUES ('Motor repair', 7, TO_DATE('2017-09-30', 'yyyy-mm-dd'),'Motor repair','Pending', 2000000);
INSERT INTO ServiceDetails (Service, ServiceType, StatusServiceDetail, ValueServiceDetail) VALUES (1, 10,'Pending', 200000);
INSERT INTO ServiceDetails (Service, ServiceType, StatusServiceDetail, ValueServiceDetail) VALUES (1, 8,'Pending', 1200000);
INSERT INTO ServiceDetails (Service, ServiceType, StatusServiceDetail, ValueServiceDetail) VALUES (1, 11,'Pending', 800000);    
    
INSERT INTO Services (NameService, Vehicle, IssueDate, DescriptionService, StatusService, TotalService) 
       VALUES ('Trasminision repair', 4, TO_DATE('2016-09-30', 'yyyy-mm-dd'),'Trasminision repair','Scheduled', 300000);
INSERT INTO ServiceDetails (Service, ServiceType, StatusServiceDetail, ValueServiceDetail) VALUES (2, 17,'Needs_repair', 100000);
INSERT INTO ServiceDetails (Service, ServiceType, StatusServiceDetail, ValueServiceDetail) VALUES (2, 6,'Needs_repair', 100000);
INSERT INTO ServiceDetails (Service, ServiceType, StatusServiceDetail, ValueServiceDetail) VALUES (2, 1,'Needs_repair', 100000);

INSERT INTO Services (NameService, Vehicle, IssueDate, DescriptionService, StatusService, TotalService) 
       VALUES ('Electric repair', 9, TO_DATE('2013-09-30', 'yyyy-mm-dd'),'Electric repair','Pending', 600000);
INSERT INTO ServiceDetails (Service, ServiceType, StatusServiceDetail, ValueServiceDetail) VALUES (3, 2,'Pending', 400000);
INSERT INTO ServiceDetails (Service, ServiceType, StatusServiceDetail, ValueServiceDetail) VALUES (3, 13,'Pending', 200000);

INSERT INTO Services (NameService, Vehicle, IssueDate, DescriptionService, StatusService, TotalService) 
       VALUES ('Motor repair', 14, TO_DATE('2015-09-30', 'yyyy-mm-dd'),'Motor repair','Ok', 350000);
INSERT INTO ServiceDetails (Service, ServiceType, StatusServiceDetail, ValueServiceDetail) VALUES (4, 9,'Observations', 150000);
INSERT INTO ServiceDetails (Service, ServiceType, StatusServiceDetail, ValueServiceDetail) VALUES (4, 8,'Observations', 200000);

INSERT INTO Services (NameService, Vehicle, IssueDate, DescriptionService, StatusService, TotalService) 
       VALUES ('Trasminision repair', 17, TO_DATE('2016-09-30', 'yyyy-mm-dd'),'Trasminision repair','Ok', 350000);
INSERT INTO ServiceDetails (Service, ServiceType, StatusServiceDetail, ValueServiceDetail) VALUES (5, 6,'Needs_repair', 200000);
INSERT INTO ServiceDetails (Service, ServiceType, StatusServiceDetail, ValueServiceDetail) VALUES (5, 1,'Needs_repair', 150000);
COMMIT;

INSERT INTO InsuranceClaims (Vehicle, PolicyNumberInsuranceClaim, LossDateInsuranceClaim, 
          IssueDateInsuranceClaim, NaturePaymentInsuranceClaim, DamagesInsuranceClaim) 
SELECT IdVehicle, NumberPolicyVehicle, TO_DATE('2016-09-29', 'yyyy-mm-dd'), 
       TO_DATE('2016-09-30', 'yyyy-mm-dd'), 'Transfer', 'Lost'
FROM Vehicles
WHERE IdVehicle = 1;
INSERT INTO InsuranceClaims (Vehicle, PolicyNumberInsuranceClaim, LossDateInsuranceClaim, 
          IssueDateInsuranceClaim, NaturePaymentInsuranceClaim, DamagesInsuranceClaim) 
SELECT IdVehicle, NumberPolicyVehicle, TO_DATE('2016-09-29', 'yyyy-mm-dd'), 
       TO_DATE('2016-09-30', 'yyyy-mm-dd'), 'Transfer', 'Lost'
FROM Vehicles
WHERE IdVehicle = 5;
INSERT INTO InsuranceClaims (Vehicle, PolicyNumberInsuranceClaim, LossDateInsuranceClaim, 
          IssueDateInsuranceClaim, NaturePaymentInsuranceClaim, DamagesInsuranceClaim) 
SELECT IdVehicle, NumberPolicyVehicle, TO_DATE('2016-09-29', 'yyyy-mm-dd'), 
       TO_DATE('2016-09-30', 'yyyy-mm-dd'), 'Accident', 'Total damage'
FROM Vehicles
WHERE IdVehicle = 8;
INSERT INTO InsuranceClaims (Vehicle, PolicyNumberInsuranceClaim, LossDateInsuranceClaim, 
          IssueDateInsuranceClaim, NaturePaymentInsuranceClaim, DamagesInsuranceClaim) 
SELECT IdVehicle, NumberPolicyVehicle, TO_DATE('2017-01-29', 'yyyy-mm-dd'), 
       TO_DATE('2017-01-30', 'yyyy-mm-dd'), 'Accident', 'Total damage'
FROM Vehicles
WHERE IdVehicle = 10;
INSERT INTO InsuranceClaims (Vehicle, PolicyNumberInsuranceClaim, LossDateInsuranceClaim, 
          IssueDateInsuranceClaim, NaturePaymentInsuranceClaim, DamagesInsuranceClaim) 
SELECT IdVehicle, NumberPolicyVehicle, TO_DATE('2017-04-19', 'yyyy-mm-dd'), 
       TO_DATE('2017-04-20', 'yyyy-mm-dd'), 'Accident', 'Total damage'
FROM Vehicles
WHERE IdVehicle = 11;
INSERT INTO InsuranceClaims (Vehicle, PolicyNumberInsuranceClaim, LossDateInsuranceClaim, 
          IssueDateInsuranceClaim, NaturePaymentInsuranceClaim, DamagesInsuranceClaim) 
SELECT IdVehicle, NumberPolicyVehicle, TO_DATE('2017-01-01', 'yyyy-mm-dd'), 
       TO_DATE('2017-01-01', 'yyyy-mm-dd'), 'Transfer', 'Lost'
FROM Vehicles
WHERE IdVehicle = 12;
INSERT INTO InsuranceClaims (Vehicle, PolicyNumberInsuranceClaim, LossDateInsuranceClaim, 
          IssueDateInsuranceClaim, NaturePaymentInsuranceClaim, DamagesInsuranceClaim) 
SELECT IdVehicle, NumberPolicyVehicle, TO_DATE('2016-02-13', 'yyyy-mm-dd'), 
       TO_DATE('2016-02-15', 'yyyy-mm-dd'), 'Accident', 'Total damage'
FROM Vehicles
WHERE IdVehicle = 15;
INSERT INTO InsuranceClaims (Vehicle, PolicyNumberInsuranceClaim, LossDateInsuranceClaim, 
          IssueDateInsuranceClaim, NaturePaymentInsuranceClaim, DamagesInsuranceClaim) 
SELECT IdVehicle, NumberPolicyVehicle, TO_DATE('2016-07-18', 'yyyy-mm-dd'), 
       TO_DATE('2016-07-22', 'yyyy-mm-dd'), 'Accident', 'Total damage'
FROM Vehicles
WHERE IdVehicle = 16;
INSERT INTO InsuranceClaims (Vehicle, PolicyNumberInsuranceClaim, LossDateInsuranceClaim, 
          IssueDateInsuranceClaim, NaturePaymentInsuranceClaim, DamagesInsuranceClaim) 
SELECT IdVehicle, NumberPolicyVehicle, TO_DATE('2016-03-29', 'yyyy-mm-dd'), 
       TO_DATE('2016-03-30', 'yyyy-mm-dd'), 'Transfer', 'Lost'
FROM Vehicles
WHERE IdVehicle = 18;
INSERT INTO InsuranceClaims (Vehicle, PolicyNumberInsuranceClaim, LossDateInsuranceClaim, 
          IssueDateInsuranceClaim, NaturePaymentInsuranceClaim, DamagesInsuranceClaim) 
SELECT IdVehicle, NumberPolicyVehicle, TO_DATE('2016-12-24', 'yyyy-mm-dd'), 
       TO_DATE('2016-12-31', 'yyyy-mm-dd'), 'Accident', 'Total damage'
FROM Vehicles
WHERE IdVehicle = 20;
COMMIT;

SELECT * FROM ServiceTypes;
SELECT * FROM VehicleTypes;
SELECT * FROM Vehicles;
SELECT * FROM Drivers;
SELECT * FROM Services;
SELECT * FROM ServiceDetails;
SELECT * FROM InsuranceClaims;

/* 3. Create a backup trough postman and take a screenshot of the list of backups in the console. Add the
      image to git. (0.5) */
-- Nombre del archivo: 
-- Url del git: en txt       

/* 4. Create a view which should be run only by users associated to "finance_profile ". The view should look
      like this:
      Registration_number / Mileage / Model / Current_value / class / Replacement_Value / Status /
      Required_special_qualification? / Number_of_services / Total_money_spent_in_repairs.
      The view should show only class of cars: Car, Light rigid heavy vehicle, Medium rigid heavy vehicle,
      heavy rigid vehicle, tractor and and filter the cars which were bought since 2 years ago and order them
      by mileage (descending) (0.5) */
CREATE OR REPLACE FUNCTION FunTotalServices(IdVehicle IN number)
RETURN number IS
   total number(5) := 0;
BEGIN
   SELECT count(*) into total 
   FROM Services
   WHERE Vehicle = IdVehicle;
   
   RETURN total;
END;  
  
CREATE OR REPLACE FUNCTION FunSumTotalServices(IdVehicle IN number)
RETURN number IS
   total number(16,2) := 0;
BEGIN
   SELECT Sum(TotalService) into total 
   FROM Services
   WHERE Vehicle = IdVehicle;
   
   RETURN total;
END;  

CREATE OR REPLACE VIEW ViewVehiclesIn2Years AS
    SELECT V.NumberVehicle, V.MileageVehicle, V.ModelVehicle, V.CurrentValueVehicle, 
           V.ReplacementValueVehicle, V.StateVehicle, VT.SpecialQualification,
           FunTotalServices(V.IdVehicle) as Times, FunSumTotalServices(V.IdVehicle) as Total
    FROM VehicleTypes VT INNER JOIN Vehicles V
      ON VT.IdVehicleType = V.VehicleType
    WHERE VT.DescriptionVehicleType IN ('Car', 'Light rigid heavy vehicle', 
                                     'Medium rigid heavy vehicle',
                                     'Heavy rigid vehicle', 'Tractor')
          AND EXTRACT(YEAR FROM V.BoughtDateVehicle) >= EXTRACT(YEAR FROM CURRENT_DATE)-2;

SELECT * FROM ViewVehiclesIn2Years;

-- Para que traiga datos puede probar con 6
SELECT V.NumberVehicle, V.MileageVehicle, V.ModelVehicle, V.CurrentValueVehicle, 
       V.ReplacementValueVehicle, V.StateVehicle, VT.SpecialQualification,
       FunTotalServices(V.IdVehicle) as Times, FunSumTotalServices(V.IdVehicle) as Total
FROM VehicleTypes VT INNER JOIN Vehicles V
  ON VT.IdVehicleType = V.VehicleType
WHERE VT.DescriptionVehicleType IN ('Car', 'Light rigid heavy vehicle', 
                                 'Medium rigid heavy vehicle',
                                 'Heavy rigid vehicle', 'Tractor')
      AND EXTRACT(YEAR FROM V.BoughtDateVehicle) >= EXTRACT(YEAR FROM CURRENT_DATE)-6;
          
/* 5. Create a function to assign the name of the service, this function should return a string. The string
      must have the number of mileages run, and remember each revision is performed every 3 months, the
      name has the structure "mileage_service", for instance (3000_service, 6000_service, 9000_service). If
      the name already exist in the service table for that vehicle, must return an empty string, otherwise you
      need to calculate the number based on the current mileage, for instance, if the mileage of the car is
      11560 miles the name should return "9000_service". (0.5) */
CREATE OR REPLACE FUNCTION FunCreateNameService(VehicleId IN number)
RETURN VARCHAR IS
   response VARCHAR(200) := '';
   mileage VARCHAR(200) := '';
   exist NUMBER(1) := 0;
BEGIN
    SELECT TRUNC(MileageVehicle/3000)*3000 INTO mileage 
    FROM Vehicles WHERE IdVehicle = VehicleId;
    
    SELECT COUNT(*) INTO exist FROM Services WHERE NameService = (mileage||'_service');
    
    IF exist >= 1
    THEN
      DBMS_OUTPUT.put_line('Response empty');
      RETURN response;
    END IF;
    
    SELECT mileage || '_service' INTO response FROM DUAL;
    
    RETURN response;
END;  

SELECT FunCreateNameService(1) FROM DUAL;
 
 /* 6. Create a stored procedure which accepts the id of vehicle as argument, inside the procedure you
       should:
       a. Call the function to assign the name of the service
       b. If the string is not empty, create a new service for that vehicle in 
          status "Pending", current date, the description field should contains 
          next text "Mandatory '9000_service' service; current mileage '9123'". 
          If the string is empty do nothing.
       c. Associate all the types of services to the service, for each type of 
          service the status column must have the value "Pending". (0.5)*/
CREATE OR REPLACE PROCEDURE ProcInsertNewService(VehicleId IN number) AS
  response NUMBER := 0;
  service_name VARCHAR(200);
BEGIN
    service_name := FunCreateNameService(VehicleId);
 
    DBMS_OUTPUT.PUT_LINE('SERVICE NAME: '||service_name);
    IF NVL(service_name, NULL) IS NOT NULL
    THEN
        INSERT INTO Services (NameService, Vehicle, IssueDate, DescriptionService, StatusService, TotalService) 
           VALUES (service_name, VehicleId, CURRENT_DATE,'New Service','Pending', 0);
           
        INSERT INTO ServiceDetails (Service, ServiceType, StatusServiceDetail, ValueServiceDetail)
        SELECT SeqServices.currval, IdServiceType, 'Pending', 0
        FROM ServiceTypes;
        
        COMMIT;
    END IF;
END;

EXEC ProcInsertNewService(1);

SELECT * FROM Services;
SELECT * FROM ServiceDetails;

/* 7. Create a trigger which once the mileage column is updated, call the procedure 
      just created. (0.5)*/
CREATE OR REPLACE TRIGGER TriMileageVehicles
AFTER UPDATE OF MileageVehicle ON Vehicles FOR EACH ROW 
DECLARE
  VehicleId NUMBER;
BEGIN
    VehicleId := :new.IdVehicle;
    DBMS_OUTPUT.PUT_LINE('WAS MODIFIED: '|| VehicleId);
    ProcInsertNewService(VehicleId);
END;  

/* 8. Create a stored procedure to decrease the current value of vehicles as follows:
      a. If the class of vehicle is Moped, Motorcycle and Trike motorcycle 2% of the current value.
      b. If the class of vehicle is Car, Light rigid heavy vehicle, Medium rigid heavy vehicle 3% of the
         current value.
      c. Otherwise 5% of the current value.
      d. Only "manager_profile " is allowed to run the procedure and should print at the end "Number of
         vehicles updated successfully: xx" (0.5) */
CREATE OR REPLACE PROCEDURE ProcDecreaseValueVehicles AS
  response NUMBER := 0;
BEGIN
    UPDATE 
    (
        SELECT V.CurrentValueVehicle OLD, V.CurrentValueVehicle - ((V.CurrentValueVehicle / 100) * 2) NEW
        FROM VehicleTypes VT INNER JOIN Vehicles V
          ON VT.IdVehicleType = V.VehicleType
        WHERE VT.DescriptionVehicleType IN ('Moped', 'Moped', 'Trike motorcycle')
    ) Temp
    SET Temp.OLD = Temp.NEW;    
    
    UPDATE 
    (
        SELECT V.CurrentValueVehicle OLD, V.CurrentValueVehicle - ((V.CurrentValueVehicle / 100) * 3) NEW
        FROM VehicleTypes VT INNER JOIN Vehicles V
          ON VT.IdVehicleType = V.VehicleType
        WHERE VT.DescriptionVehicleType IN ('Car', 'Light rigid heavy vehicle', 'Medium rigid heavy vehicle')
    ) Temp
    SET Temp.OLD = Temp.NEW;
    
    UPDATE 
    (
        SELECT V.CurrentValueVehicle OLD, V.CurrentValueVehicle - ((V.CurrentValueVehicle / 100) * 5) NEW
        FROM VehicleTypes VT INNER JOIN Vehicles V
          ON VT.IdVehicleType = V.VehicleType
        WHERE VT.DescriptionVehicleType NOT IN ('Moped', 'Moped', 'Trike motorcycle', 
                                                'Car', 'Light rigid heavy vehicle', 
                                                'Medium rigid heavy vehicle')
    ) Temp
    SET Temp.OLD = Temp.NEW;
END;
      
EXEC ProcDecreaseValueVehicles();

SELECT * FROM Vehicles;

-- BORRADO DE TRIGGERS
DROP TRIGGER TriSeqDrivers;
DROP TRIGGER TriSeqVehicleTypes;
DROP TRIGGER TriSeqVehicles;
DROP TRIGGER TriSeqDriverQualifications;
DROP TRIGGER TriSeqVehiclesPerDriver;
DROP TRIGGER TriSeqServiceTypes;
DROP TRIGGER TriSeqServices;
DROP TRIGGER TriSeqServiceDetails;
DROP TRIGGER TriSeqRepairCosts;
DROP TRIGGER TriSeqInsuranceClaims;

-- BORRADO DE TABLAS
DROP TABLE RepairCosts;
DROP TABLE InsuranceClaims;
DROP TABLE ServiceDetails;
DROP TABLE Services;
DROP TABLE ServiceTypes;
DROP TABLE DriverQualifications;
DROP TABLE VehiclesPerDriver;
DROP TABLE Vehicles;
DROP TABLE VehicleTypes;
DROP TABLE Drivers;

-- BORRADO DE SECUENCIAS
DROP SEQUENCE SeqDrivers;
DROP SEQUENCE SeqVehicleTypes;
DROP SEQUENCE SeqDriverQualifications;
DROP SEQUENCE SeqVehicles;
DROP SEQUENCE SeqVehiclesPerDriver;
DROP SEQUENCE SeqServiceTypes;
DROP SEQUENCE SeqServices;
DROP SEQUENCE SeqServiceDetails;
DROP SEQUENCE SeqRepairCosts;
DROP SEQUENCE SeqInsuranceClaims;