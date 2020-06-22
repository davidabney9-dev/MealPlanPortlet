# MealPlanPortlet
JICS portlet designed to allow students to select their meal plans.  This portlet is designed to worked with Jenzabar CX using an Informix Database.

-------------------------------------------------------------------------------
JICS Portlet Installation Instructions
-------------------------------------------------------------------------------

Base JICS Version: 9.0
NOTE: This portlet was built using bootstrap and is responsive, so it is only 
designed to work on JICS 9.

1. Unzip the contents of the archive into a location of your choosing on the
 JICS server.
2. Set SyncGlobalOperationsOnStart to true in Program Files\Jenzabar\ICS.NET\Portal\web.config
3. Edit or create Program Files\Jenzabar\ICS.NET\Portal\ClientConfig\CustomSessionFactory.xml. 
If the file doesn't exist, follow instructions to create the file, making sure it has the following entry:
	<SessionFactory>CNTRMealPlan.NHibernateFactory, CNTRMealPlan</SessionFactory>
5. Copy Compiled\ICS.NET\ into Program Files\Jenzabar\ICS.NET\
6. Copy the CNTRMealPlan.ldf and CNTRMealPlan.vbs to your JICS server and 
execute CNTRTabDropDown.vbs there -- this should create two entries in AD LDS 
representing the PortletTemplate for this portlet
7. Visit the JICS site in a browser to cause the site to load
8. Once the portlet is setup, set SyncGlobalOperationsOnStart to false in 
Program Files\Jenzabar\ICS.NET\Portal\web.config
9. Go to Global Portlet Operations settings under site manager and give a base
 role the permissions to administer the portlet.

Important Note: Centre College only cared about meal plans for the Fall and
Spring, so if you want students to be able edit meal plans for all semesters,
then you will need to modify the portlet. Please contact david.abney@centre.edu
to figure out how to do this modification. 


-------------------------------------------------------------------------------
JICS Scheduled Job Instructions
-------------------------------------------------------------------------------

There is a JICS scheduled job that emails all students

1. Makes sure the CNTRMealPlanEmail.dll file has been copied to the 
<JICSInstallDir>\Portal\bin folder (this should have been done in step 1 of the
portlet installation).
2. Open a command window on the server and navigate to 
<JICSInstallDir>\Portal\bin
3. Execute the following command "JICSScheduler.exe installCustomJobs"


-------------------------------------------------------------------------------
CX Schema Instructions
-------------------------------------------------------------------------------

There are two custom tables that need to be installed to for this portlet.

1. CNTRmealcal - mealselect_cal_rec - stores the begin and end date for the 
meal plan edit periods.
2. CNTRtmealplan - cntr_mplan_table - stores the meal plan codes and descriptions

The text of the schema files are provided, please use the make commands to add
the schemas to your database.

There are 4 records that need to be added to the CX config_table that can be 
found in the mealplan_configtable_rows.txt file, please add those rows to your
config_table.  Customize these settings to be specific to your school.
