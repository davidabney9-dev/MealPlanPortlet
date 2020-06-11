<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Student_View.ascx.cs" Inherits="CNTRMealPlan.Student_View" %>

<div class="pSection container-fluid">
    <div class="row">
        <div class="well well-sm">
            <strong>How to change a meal plan?</strong><br />
            Select a new meal plan from the option list below for fall or spring and then click the save button.<br /><br />

            <strong>One change per term?</strong><br />
            You can only change your meal plan through Centrenet <strong>once</strong> during the edit period. 
            If you need to change the meal plan more than once, contact the Student Life Office by visiting the
             2nd floor of the Campus Center or call 859-238-5471.<br /><br />

            <strong>The meal plan options are grayed out?</strong><br />
            You cannot change your meal plan for that term if the edit period is closed or you are in a special
             category, such as on a study abroad trip.<br /><br />

            For more information, please visit the <asp:HyperLink ID="lnkDiningPage" Text="Dining Services Web Page" runat="server" Target="_blank"/>
        </div>
    </div>
    <div class="row">
        <div class="col-sm-6">
            <div class="row">
                <table class="table table-striped table-bordered">
                    <thead>
                        <tr>
                            <th>Term</th>
                            <th>Edit Period</th>
                            <th>Selected Meal Plan</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Fall</td>
                            <td><asp:Label ID="lblFAEditPeriod" runat="server"></asp:Label></td>
                            <td><asp:DropDownList ID="ddlFAMealPlan" runat="server" CssClass="form-control" Enabled="false"></asp:DropDownList></td>
                        </tr>
                        <tr>
                            <td>Spring</td>
                            <td><asp:Label ID="lblSPEditPeriod" runat="server"></asp:Label></td>
                            <td><asp:DropDownList ID="ddlSPMealPlan" runat="server" CssClass="form-control" Enabled="false"></asp:DropDownList></td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="row">
                <div class="col-sm-12">
                    <asp:Button id="btnSave" runat="server" CssClass="btn btn-primary btn-block" Text="Save Meal Plan" OnClick="btnSave_Click"/>
                </div>
            </div>
        </div>
        <div class="col-sm-6">
            <asp:GridView ID="gvMealPlanOptions" runat="server" 
                AutoGenerateColumns="false"
                GridLines="none" 
                CssClass="table table-bordered">
                <Columns>
                    <asp:BoundField DataField="name" HeaderText="Plan Name"/>
                    <asp:BoundField DataField="descr" HeaderText="Description" />
                </Columns>
            </asp:GridView>
        </div>
    </div>
</div>