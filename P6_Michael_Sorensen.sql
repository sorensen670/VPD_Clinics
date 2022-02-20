-- IA 643 script file for project #6
-- Group Members: Mike Sorensen, Isse Abdi
-- Spring 2021

--Drop tablespaces if created previously
DROP TABLESPACE IA643Spr21_tbs
  INCLUDING Contents AND Datafiles;


--Create a tablespace with a size of 500k, extendable in 300k increment
--up to max of 100M
CREATE TABLESPACE IA643Spr21_tbs
  DATAFILE 'IA643Spr21_dat.dat' SIZE 500K REUSE
  AUTOEXTEND ON NEXT 300K MAXSIZE 100M;


  --Create user accounts with new tablespace as default and temp for
  --temporary tablespace. Drop users first.


DROP USER AdminA;

CREATE USER AdminA IDENTIFIED BY AdminA
  DEFAULT TABLESPACE IA643Spr21_tbs
  QUOTA 5M ON IA643Spr21_tbs
  TEMPORARY TABLESPACE TEMP
  ACCOUNT UNLOCK;
  GRANT CONNECT,RESOURCE TO AdminA;

DROP USER AdminB;

CREATE USER AdminB IDENTIFIED BY AdminB
  DEFAULT TABLESPACE IA643Spr21_tbs
  QUOTA 5M ON IA643Spr21_tbs
  TEMPORARY TABLESPACE TEMP
  ACCOUNT UNLOCK;
  GRANT CONNECT,RESOURCE TO AdminB;

DROP USER AdminS;

CREATE USER AdminS IDENTIFIED BY AdminS
  DEFAULT TABLESPACE IA643Spr21_tbs
  QUOTA 5M ON IA643Spr21_tbs
  TEMPORARY TABLESPACE TEMP
  ACCOUNT UNLOCK;
  GRANT CONNECT,RESOURCE TO AdminS;

DROP USER AdminT;

CREATE USER AdminT IDENTIFIED BY AdminT
  DEFAULT TABLESPACE IA643Spr21_tbs
  QUOTA 5M ON IA643Spr21_tbs
  TEMPORARY TABLESPACE TEMP
  ACCOUNT UNLOCK;
  GRANT CONNECT,RESOURCE TO AdminT;

DROP USER RDavison;

  CREATE USER RDavison IDENTIFIED BY RDavison
    DEFAULT TABLESPACE IA643Spr21_tbs
    QUOTA 5M ON IA643Spr21_tbs
    TEMPORARY TABLESPACE TEMP
    ACCOUNT UNLOCK;
    GRANT CONNECT,RESOURCE TO RDavison;

DROP USER SSeymour;

  CREATE USER SSeymour IDENTIFIED BY SSeymour
    DEFAULT TABLESPACE IA643Spr21_tbs
    QUOTA 5M ON IA643Spr21_tbs
    TEMPORARY TABLESPACE TEMP
    ACCOUNT UNLOCK;
    GRANT CONNECT,RESOURCE TO SSeymour;

DROP USER THemming;

  CREATE USER THemming IDENTIFIED BY THemming
    DEFAULT TABLESPACE IA643Spr21_tbs
    QUOTA 5M ON IA643Spr21_tbs
    TEMPORARY TABLESPACE TEMP
    ACCOUNT UNLOCK;
    GRANT CONNECT,RESOURCE TO THemming;

DROP USER KMcCain;

  CREATE USER KMcCain IDENTIFIED BY KMcCain
    DEFAULT TABLESPACE IA643Spr21_tbs
    QUOTA 5M ON IA643Spr21_tbs
    TEMPORARY TABLESPACE TEMP
    ACCOUNT UNLOCK;
    GRANT CONNECT,RESOURCE TO KMcCain;


--Create public synonyms for all tables except APP_USER

DROP PUBLIC SYNONYM Diagnosis;
DROP PUBLIC SYNONYM Visit;
DROP PUBLIC SYNONYM Administrator;
DROP PUBLIC SYNONYM Patient;
DROP PUBLIC SYNONYM Doctor;
DROP PUBLIC SYNONYM Clinic;

CREATE PUBLIC SYNONYM Diagnosis FOR DBA643.Diagnosis;

CREATE PUBLIC SYNONYM Visit FOR DBA643.Visit;

CREATE PUBLIC SYNONYM Administrator FOR DBA643.Administrator;

CREATE PUBLIC SYNONYM Patient FOR DBA643.Patient;

CREATE PUBLIC SYNONYM Doctor FOR DBA643.Doctor;

CREATE PUBLIC SYNONYM Clinic FOR DBA643.Clinic;


