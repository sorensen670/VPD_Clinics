-- IA 643 script file for project #5
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

DROP USER RDavidson;

  CREATE USER RDavidson IDENTIFIED BY RDavidson
    DEFAULT TABLESPACE IA643Spr21_tbs
    QUOTA 5M ON IA643Spr21_tbs
    TEMPORARY TABLESPACE TEMP
    ACCOUNT UNLOCK;
    GRANT CONNECT,RESOURCE TO RDavidson;

DROP USER SSeymour;

  CREATE USER SSeymour IDENTIFIED BY SSeymour
    DEFAULT TABLESPACE IA643Spr21_tbs
    QUOTA 5M ON IA643Spr21_tbs
    TEMPORARY TABLESPACE TEMP
    ACCOUNT UNLOCK;
    GRANT CONNECT,RESOURCE TO SSeymour;


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
  TO AdminA, AdminB;

GRANT Doctor_R
  TO RDavidson, SSeymour;


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


CREATE OR REPLACE FUNCTION Sec_Fun_Where_User (P_schema_name IN VARCHAR2,
  P_object_name IN VARCHAR2)
  RETURN VARCHAR2 IS

  V_Where VARCHAR2(300);

  BEGIN
    IF USER = 'DBA643' THEN
      V_Where := '';
    ELSE
      V_Where := 'CTL_SEC_USER = USER';
    END IF;
    RETURN V_Where;
  END;
  /

--Create another function to add to Administrator, Doctor, and Clinic
--tables so that doctors can select on records they don't own
CREATE OR REPLACE FUNCTION Sec_Fun_Where_User_Sel (P_schema_name IN VARCHAR2,
  P_object_name IN VARCHAR2)
  RETURN VARCHAR2 IS

  V_Where VARCHAR2 (300);

  BEGIN
    IF USER = 'DBA643' THEN
      V_Where := '';
    ELSIF USER = 'RDavidson' THEN
      V_Where := '';
    ELSIF USER = 'SSeymour' THEN
      V_Where := '';
    ELSE
      V_Where := 'CTL_SEC_USER = USER';
    END IF;
    RETURN V_Where;
  END;
  /



-- Drop then Create policy and add policy functions


EXEC DBMS_RLS.DROP_POLICY('DBA643', 'Diagnosis', 'Row_Owner_Sec_Diagnosis');

EXEC DBMS_RLS.DROP_POLICY('DBA643', 'Visit', 'Row_Owner_Sec_Visit');

EXEC DBMS_RLS.DROP_POLICY('DBA643', 'Administrator', 'Row_Owner_Sec_Administrator');

EXEC DBMS_RLS.DROP_POLICY('DBA643', 'Administrator', 'Row_Owner_Sec_Admin_Doc_Select');

EXEC DBMS_RLS.DROP_POLICY('DBA643', 'Patient', 'Row_Owner_Sec_Patient');

EXEC DBMS_RLS.DROP_POLICY('DBA643', 'Doctor', 'Row_Owner_Sec_Doctor');

EXEC DBMS_RLS.DROP_POLICY('DBA643', 'Doctor', 'Row_Owner_Sec_Doc_Doc_Select');

EXEC DBMS_RLS.DROP_POLICY('DBA643', 'Clinic', 'Row_Owner_Sec_Clinic');

EXEC DBMS_RLS.DROP_POLICY('DBA643', 'Clinic', 'Row_Owner_Sec_Clin_Doc_Select');


--Diagnosis
EXEC DBMS_RLS.ADD_POLICY('DBA643', 'Diagnosis', 'Row_Owner_Sec_Diagnosis', 'DBA643','Sec_Fun_Where_User', 'SELECT, UPDATE, DELETE, INSERT',TRUE);


--Visit
EXEC DBMS_RLS.ADD_POLICY('DBA643', 'Visit', 'Row_Owner_Sec_Visit', 'DBA643', 'Sec_Fun_Where_User', 'SELECT, UPDATE, DELETE, INSERT', TRUE);


--Administrator
EXEC DBMS_RLS.ADD_POLICY('DBA643', 'Administrator', 'Row_Owner_Sec_Administrator', 'DBA643', 'Sec_Fun_Where_User', 'UPDATE, DELETE, INSERT', TRUE);

    --Adds special select policy for Administrator table so doctors can
    --see information on all administrators, but administrators can only
    --see the records they own
    EXEC DBMS_RLS.ADD_POLICY('DBA643', 'Administrator', 'Row_Owner_Sec_Admin_Doc_Select', 'DBA643', 'Sec_Fun_Where_User_Sel', 'SELECT');

--Patient
EXEC DBMS_RLS.ADD_POLICY('DBA643', 'Patient', 'Row_Owner_Sec_Patient', 'DBA643', 'Sec_Fun_Where_User', 'SELECT, UPDATE, DELETE, INSERT', TRUE);

--Doctor
EXEC DBMS_RLS.ADD_POLICY('DBA643', 'Doctor', 'Row_Owner_Sec_Doctor', 'DBA643', 'Sec_Fun_Where_User', 'UPDATE, DELETE, INSERT', TRUE);

    --Doctor select policy for doctor table
    EXEC DBMS_RLS.ADD_POLICY('DBA643', 'Doctor', 'Row_Owner_Sec_Doc_Doc_Select', 'DBA643', 'Sec_Fun_Where_User_Sel', 'SELECT');

--Clinic
EXEC DBMS_RLS.ADD_POLICY('DBA643', 'Clinic', 'Row_Owner_Sec_Clinic', 'DBA643', 'Sec_Fun_Where_User', 'UPDATE, DELETE, INSERT', TRUE);

    --Doctor select policy for clinic table
    EXEC DBMS_RLS.ADD_POLICY('DBA643', 'Clinic', 'Row_Owner_Sec_Clin_Doc_Select', 'DBA643', 'Sec_Fun_Where_User_Sel', 'SELECT');
