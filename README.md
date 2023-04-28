
# pretius-apex-lifecycle-aligned-utils

# About this Repository

This repository is a set of utilities used by Jenkins for the "Oracle APEX CI/CD: Step-by-step guide aligned to the Application Lifecycle Technical Paper" blog on [Hot off the Application Express](https://mattmulvaney.hashnode.dev). 

These scripts are based on the [scripts](https://apex.oracle.com/go/lifecycle-technical-paper-files) found in the [Oracle APEX Application Development Lifecycle Technical Paper](https://apex.oracle.com/go/lifecycle-technical-paper) v.3 and extend those ideas.

The included **pretius-pipileine.jenkinsfile** file is designed to deploy the [pretius-apex-lifecycle-aligned-sample-customers](https://github.com/Pretius/pretius-apex-lifecycle-aligned-sample-customers) repository. See the **pretius-pipileine.jenkinsfile** section below for more information.

Credits to the APEX Team for providing the initial scripts and Technical Paper.

# pretius-pipileine.jenkinsfile

This pipeline script is designed to (1) Test a Build (2) Run Unit Tests (3) Run Cypress Tests. In brief this consists of

1. Clears Existing Jenkins Workspace
1. Clones a GIT Repo project based on [the proposed Sample-Customers format](https://github.com/Pretius/pretius-apex-lifecycle-aligned-sample-customers)
1. Create temp folder in \tmp\
1. Prints Environment Variables & fetches environment settings from split APEX files
1. Spawns a docker container based on [my blog post re: Docker on 23+ORDS+APEX](https://mattmulvaney.hashnode.dev/oracle-23c-free-docker-apex-ords-all-in-one-simple-guide)
1. Creates Build (not supported due to SQLcl 23.1 LB issues.)
1. Locates the Build i.e Recent zip build file
1. Extracts the Build to temp folder
1. Wait until Docker/APEX ready - takes about 1 minute
1. creates a DB schema based on parsing user in application/set_environment.sql and sub-folder names in \other_schemas
1. Installs all Workspaces
1. Deploys controller.xml found in \other_schemas sub-folders
1. Installs utPLSQL based on instructions from the utPLSQL team
1. Deploys Pre i.e any pre-release scripts
1. Deploy Build i.e APEX and DB components
1. Deploys Post i.e any post-release scripts
1. Deploys Data i.e Table data sync'ed between Dev & Non-Dev environments using lb data command
1. Deploys Test-Only i.e any Test-Only scripts e.g Initial setup/configuration for testing
1. Run utPLSQL Tests in junit format
1. Run Cypress Tests & record Video
1. Remove the Container & Gather Test results

Omitted is a deploy to Test. You'll need a repeat of steps 12-17 with a different connection string

# Folder Structure

The repository structure is as follows:

## export-scripts\windows

| Name          	| Information                                                                                                                                                                           	|
|---------------	|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	|
| apexexport2git.bat | Exports APEX & DB, doesn't wipe out other folders |
| apexexportbuildzip.bat | Builds a zip file for deployment with other required folders 	|


## pipeline

| Name          	| Information                                                                                                                                                                           	|
|---------------	|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	|
| pretius-pipileine.jenkinsfile | Pipeline Script |

## pipeline-scripts

| Name          	| Information                                                                                                                                                                           	|
|---------------	|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	|
| apexexport2git.sh | Exports APEX & DB	|
| apexexportbuildzip.sh | Builds a zip file for deployment 	|
| apexinstallbuild.sh | Installs APEX & DB 	|
| apexinstallchangeset.sh |  Installs a changeset controller file	|
| apexinstallotherschemas.sh | For each sub-folder found, connect as that name and install the controller.xml	|
| apexinstallworkspace.sh | Install all Workspaces in a given folder	|
| create_db_user.sql | Creates DB Users & [Schema Grants required for APEX](https://mattmulvaney.hashnode.dev/oracle-db-schema-grants-required-for-apex) |
| createdbschemas.sh | creates a DB schema based on parsing user in application/set_environment.sql and sub-folder names in \other_schemas |
| createtempfolder.sh | creates a folder	|
| extractbuild.sh| Unzips a build zip file |
| installutPLSQLlatest.sh | Installs utPLSQL	|
| ut_junit_reporter.sh | Runs utPLSQL tests with ut_junit_reporter |
| waitForAPEX.sh | Pauses until APEX is available |

# Customising the jenkinsfile
There are two sections to modify to your requirements

| Name          	| Information                                                                                                                                                                           	|
|---------------	|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	|
| Project Settings | This is for changing to your Repository URL, Branch and Alias. The Alias is used by Cypress for accessing the Application URL	|
| Environment Specifics | Hardcode over the curly bracketed variables in this section if you want custom values, otherwise they are taken from the split files	|

Additionally, change the Jenkins Settings section if require specific environment settings.
