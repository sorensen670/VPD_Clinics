/* IA 643 Database Security and Auditing
 Script file for Project 6 Virtual Private Database
 Spring 2021
 Dr. Jim Q. Chen
 Aliana Health Systems

 Coding Scheme:
Clinic ID: 3xx;   Doctor ID: 4xxx; 	Patient ID: 5xxxx;
Visit ID: 6xxxxx; Diagnosis ID: 'Rxxxxxx'; Admin_ID:22XX

*/

DROP TABLE APP_USER;
Drop Table Diagnosis;
Drop table Visit;
Drop Table Administrator;
Drop Table Patient;
Drop Table Doctor;
DROP TABLE Clinic;


-- Creating Tables and Inserting values.

CREATE TABLE Clinic (
       Clinic_ID           NUMBER(3) CONSTRAINT Clinic_Pk PRIMARY KEY,
       Clinic_Name         VARCHAR2(30) NOT NULL,
       Clinic_Address       VARCHAR2(50) NOT NULL,
       CITY                 VARCHAR2(30) NOT NULL,
       STATE                VARCHAR2(2) NOT NULL,
       ZIPCODE              VARCHAR2(9) NOT NULL,
       PHONE                VARCHAR2(15) NOT NULL,
       FAX                  VARCHAR2(15) NOT NULL,
       EMAIL                VARCHAR2(50) NOT NULL,
       URL                  VARCHAR2(50) NOT NULL,
       STATUS               VARCHAR2(10) NOT NULL,
       CTL_SEC_USER         VARCHAR2(30) NULL,
       CTL_SEC_LEVEL        NUMBER NULL);


INSERT INTO Clinic VALUES(
301, 'SML Medical Clinic', '740 South 4th Ave.', 'St. Cloud','MN', '56301','3203084992',
'3203084896','mcs@sml.com', 'www.smlstcloud.com','A','ADMINA', 1);

INSERT INTO Clinic VALUES(
302, 'Riverside Health Center', '278 W. Division Street', 'St.Cloud','MN','56301','3203184997',
'3203185897','shc@sml.com', 'www.smlstcloud.com','A','ADMINB', 1);

CREATE TABLE Doctor(
       Doctor_ID          NUMBER(4) CONSTRAINT Doctor_PK PRIMARY KEY,
       Clinic_ID           NUMBER(3) CONSTRAINT Doctor_Clinic_ID_FK REFERENCES Clinic (Clinic_ID),
       FIRST_NAME             VARCHAR2(20) NOT NULL,
       LAST_NAME              VARCHAR2(20) NOT NULL,
       DOB		      Date NOT NULL,
       Sex		      CHAR(1),
       Speciality                   Varchar2(30),
       CTL_SEC_USER         VARCHAR2(30) NULL,
       CTL_SEC_LEVEL        NUMBER NULL
);

INSERT INTO Doctor VALUES(
4001, 301,'Robert','Davison', '12-Mar-1962','M','Cardio', 'ADMINA', 4);

INSERT INTO Doctor VALUES(
4002, 302,'Stephanie','Seymour','23-Jun-1983', 'F', 'Liver','ADMINB', 4);

-- additional doctor records
INSERT INTO Doctor VALUES (
4003, 301,'Tina', 'Hemming',  '2-Nov-1972','F','Family', 'ADMINS', 4);

INSERT INTO Doctor VALUES (
4004, 302,'Kevin', 'McCain', '20-Oct-1980', 'M', 'Family', 'ADMINT', 4);

CREATE TABLE Patient (
       Patient_ID           NUMBER(5) CONSTRAINT Patient_PK PRIMARY KEY,
       Doctor_ID            NUMBER(4) CONSTRAINT Patient_Doctor_ID_FK REFERENCES Doctor (Doctor_ID),
       FIRST_NAME           VARCHAR2(20) NOT NULL,
       LAST_NAME            VARCHAR2(20) NOT NULL,
       DOB		    Date NOT NULL,
       Sex		    CHAR(1),
       CTL_SEC_USER         VARCHAR2(30) NULL,
       CTL_SEC_LEVEL        NUMBER NULL
);

INSERT INTO Patient VALUES(
51001,4001,'John','Hansen', '12-Mar-1996','M', 'RDAVISON', 4);

INSERT INTO Patient VALUES(
51002,4002,'Stephanie','Smith','23-Jun-1992', 'F', 'SSEYMOUR', 4);

-- additional patient records
INSERT INTO Patient VALUES(
51003, 4003,'Dustin','Hansen', '12-Jun-1991','M', 'THEMMING', 4);

INSERT INTO Patient VALUES(
51004, 4004,'Leila','Smith','2-Aug-1968', 'F', 'KMCCAIN', 4);

CREATE TABLE Visit (
       Visit_ID             NUMBER(6) CONSTRAINT Visit_PK PRIMARY KEY,
       Doctor_ID            NUMBER(4) CONSTRAINT Visit_Doc_FK REFERENCES Doctor,
       Patient_ID  	    NUMBER(5) CONSTRAINT Visit_Pat_FK REFERENCES Patient,
       Clinic_ID            NUMBER(3) CONSTRAINT Visit_Clinic_Fk REFERENCES Clinic,
       Visit_Date	    Date NOT NULL,
       Visit_Type	    CHAR(1) NOT NULL,
       CTL_SEC_USER         VARCHAR2(30) NULL,
       CTL_SEC_LEVEL        NUMBER NULL
);

INSERT INTO Visit VALUES(
620001,4001, 51001,301,'8-Oct-16','W', 'RDAVISON', 4);
INSERT INTO Visit VALUES(
620002,4001, 51001,301,'23-Nov-15', 'D', 'RDAVISON', 4);