--Create roles for administrators and doctors
DROP ROLE Admin_R;
CREATE ROLE Admin_R;

  GRANT SELECT, INSERT, UPDATE, DELETE
    ON Administrator
    TO Admin_R;

  GRANT SELECT, INSERT, UPDATE, DELETE
    ON Clinic
    TO Admin_R;

  GRANT SELECT, INSERT, UPDATE, DELETE
    ON Doctor
    TO Admin_R;

DROP ROLE Doctor_R;
CREATE ROLE Doctor_R;

  GRANT SELECT, INSERT, UPDATE, DELETE
    ON Patient
    TO Doctor_R;

  GRANT SELECT, INSERT, UPDATE, DELETE
    ON Visit
    TO Doctor_R;

  GRANT SELECT, INSERT, UPDATE, DELETE
    ON Diagnosis
    TO Doctor_R;

  GRANT SELECT
    ON Administrator
    TO Doctor_R;

  GRANT SELECT
    ON Clinic
    TO Doctor_R;

  GRANT SELECT
    ON Doctor
    TO Doctor_R;


--Grant roles to appropriate users

GRANT Admin_R
  TO AdminA, AdminB, AdminS, AdminT;

GRANT Doctor_R
  TO RDavison, SSeymour, THemming, KMcCain;


--Create Triggers for automatic CTL_SEC_USER insertion on insert and update
--For each table

CREATE OR REPLACE TRIGGER Trg_Ins_Upd_User_App_User
  BEFORE INSERT OR UPDATE
  ON APP_USER
  FOR Each Row
    BEGIN
      :new.CTL_SEC_USER := USER;
    END;
    /


CREATE OR REPLACE TRIGGER Trg_Ins_Upd_User_Diagnosis
  BEFORE INSERT OR UPDATE
  ON Diagnosis
  FOR Each Row
    BEGIN
      :new.CTL_SEC_USER := USER;
    END;
    /


CREATE OR REPLACE TRIGGER Trg_Ins_Upd_User_Visit
  BEFORE INSERT OR UPDATE
  ON Visit
  FOR Each Row
    BEGIN
      :new.CTL_SEC_USER := USER;
    END;
    /


CREATE OR REPLACE TRIGGER Trg_Ins_Upd_User_Administrator
  BEFORE INSERT OR UPDATE
  ON Administrator
  FOR Each Row
    BEGIN
      :new.CTL_SEC_USER := USER;
    END;
    /


CREATE OR REPLACE TRIGGER Trg_Ins_Upd_User_Patient
  BEFORE INSERT OR UPDATE
  ON Patient
  FOR Each Row
    BEGIN
      :new.CTL_SEC_USER := USER;
    END;
    /


CREATE OR REPLACE TRIGGER Trg_Ins_Upd_User_Doctor
  BEFORE INSERT OR UPDATE
  ON Doctor
  FOR Each Row
    BEGIN
      :new.CTL_SEC_USER := USER;
    END;
    /


CREATE OR REPLACE TRIGGER Trg_Ins_Upd_User_Clinic
  BEFORE INSERT OR UPDATE
  ON Clinic
  FOR Each Row
    BEGIN
      :new.CTL_SEC_USER := USER;
    END;
    /


CONN sys/Thedawnwall15@ec2-3-231-210-21.compute-1.amazonaws.com:1521/IA643 as SYSDBA;

show user;
DROP USER CSO643 CASCADE;
DROP CONTEXT UserType_ClinicID;

  CREATE USER CSO643 IDENTIFIED BY CSO643;
    GRANT CREATE SESSION, CREATE ANY CONTEXT,
    CREATE PROCEDURE, CREATE TRIGGER,
    ADMINISTER DATABASE TRIGGER TO CSO643;
    GRANT EXECUTE ON DBMS_SESSION TO CSO643;
    GRANT EXECUTE ON DBMS_RLS TO CSO643;
    GRANT RESOURCE TO CSO643;


CONN dba643/msia643_fall@ec2-3-231-210-21.compute-1.amazonaws.com:1521/IA643;
show user;
GRANT SELECT on App_User TO CSO643;
GRANT SELECT on Administrator TO CSO643;
GRANT SELECT on Doctor TO CSO643;
GRANT SELECT on Patient To CSO643;
GRANT SELECT on Visit TO CSO643;
GRANT SELECT on Diagnosis TO CSO643;


CONN CSO643/CSO643@ec2-3-231-210-21.compute-1.amazonaws.com:1521/IA643;
show user;

CREATE OR REPLACE CONTEXT UserType_ClinicID USING PKG_UType_CID;

CREATE OR REPLACE PACKAGE PKG_UType_CID IS
PROCEDURE Get_User_Type;
PROCEDURE Get_Clinic_ID;
PROCEDURE Get_Admin_ID;

END;
/

