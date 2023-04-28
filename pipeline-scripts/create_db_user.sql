-- Set up substitution variables for apex_username and apex_password
DEFINE apex_username=&1
DEFINE apex_password=&2

-- Create user with password
CREATE USER &&apex_username IDENTIFIED BY &&apex_password;

-- Grant necessary privileges
GRANT CREATE CLUSTER TO &&apex_username;
GRANT CREATE DIMENSION TO &&apex_username;
GRANT CREATE INDEXTYPE TO &&apex_username;
GRANT CREATE JOB TO &&apex_username;
GRANT CREATE MATERIALIZED VIEW TO &&apex_username;
GRANT CREATE OPERATOR TO &&apex_username;
GRANT CREATE PROCEDURE TO &&apex_username;
GRANT CREATE SEQUENCE TO &&apex_username;
GRANT CREATE SESSION TO &&apex_username;
GRANT ALTER SESSION TO &&apex_username;
GRANT CREATE SYNONYM TO &&apex_username;
GRANT CREATE PUBLIC SYNONYM TO &&apex_username;
GRANT CREATE TABLE TO &&apex_username;
GRANT CREATE TRIGGER TO &&apex_username;
GRANT CREATE TYPE TO &&apex_username;
GRANT CREATE VIEW TO &&apex_username;

-- Additional/Recommended 
GRANT CONNECT TO &&apex_username;
GRANT RESOURCE TO &&apex_username;

-- Removed recently by APEX Team ( likely for security reasons) required for Logger
GRANT CREATE ANY CONTEXT TO &&apex_username;

-- Default Tablespace fix
DECLARE
  v_username VARCHAR2(100) := UPPER('&&apex_username');
  v_tablespace VARCHAR2(100);
BEGIN
  -- Get default tablespace for user
  SELECT default_tablespace INTO v_tablespace FROM dba_users WHERE username = v_username;
  
  -- Grant unlimited quota on tablespace to user
  EXECUTE IMMEDIATE 'ALTER USER ' || v_username || ' QUOTA UNLIMITED ON ' || v_tablespace;
END;
/

-- Logger Installation fix (even if you have no plans to install logger)
GRANT SELECT ON sys.v_$parameter TO &&apex_username;

EXIT;