INSERT INTO Visit VALUES(
620003,4002, 51002, 302,'2-Aug-16','D', 'SSEYMOUR', 4);
INSERT INTO Visit VALUES(
620004,4002, 51002,302, '12-Nov-15','D','SSEYMOUR', 4);
INSERT INTO Visit VALUES(
-- additional visit records
620005,4003, 51003,301,'18-Oct-16','W', 'THEMMING', 4);
INSERT INTO Visit VALUES(
620006,4003, 51003,301,'21-Nov-15', 'D', 'THEMMING', 4);
INSERT INTO Visit VALUES(
620007,4004, 51004, 302,'22-Aug-16','D', 'KMCCAIN', 4);
INSERT INTO Visit VALUES(
620008,4004, 51004,302, '12-DEC-15','D','KMCCAIN', 4);

CREATE TABLE Diagnosis (
       Diagnosis_ID      VARCHAR2(7) CONSTRAINT Diagnosis_Pk PRIMARY KEY,
       ICD_Code	         VARCHAR2(5) ,
       Diagnosis_Detail  VARCHAR2(260) NOT NULL,
       Visit_ID	         NUMBER(6) CONSTRAINT Diag_Visit_FK REFERENCES Visit,
       Date_of_Diagnosis DATE,
       CTL_SEC_USER      VARCHAR2(30) NULL,
       CTL_SEC_LEVEL     NUMBER NULL
);


INSERT INTO Diagnosis VALUES(
'R123456','C00', 'Neoplasms of lip; advanced stage; bleeding around the corner of left side', 620001,'12-Oct-2016','RDAVISON',5);

INSERT INTO Diagnosis VALUES(
'R223456','B15.9', 'Hepatitis A; Progressive bowl movement leads to headache.', 620001,'10-Oct-2016','RDAVISON',5);

INSERT INTO Diagnosis VALUES (
'R323456',NULL,'a cranial tumour in the right frontal lobe. The diagnosis explains her symptoms of persistent and worsening headache over the last four weeks.', 620003, '2-Aug-2016','SSEYMOUR',5);

INSERT INTO Diagnosis VALUES (
'R423456',NULL,'Stool bloods spotted three times. Possible column polyps. Colon ascopy exam ordered', 620004, '13-NOV-2016','SSEYMOUR',5);

INSERT INTO Diagnosis VALUES (
'R523456',NULL,'Allergies', 620002, '23-NOV-2015','RDAVISON',5);

--additional diaggnosis records
INSERT INTO Diagnosis VALUES(
'R623456',NULL, 'Flu', 620005,'18-Oct-2016','THEMMING',5);

INSERT INTO Diagnosis VALUES(
'R723456',NULL, 'Ear infection', 620006,'21-NOV-2015','THEMMING',5);

INSERT INTO Diagnosis VALUES (
'R823456',NULL,'Kidney infection', 620007, '22-Aug-2016','KMCCAIN',5);

INSERT INTO Diagnosis VALUES (
'R923456',NULL,'Left foot ankle bone #4 infection due to early foot injury', 620008, '13-DEC-2015','KMCCAIN',5);

INSERT INTO Diagnosis VALUES (
'R103456',NULL,'Diarrhea', 620008, '13-NOV-2015','KMCCAIN',5);


CREATE TABLE Administrator (
       Admin_ID             NUMBER(4) CONSTRAINT Admin_PK PRIMARY KEY,
       Clinic_ID  	    NUMBER(3) NOT NULL,
       FIRST_NAME           VARCHAR2(20) NOT NULL,
       LAST_NAME            VARCHAR2(20) NOT NULL,
       CTL_SEC_USER         VARCHAR2(20) NULL,
       CTL_SEC_LEVEL        NUMBER NULL
);
INSERT INTO Administrator VALUES(
2201, 301, 'Adam','Chen', 'ADMINA', 5);
INSERT INTO Administrator VALUES(
2202, 302, 'Bob','Lewis', 'ADMINB', 5);

-- additional Admin records
INSERT INTO Administrator VALUES (
2203, 301, 'Steve', 'Strong', 'ADMINS', 5);
INSERT INTO Administrator VALUES (
2204, 302, 'Ted', 'Lee', 'ADMINT', 5);

CREATE TABLE App_User (
       APP_User_ID       NUMBER(3) CONSTRAINT User_PK PRIMARY KEY,
       EMP_ID		 NUMBER (4),
       USER_TYPE         CHAR(1),
       APP_USERNAME      VARCHAR2(30) NOT NULL,
       CTL_SEC_USER      VARCHAR2(20) NULL,
       CTL_SEC_LEVEL     NUMBER NULL
);
INSERT INTO App_User VALUES(
501, 2201, 'A', 'AdminA', 'DBA643', 5);
INSERT INTO App_User VALUES(
502, 2202, 'A','AdminB', 'DBA643', 5);
INSERT INTO App_User VALUES(
503, 4001, 'D', 'RDavison', 'DBA643', 5);
INSERT INTO App_User VALUES(
504, 4002, 'D','SSeymour', 'DBA643', 5);
INSERT INTO App_User VALUES(
555, 4009, 'A','DBA643', 'DBA643', 5);

-- additional App_user records
INSERT INTO App_User VALUES (
505, 2203, 'A', 'AdminS', 'DBA643', 5);
INSERT INTO App_User VALUES (
506, 2204, 'A','AdminT', 'DBA643', 5);
INSERT INTO App_User VALUES (
507, 4003, 'D', 'THemming', 'DBA643', 5);
INSERT INTO App_User VALUES (
508, 4004, 'D','KMcCain', 'DBA643', 5);