CREATE OR REPLACE PACKAGE BODY PKG_UType_CID IS
PROCEDURE Get_User_Type IS
  V_UType CHAR;

  BEGIN
    SELECT UPPER(USER_TYPE)
      INTO V_UType
      FROM DBA643.App_User
     WHERE UPPER(APP_USERNAME) = SYS_CONTEXT('USERENV','SESSION_USER');


     DBMS_SESSION.SET_CONTEXT('USERTYPE_CLINICID', 'UserType', V_UType);

     EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
    END Get_User_Type;


 PROCEDURE Get_Clinic_ID IS
     V_CID NUMBER;
     V_UType CHAR;

    BEGIN

    SELECT UPPER(USER_TYPE)
      INTO V_UType
      FROM DBA643.App_User
     WHERE UPPER(APP_USERNAME) = SYS_CONTEXT('USERENV','SESSION_USER');

    IF UPPER(V_UType) = 'A' THEN
      SELECT A.Clinic_ID
        INTO V_CID
        FROM Administrator A INNER JOIN DBA643.App_User U
          ON A.Admin_ID = U.Emp_ID
         WHERE UPPER(U.APP_USERNAME) = SYS_CONTEXT('USERENV','SESSION_USER');

    ELSE
      SELECT D.Clinic_ID
        INTO V_CID
        FROM Doctor D INNER JOIN DBA643.App_User U
          ON D.Doctor_ID = U.Emp_ID
        WHERE UPPER(U.APP_USERNAME) = SYS_CONTEXT('USERENV','SESSION_USER');
      END IF;

    DBMS_SESSION.SET_CONTEXT('USERTYPE_CLINICID', 'ClinicID', V_CID);


    EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
    END Get_Clinic_ID;


PROCEDURE Get_Admin_ID IS

  V_AID NUMBER;

   BEGIN
    SELECT EMP_ID
      INTO V_AID
      FROM DBA643.App_User
     WHERE UPPER(APP_USERNAME) = SYS_CONTEXT('USERENV','SESSION_USER');

    DBMS_SESSION.SET_CONTEXT('USERTYPE_CLINICID', 'AdminID', V_AID);

    EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
    END Get_Admin_ID;

  END;
/
Show Error;


-- policy functions


-- ADMINISTRATOR SECURITY FUNCTION
-- will be used in policy with update,insert,delete for
--administrators to modify records they own in admin, clinic, and doc tables
CREATE OR REPLACE FUNCTION Administrator_Security_Function (P_schema_name IN VARCHAR2,
  P_object_name IN VARCHAR2)
  RETURN VARCHAR2 IS

  V_Where VARCHAR2(300);

  BEGIN

    IF USER = 'DBA643' THEN
      V_Where := '';

    ELSIF USER = 'CSO643' THEN
      V_Where := '';

    ELSIF SYS_CONTEXT('USERTYPE_CLINICID','UserType') = 'D' THEN
      V_Where := '';

    ELSIF SYS_CONTEXT('USERTYPE_CLINICID','UserType') = 'A' THEN
      V_Where := 'Admin_ID = NVL(SYS_CONTEXT(''USERTYPE_CLINICID'', ''AdminID''),0)';
    ELSE
      V_Where := 'Admin_ID = 0000';
    END IF;
    RETURN V_Where;
  END;
  /


--CLINIC TABLE SECURITY FUNCTION
CREATE OR REPLACE FUNCTION Clinic_Security_Function (P_schema_name IN VARCHAR2,
  P_object_name IN VARCHAR2)
  RETURN VARCHAR2 IS

  V_Where VARCHAR2(300);

  BEGIN

    IF USER = 'DBA643' THEN
      V_Where := '';

    ELSIF USER = 'CSO643' THEN
      V_Where := '';

    ELSIF SYS_CONTEXT('USERTYPE_CLINICID','UserType') = 'D' THEN
      V_Where := '';

    ELSIF SYS_CONTEXT('USERTYPE_CLINICID','UserType') = 'A' THEN
      V_Where := 'Clinic_ID IN(Select Clinic_ID from Administrator where Admin_ID = NVL(SYS_CONTEXT(''USERTYPE_CLINICID'', ''AdminID''),0))';
    ELSE
      V_Where := 'Clinic_ID = 000';
    END IF;
    RETURN V_Where;
  END;
  /

--CONN CSO643/CSO643@ec2-3-231-210-21.compute-1.amazonaws.com:1521/IA643;

