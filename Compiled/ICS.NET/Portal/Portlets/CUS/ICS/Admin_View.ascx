<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Admin_View.ascx.cs" Inherits="CNTRMealPlan.Admin_View" %>

<script>
    $(document).ready(function () {
        EnableDatePickers()
    });

    //re-binding jQuery events for Update Panel
    var prm = Sys.WebForms.PageRequestManager.getInstance();

    prm.add_endRequest(function () {
        $(document).ready(function () {
            EnableDatePickers()
        });
    });

    function EnableDatePickers() {
        $('input[id$="BegDate"]').datepicker();
        $('input[id$="EndDate"]').datepicker();
    }
</script>

<div class="pSection container-fluid">
    <asp:UpdateProgress id="UPLoading" runat="server">
        <ProgressTemplate>
            <div style="position: fixed; text-align: center; height: 100%; width: 100%; top: 0; right: 0; left: 0; z-index: 9999999; background-color: #000000; opacity: 0.7;">
                <asp:Image ID="imgUpdateProgress" runat="server" ImageUrl="~/clientconfig/images/ajax-loader2.gif" AlternateText="Loading ..." ToolTip="Loading ..." style="padding: 10px;position:fixed;top:45%;left:50%;" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
    <asp:UpdatePanel ID="UPMealPlans" runat="server" UpdateMode="Always">
        <ContentTemplate>
            <div class="panel panel-default">
                <div class="panel-heading">Edit Begin and End Dates</div>
                <div class="panel-body form-horizontal">
                    <asp:Literal ID="ltrlEditPeriodMsg" runat="server" />
                    <p class="help-block">Enter the time period for each semester that students will be able to change their meal plans.</p>
                    <div class="form-group">
                        <label for="<%= ddlAcadYear.ClientID %>" class="col-sm-2 control-label">Academic Year:</label>
                        <div class="col-sm-3">
                            <asp:DropDownList ID="ddlAcadYear" runat="server" CssClass="form-control" OnSelectedIndexChanged="ddlAcadYear_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-offset-2 col-sm-2 control-label">Begin Date</label>
                        <label class="col-sm-offset-1 col-sm-2 control-label">End Date</label>
                    </div>
                    <div class="form-group">
                        <label for="<%= tbxFABegDate.ClientID %>" class="col-sm-2 control-label">Fall Term:</label>
                        <div class="col-sm-3">
                            <asp:TextBox ID="tbxFABegDate" runat="server" CssClass="form-control" />
                        </div>
                        <div class="col-sm-3">
                            <asp:TextBox ID="tbxFAEndDate" runat="server" CssClass="form-control" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="<%= tbxSPBegDate.ClientID %>" class="col-sm-2 control-label">Spring Term:</label>
                        <div class="col-sm-3">
                            <asp:TextBox ID="tbxSPBegDate" runat="server" CssClass="form-control" />
                        </div>
                        <div class="col-sm-3">
                            <asp:TextBox ID="tbxSPEndDate" runat="server" CssClass="form-control" />
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-sm-offset-2 col-sm-4">
                            <asp:Button id="btnSaveEditPeriods" runat="server" CssClass="btn btn-primary active" Text="Save Edit Period" OnClick="btnSaveEditPeriods_Click"/>
                        </div>
                    </div>
                </div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading">Edit Meal Plans</div>
                <div class="panel-body form-horizontal">
                    <asp:Literal ID="ltrlEditMealPlanMsg" runat="server" />
                    <p class="help-block">Edit the student meal plans in the database.</p>
                    <div class="form-group">
                        <div class="col-sm-offset-2 col-sm-5">
                            <asp:Button id="btnEditStudentMealPlans" runat="server" CssClass="btn btn-success" Text="Edit Student Meal Plans" OnClick="btnEditStudentMealPlans_Click"/>
                        </div>
                    </div>
                    <p class="help-block">Edit the settings for meal plans.</p>
                    <div class="form-group">
                        <label for="<%= ddlMealPlan.ClientID %>" class="col-sm-2 control-label">Meal Plan:</label>
                        <div class="col-sm-3">
                            <asp:DropDownList ID="ddlMealPlan" runat="server" CssClass="form-control" OnSelectedIndexChanged="ddlMealPlan_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="<%= tbxPlanName.ClientID %>" class="col-sm-2 control-label">Name:</label>
                        <div class="col-sm-3">
                            <asp:TextBox ID="tbxPlanName" runat="server" CssClass="form-control" MaxLength="24"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="<%= tbxPlanDescr.ClientID %>" class="col-sm-2 control-label">Description:</label>
                        <div class="col-sm-6">
                            <asp:TextBox ID="tbxPlanDescr" runat="server" CssClass="form-control" MaxLength="100"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-sm-offset-2 col-sm-6">
                            <asp:CheckBox ID="cbxChange" runat="server" /> Can be changed by students?
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-sm-offset-2 col-sm-6">
                            <asp:Button id="btnSaveMealPlan" runat="server" CssClass="btn btn-primary" Text="Save Meal Plan" OnClick="btnSaveMealPlan_Click"/>
                            &nbsp;
                            <asp:Button id="btnRemoveMealPlan" runat="server" CssClass="btn btn-default" Text="Remove Meal Plan" OnClick="btnRemoveMealPlan_Click"/>
                        </div>
                    </div>
                </div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading">Email Settings</div>
                <div class="panel-body form-horizontal">
                    <asp:Literal ID="ltrlEmailSettingsMsg" runat="server" />
                    <p class="help-block">The message below will be sent on the begin date of each period that students are allowed to update their meal plan.</p>
                    <div class="form-group">
                        <label for="<%= tbxToAddress.ClientID %>" class="col-sm-2 control-label">To:</label>
                        <div class="col-sm-6">
                            <asp:TextBox ID="tbxToAddress" runat="server" CssClass="form-control" MaxLength="64"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="<%= tbxFromAddress.ClientID %>" class="col-sm-2 control-label">From:</label>
                        <div class="col-sm-6">
                            <asp:TextBox ID="tbxFromAddress" runat="server" CssClass="form-control" MaxLength="64"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="<%= tbxSubject.ClientID %>" class="col-sm-2 control-label">Subject:</label>
                        <div class="col-sm-6">
                            <asp:TextBox ID="tbxSubject" runat="server" CssClass="form-control" MaxLength="100"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="<%= tbxMessage.ClientID %>" class="col-sm-2 control-label">Message:</label>
                        <div class="col-sm-6">
                            <asp:TextBox ID="tbxMessage" runat="server" CssClass="form-control" MaxLength="500" TextMode="MultiLine" Rows="6"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-sm-offset-2 col-sm-6">
                            <asp:Button id="btnSaveEmail" runat="server" CssClass="btn btn-primary btn-block" Text="Save Email Settings" OnClick="btnSaveEmail_Click"/>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="ddlAcadYear" EventName="SelectedIndexChanged" />
            <asp:AsyncPostBackTrigger ControlID="ddlMealPlan" EventName="SelectedIndexChanged" />
            <asp:AsyncPostBackTrigger ControlID="btnSaveMealPlan" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="btnRemoveMealPlan" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="btnEditStudentMealPlans" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="btnSaveEmail" EventName="Click" />
        </Triggers>
    </asp:UpdatePanel>
</div>