:: APEX Export to Git
::-----------------------------
:: %1 = APEX App Id
:: %2 = Git workarea directory
:: %3 = DB connection string
:: %4 = Workspace ID (added by MM)
::-----------------------------
:: Recreate the temporary stage directory and change directory to it
@echo off
if exist %TEMP%\stage_f%1 rmdir /s /q %TEMP%\stage_f%1
mkdir %TEMP%\stage_f%1
cd %TEMP%\stage_f%1
:: Export APEX application and schema to stage directory
(
: echo set cloudconfig \location\of\your\Wallet.zip
echo connect %3
echo apex export -expWorkspace -workspaceId %4
echo apex export -applicationid %1 -split -skipExportDate -expOriginalIds -expSupportingObjects Y -expType APPLICATION_SOURCE,READABLE_YAML
echo set ddl storage off
echo set ddl partitioning off
echo set ddl segment_attributes off
echo set ddl tablespace off
echo set ddl emit_schema off
echo lb genschema -split
) | sql /nolog
:: Copy APEX application export files in the ./fNNN subdirectory to Git Working Area directory
@REM robocopy %TEMP%\stage_f%1\f%1 %2 * /mir /xd ".git" 
robocopy %TEMP%\stage_f%1 %2\workspace w*.sql /move
robocopy %TEMP%\stage_f%1\f%1\application %2\application * /mir /xd ".git"
robocopy %TEMP%\stage_f%1\f%1\readable %2\readable * /mir /xd ".git"
robocopy %TEMP%\stage_f%1\f%1 %2 install.sql
:: Remove APEX export files, leaving only Liquibase DB export artifacts
rmdir /s /q %TEMP%\stage_f%1\f%1
:: Copy the Liquibase DB export artifacts to ./database subdir of Git Working Area
if not exist %2\database mkdir %2\database
robocopy %TEMP%\stage_f%1 %2\database * /mir /xd ".git"
:: Change directory to the Git Workarea 
cd %2
:: Add all changed files to the Git worklist from any subdirectory
:: git add .