--Diagnosis table
CREATE OR REPLACE FUNCTION ClinID_Diagnosis_Fun (P_schema_name IN VARCHAR2,
  P_object_name IN VARCHAR2)
  RETURN VARCHAR2 IS

  V_Where VARCHAR2(2000);

  BEGIN


    IF USER = 'DBA643' THEN
      V_Where := '';

        -- elsif statment to allow usertype 'd' get to diagnosis records related to their patients
    ELSIF SYS_CONTEXT('USERTYPE_CLINICID','UserType') = 'D' THEN
         V_Where := 'Visit_ID IN(Select Visit_ID from Visit Where Patient_ID IN(Select Patient_ID from Patient Where Doctor_ID IN(Select Doctor_ID from Doctor where Clinic_id = NVL(SYS_CONTEXT(''USERTYPE_CLINICID'',''ClinicID''),0))))';


          -- Else statement below returns nonexistant visit id clause so that any usertype 'A' (administrator) cannot see/access diagnosis records
    ELSE
     V_Where := 'Diagnosis_ID = ''notvalid''';
    END IF;
    RETURN V_Where;
  END;
  /




--Visit table
CREATE OR REPLACE FUNCTION ClinID_Visit_Fun (P_schema_name IN VARCHAR2,
  P_object_name IN VARCHAR2)
  RETURN VARCHAR2 IS

  V_Where VARCHAR2(1000);

  BEGIN


    IF USER = 'DBA643' THEN
      V_Where := '';


    ELSIF SYS_CONTEXT('USERTYPE_CLINICID','UserType') = 'D' THEN
         V_Where := 'Patient_ID IN(Select Patient_ID from Patient Where Doctor_ID IN(Select Doctor_ID from Doctor where Clinic_id = SYS_CONTEXT(''USERTYPE_CLINICID'',''ClinicID'')))';

       -- Else statement below returns nonexistant visit id clause so that any usertype 'A' (administrator) cannot see/access visit records
    ELSE
     V_Where := 'Visit_ID = 0000';
    END IF;
    RETURN V_Where;
  END;
  /



--Patient table
CREATE OR REPLACE FUNCTION ClinID_Patient_Fun (P_schema_name IN VARCHAR2,
  P_object_name IN VARCHAR2)
  RETURN VARCHAR2 IS

  V_Where VARCHAR2(1000);

  BEGIN


    IF USER = 'DBA643' THEN
      V_Where := '';


    ELSIF SYS_CONTEXT('USERTYPE_CLINICID','UserType') = 'D' THEN
         V_Where := 'Doctor_ID IN(Select Doctor_ID from Doctor Where Clinic_id = SYS_CONTEXT(''USERTYPE_CLINICID'',''ClinicID''))';

         -- Else statement below returns nonexistant visit id clause so that any usertype 'A' (administrator) cannot see/access patient records
    ELSE
     V_Where := 'Patient_ID = 0000';
    END IF;
    RETURN V_Where;
  END;
  /

    -- Drop then Create policy and add policy functions


  EXEC DBMS_RLS.DROP_POLICY('DBA643', 'Diagnosis', 'Diagnosis_Sec_Policy');

  EXEC DBMS_RLS.DROP_POLICY('DBA643', 'Visit', 'Visit_Sec_Policy');

  EXEC DBMS_RLS.DROP_POLICY('DBA643', 'Administrator', 'Admin_Sec_Policy');

  EXEC DBMS_RLS.DROP_POLICY('DBA643', 'Patient', 'Patient_Sec_Policy');

  EXEC DBMS_RLS.DROP_POLICY('DBA643', 'Clinic', 'Clinic_Sec_Policy');



  --Diagnosis
  EXEC DBMS_RLS.ADD_POLICY('DBA643', 'Diagnosis', 'Diagnosis_Sec_Policy', 'CSO643','ClinID_Diagnosis_Fun', 'SELECT, UPDATE, DELETE, INSERT',TRUE);


  --Visit
  EXEC DBMS_RLS.ADD_POLICY('DBA643', 'Visit', 'Visit_Sec_Policy', 'CSO643', 'ClinID_Visit_Fun', 'SELECT, UPDATE, DELETE, INSERT', TRUE);


  --Administrator
  EXEC DBMS_RLS.ADD_POLICY('DBA643', 'Administrator', 'Admin_Sec_Policy', 'CSO643', 'Administrator_Security_Function', 'SELECT, UPDATE, DELETE, INSERT', TRUE);


  --Patient
  EXEC DBMS_RLS.ADD_POLICY('DBA643', 'Patient', 'Patient_Sec_Policy', 'CSO643', 'ClinID_Patient_Fun', 'SELECT, UPDATE, DELETE, INSERT', TRUE);


  --Clinic
  EXEC DBMS_RLS.ADD_POLICY('DBA643', 'Clinic', 'Clinic_Sec_Policy', 'CSO643', 'Clinic_Security_Function', 'SELECT, UPDATE, DELETE, INSERT', TRUE);




CREATE OR REPLACE TRIGGER TRG_ContextSet_AfterLogon
  AFTER LOGON
  ON DATABASE
    begin
      CSO643.PKG_UType_CID.Get_User_Type;
      CSO643.PKG_UType_CID.Get_Clinic_ID;
      CSO643.PKG_UType_CID.Get_Admin_ID;
    END;
    /
Commit;
