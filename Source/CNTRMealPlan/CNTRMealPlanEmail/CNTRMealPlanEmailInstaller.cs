using Jenzabar.Portal.Framework.Scheduler;
using Jenzabar.Portal.Framework.Scheduler.JobInstallInfo;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CNTRMealPlanEmail
{
    [Custom]
    public class CNTRMealPlanEmailInstaller : JobInstaller
    {
        // To have this job installer create the job in JICS, the compiled ExampleSchedulerJob.dll assembly 
        // must be moved to <JICSInstallDir>\Portal\bin and the JICSScheduler.exe console app must be used.
        // From a command window open to <JICSInstallDir>\Portal\bin, use one of the following commands:
        //  JICSScheduler.exe installCustomJobs
        //  JICSScheduler.exe "CNTRFixAccountCollisions.FixAccountCollisionsInstaller, FixAccountCollisionsJob"

        // Will be detected by JICSScheduler.exe as a custom job installer because of this attribute (see above comment).
        public CNTRMealPlanEmailInstaller()
        {
            JobsToInstall = new List<IJobInstallInfo>
            {
                new CronJobInstallInfo<MealPlanEmail>(
                    "MealPlanEmailJob", //Job name.
                    "MealPlanEmailGroup", // Job group.
                    "MealPlanEmailTrigger", // Trigger name.
                    "MealPlanEmailJobGroup", // Trigger group.
                    "0 0 8 ? * *" // Sec Min Hour DofMon Mon DofWk - Run at 8am every day
                    )
            };
        }
    }
}
