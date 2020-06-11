using CNTRMealPlan.Entities;
using CNTRMealPlan.Facades;
using Jenzabar.Common.ApplicationBlocks.ExceptionManagement;
using Jenzabar.ICS.Web.Portlets.Common;
using Jenzabar.Portal.Framework.Settings;
using Jenzabar.Portal.Framework.Web.UI;
using Jenzabar.Portal.Framework.Web.UI.Controls.MetaControls;
using StructureMap;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CNTRMealPlan
{
    public partial class Admin_View : PortletViewBase
    {
        private static string alert = "warning";
        private static string success = "info";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsFirstLoad)
            {
                InitializePage();
            }
        }

        private void InitializePage()
        { 
            PopulateAcadYears();

            if (ddlAcadYear.SelectedIndex > -1)
                PopulateEditPeriods(ddlAcadYear.SelectedValue);

            PopulateMealPlans();
            PopulateEmailSettings();
        }

        private void PopulateEmailSettings()
        {
            EmailMessage settings = new EmailMessage();

            tbxToAddress.Text = settings.To.Trim();
            tbxFromAddress.Text = settings.From.Trim();
            tbxSubject.Text = settings.Subject.Trim();
            tbxMessage.Text = settings.Message.Trim();
        }

        private void PopulateAcadYears()
        {
            AcademicCalendarFacade acadCalFacade = new AcademicCalendarFacade();
            List<AcademicCalendar> acYears = new List<AcademicCalendar>();

            //Get the current and next academic years
            string acyr = acadCalFacade.ACyrFromDate(DateTime.Today);
            var currACYR = acadCalFacade.getAcadCalByAcadYr(acyr, "FA", "UNDG");
            var nextACYR = acadCalFacade.getfNextACYr(currACYR);

            ddlAcadYear.Items.Add(new ListItem(Helpers.MealPlanResources.FormatACYR(currACYR.AcademicYear), currACYR.AcademicYear));
            if (nextACYR != null)
                ddlAcadYear.Items.Add(new ListItem(Helpers.MealPlanResources.FormatACYR(nextACYR.AcademicYear), nextACYR.AcademicYear));

            ddlAcadYear.SelectedValue = currACYR.AcademicYear;
        }

        private void PopulateEditPeriods(string acyr)
        {
            ClearMessage(ltrlEditPeriodMsg);
            AcademicCalendarFacade acadCalFacade = new AcademicCalendarFacade();

            try
            {
                foreach (string sess in Helpers.MealPlanResources.sessions.Keys)
                {
                    AcademicCalendar acadCal = acadCalFacade.getAcadCalByAcadYr(acyr, sess, Helpers.MealPlanResources.prog);
                    if (acadCal != null)
                    {
                        MealPlanEditPeriod mpEditPeriod = new MealPlanEditPeriod(acadCal, sess);

                        TextBox tbxBegDate = (TextBox)this.FindControl("tbx" + sess + "BegDate");
                        TextBox tbxEndDate = (TextBox)this.FindControl("tbx" + sess + "EndDate");

                        tbxBegDate.Text = mpEditPeriod.BegDate.Value.ToShortDateString();
                        tbxEndDate.Text = mpEditPeriod.EndDate.Value.ToShortDateString();
                    }
                    else
                    {
                        ShowMessage(ltrlEditPeriodMsg, alert, "The system cannot find an academic calendar for the " + Helpers.MealPlanResources.sessions[sess] + " term.");
                        return;
                    }
                }
            }
            catch (Exception ex)
            {
                ExceptionManager.Publish(ex);
                ShowMessage(ltrlEditPeriodMsg, alert, "The system encountered an error, please try again.");
            }

        }


        protected void btnSaveEditPeriods_Click(object sender, EventArgs e)
        {
            ClearMessage(ltrlEditPeriodMsg);

            foreach (string sess in Helpers.MealPlanResources.sessions.Keys)
            {
                DateTime begDate = new DateTime();
                DateTime endDate = new DateTime();
                TextBox tbxBegDate = (TextBox)this.FindControl("tbx" + sess + "BegDate");
                TextBox tbxEndDate = (TextBox)this.FindControl("tbx" + sess + "EndDate");

                if (!DateTime.TryParse(tbxBegDate.Text.Trim(), out begDate) || !DateTime.TryParse(tbxEndDate.Text.Trim(), out endDate))
                {
                    ShowMessage(ltrlEditPeriodMsg, alert, "The begin date entered for the " + sess.Trim() + " term is not a valid date, please try again.");
                    return;
                }

                Helpers.MealPlanResources.AddDateRanges(ddlAcadYear.SelectedValue, sess, begDate, endDate);
                
            }

            ShowMessage(ltrlEditPeriodMsg, success, "The system successfully saved the edit periods.");
        }

        protected void ddlAcadYear_SelectedIndexChanged(object sender, EventArgs e)
        {
            ClearMessage(ltrlEditPeriodMsg);

            if (ddlAcadYear.SelectedIndex > -1)
            {
                ClearEditPeriodScreen();
                PopulateEditPeriods(ddlAcadYear.SelectedValue);
            }
            else
                ShowMessage(ltrlEditPeriodMsg, alert, "Invalid academic year, please try again.");
        }

        protected void ddlMealPlan_SelectedIndexChanged(object sender, EventArgs e)
        {
            ClearMessage(ltrlEditMealPlanMsg);

            if (ddlMealPlan.SelectedIndex > -1 && ddlMealPlan.SelectedValue != "-1")
            {
                GetMealPlanInfo(ddlMealPlan.SelectedValue);
            }
            else
                ShowMessage(ltrlEditMealPlanMsg, alert, "Invalid meal plan option, please try again.");
        }

        private void GetMealPlanInfo(string code)
        {
            MealPlanFacade mealPlanFacade = new MealPlanFacade();
            CNTRMealPlan.Facades.MealPlan mealPlan = mealPlanFacade.getMealPlan(code);

            if (mealPlan != null)
            {
                if (!String.IsNullOrEmpty(mealPlan.Name))
                    tbxPlanName.Text = mealPlan.Name.Trim();
                else
                    tbxPlanName.Text = String.Empty;

                if (!String.IsNullOrEmpty(mealPlan.Description))
                    tbxPlanDescr.Text = mealPlan.Description.Trim();
                else
                    tbxPlanDescr.Text = String.Empty;

                cbxChange.Checked = mealPlan.CanChange;
            }
            else
                ShowMessage(ltrlEditMealPlanMsg, alert, "Unable to find the meal plan, please try again.");
        }

        protected void btnSaveMealPlan_Click(object sender, EventArgs e)
        {
            ClearMessage(ltrlEditMealPlanMsg);

            if (ddlMealPlan.SelectedIndex > -1 && ddlMealPlan.SelectedValue != "-1")
            {
                MealPlanFacade mealPlanFacade = new MealPlanFacade();
                CNTRMealPlan.Facades.MealPlan mealPlan = mealPlanFacade.getMealPlan(ddlMealPlan.SelectedValue);

                if (!String.IsNullOrEmpty(tbxPlanName.Text.Trim()))
                {
                    mealPlan.Name = tbxPlanName.Text.Trim();
                    mealPlan.Description = tbxPlanDescr.Text.Trim();
                    mealPlan.CanChange = cbxChange.Checked;
                    mealPlanFacade.Save(mealPlan);
                    ShowMessage(ltrlEditMealPlanMsg, success, "Meal plan successfully saved.");
                    ClearMealPlanScreen();
                }
                else
                {
                    ShowMessage(ltrlEditMealPlanMsg, alert, "You must enter a meal plan name before saving.");
                }
            }
            else
            {
                ShowMessage(ltrlEditMealPlanMsg, alert, "Invalid meal plan option, please try again.");
            }
        }

        protected void btnRemoveMealPlan_Click(object sender, EventArgs e)
        {
            ClearMessage(ltrlEditMealPlanMsg);

            if (ddlMealPlan.SelectedIndex > -1 && ddlMealPlan.SelectedValue != "-1")
            {
                MealPlanFacade mealPlanFacade = new MealPlanFacade();
                CNTRMealPlan.Facades.MealPlan mealPlan = mealPlanFacade.getMealPlan(ddlMealPlan.SelectedValue);

                mealPlan.InactiveDate = DateTime.Today;
                mealPlanFacade.Save(mealPlan);
                ShowMessage(ltrlEditMealPlanMsg, success, "Meal plan successfully removed.");
                ClearMealPlanScreen();
                ddlMealPlan.Items.Clear();
                PopulateMealPlans();
            }
            else
            {
                ShowMessage(ltrlEditMealPlanMsg, alert, "Invalid meal plan option, please try again.");
            }
        }

        private void ClearEditPeriodScreen()
        {
            foreach (string sess in Helpers.MealPlanResources.sessions.Keys)
            {
                TextBox tbxBegDate = (TextBox)this.FindControl("tbx" + sess + "BegDate");
                TextBox tbxEndDate = (TextBox)this.FindControl("tbx" + sess + "EndDate");
                tbxBegDate.Text = String.Empty;
                tbxEndDate.Text = String.Empty;
            }
        }

        private void ClearMealPlanScreen()
        {
            ddlMealPlan.SelectedValue = "-1";
            tbxPlanName.Text = String.Empty;
            cbxChange.Checked = false;
            tbxPlanDescr.Text = String.Empty;
        }
        
        private void PopulateMealPlans()
        {
            MealPlanFacade mealPlanFacade = new MealPlanFacade();
            List<CNTRMealPlan.Facades.MealPlan> mealPlans = mealPlanFacade.GetQuery()
                                                                            .Where(x => x.InactiveDate == null || x.InactiveDate > DateTime.Today.Date)
                                                                            .OrderBy(x => x.Name).ToList();

            ddlMealPlan.Items.Add(new ListItem("Select a meal plan...", "-1"));

            foreach (CNTRMealPlan.Facades.MealPlan mp in mealPlans)
            {
                ddlMealPlan.Items.Add(new ListItem(mp.Name.Trim(), mp.MealPlanType));
            }
        }

        private void ClearMessage(Literal literal)
        {
            literal.Text = String.Empty;
        }

        private void ShowMessage(Literal literal, string type, string msg)
        {
            literal.Text = "<div class='alert alert-" + type + "' role='alert'>" + msg.Trim() + "</div>";
        }

        protected void btnEditStudentMealPlans_Click(object sender, EventArgs e)
        {
            Response.Redirect(ParentPortlet.GetNextScreenURL("Edit"));
        }

        protected void btnSaveEmail_Click(object sender, EventArgs e)
        {
            if (!String.IsNullOrWhiteSpace(tbxToAddress.Text) && !String.IsNullOrWhiteSpace(tbxFromAddress.Text)
                && !String.IsNullOrWhiteSpace(tbxSubject.Text) && !String.IsNullOrWhiteSpace(tbxMessage.Text))
            {
                EmailMessage emailMsg = new EmailMessage(tbxToAddress.Text.Trim(), tbxFromAddress.Text.Trim(), tbxSubject.Text.Trim(), tbxMessage.Text.Trim());
                if(new EmailMessageFacade().SaveMessageSettings(emailMsg))
                    ShowMessage(ltrlEmailSettingsMsg, success, "The email message settings have been saved.");
                else
                    ShowMessage(ltrlEmailSettingsMsg, alert, "The system encountered an error saving the message, please contact the ITS Helpdesk.");
            }
            else
                ShowMessage(ltrlEmailSettingsMsg, alert, "Please make sure you have entered a to address, from address, subject, and message before saving the email message.");
        }
    }
}