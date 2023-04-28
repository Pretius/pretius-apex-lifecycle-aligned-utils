#!/bin/bash
# APEX Install Build
#-----------------------------
# $1 = Stage folder
# $2 = APEX App Id
# $3 = Workspace name
# $4 = DB connection string
# $5 = New App Alias (optional)
#-----------------------------

cd $1

# Install APEX application and schema to stage directory and apply database changes
{
echo connect $4
echo "declare"
echo "    l_workspace apex_workspaces.workspace%type := q'[$3]';"
echo "    l_app_id apex_applications.application_id%type := q'[$2]';"
echo "    l_connection varchar2(4000) := q'[$4]';"
echo "    l_schema apex_workspace_schemas.schema%type := upper(regexp_substr(l_connection,'[^/]+'));"
echo "    l_app_alias apex_applications.alias%type := q'[$5]';"
echo "begin"
echo "    apex_application_install.set_workspace(l_workspace);"
echo "    apex_application_install.set_application_id(l_app_id);"
echo "    if length(l_app_alias) > 0 then"
echo "        apex_application_install.generate_offset();"
echo "        apex_application_install.set_schema(l_schema);"
echo "        apex_application_install.set_application_alias(l_app_alias);"
echo "    end if;"
echo "end;"
echo "/"
echo @install.sql
echo set ddl storage off
echo set ddl partitioning off
echo set ddl segment_attributes off
echo set ddl tablespace off
echo set ddl emit_schema off
echo lb update -changelog-file database/controller.xml
} | sql /nolog

