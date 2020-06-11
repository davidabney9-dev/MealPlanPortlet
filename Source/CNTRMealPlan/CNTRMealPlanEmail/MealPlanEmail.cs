using CNTRMealPlan.Entities;
using CNTRMealPlan.Facades;
using CNTRMealPlan.Helpers;
using Jenzabar.Common.ApplicationBlocks.ExceptionManagement;
using Jenzabar.Portal.Framework.Scheduler.Jobs;
using Quartz;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CNTRMealPlanEmail
{
    [DisallowConcurrentExecution]
    public class MealPlanEmail : Job
    {
        private const string ERROR = "Job failed.";
        private const string SUCCESS = "Job successfully completed.";

        public override string RecordedExecute(IJobExecutionContext context)
        {
            try
            {
                //Check if it is time to send Meal Plan Email
                if (TimeToSendEmail())
                {
                    if (SendEmail())
                        return SUCCESS;
                    else
                        return ERROR;
                }
                else
                    return SUCCESS;
            }
            catch (Exception ex)
            {
                ExceptionManager.Publish(ex);
                return ERROR;
            }
        }

        private bool TimeToSendEmail()
        {
            AcademicCalendarFacade acadCalFacade = new AcademicCalendarFacade();
            AcademicCalendar acadCal = acadCalFacade.getCurrentSession();

            if (acadCal != null)
            {
                MealPlanEditPeriod mpEditPeriod = new MealPlanEditPeriod(acadCal, acadCal.Session);
                if (mpEditPeriod.BegDate == DateTime.Today)
                    return true;
            }

            return false;
        }

        private bool SendEmail()
        {
            EmailMessage msg = new EmailMessage();

            try
            {
                MealPlanResources mpResources = new MealPlanResources();
                return mpResources.SendEmail(msg.From, msg.To.Trim(), msg.Message.Trim(), msg.Subject.Trim(), false);
            }
            catch (Exception ex)
            {
                ExceptionManager.Publish(ex);
                return false;
            }
        }
    }
}
