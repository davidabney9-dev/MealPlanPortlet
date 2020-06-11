<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Edit_Student_View.ascx.cs" Inherits="CNTRMealPlan.Edit_Student_View" %>
<%@ Import namespace="Jenzabar.Portal.Framework" %>
<%@ Import namespace="GCUserLookupService.Security" %>

<script type="text/javascript">
    $(document).ready(function ($) {
        enableLookups();
    });

    function enableLookups() {
        //Uses the GC User Look Up Service
        myCustomUserLookup($('#<%= tbxStuSearch.ClientID %>'),
                            $('#<%= hdnStuId.ClientID %>'),
                            'QueryStudentsByIDName',
                            '<%= ClientEncryption.Encrypt(ParentPortlet.Portlet.PortletTemplate.Guid.ToString()) %>',
                            'FL,ID');
    }

    function myCustomUserLookup(objName, objId, lookupReference, encPortletGuid, displayConfig) {
        try {
            $(objName).autocomplete({
                minLength: 2,
                delay: 100,
                source: function (request, response) {
                    $.ajax({
                        url: '/ICS/Portlets/CUS/ICS/GCUserLookupService/GCUserLookupWebService.asmx/FindUserConfig',
                        success: function (data) {
                            response(data.d);
                        },
                        dataType: "json",
                        contentType: "application/json; charset=utf-8",
                        type: "POST",
                        data: Sys.Serialization.JavaScriptSerializer.serialize({ term: request.term, lookupRef: lookupReference, pgref: encPortletGuid, format: displayConfig })
                    });
                },
                focus: function (event, ui) {
                    //$(objName).val(ui.item.FullName);
                    return false;
                },
                select: function (event, ui) {
                    $(objName).val(ui.item.FullName);
                    $(objId).val(ui.item.HostId);
                    $(objName).trigger('change');
                    return false;
                }
            })
                        .data("ui-autocomplete")._renderItem = function (ul, item) {
                            $(ul).css('position', 'relative');
                            $(ul).css('cssText', 'z-index: 9000 !important;');
                            return $("<li></li>")
                                .data("item.autocomplete", item)
                                .append("<a>" + item.Text + "</a>")
                                .appendTo(ul);
                        };
        }
        catch (err) {
            console.log(err);
        }
    }
</script>

<div class="pSection form-horizontal">
    <div class="form-group">
        <label for="<%= tbxStuSearch.ClientID %>" class="col-sm-2">Search by Student</label>
        <div class="col-sm-4">
            <asp:TextBox ID="tbxStuSearch" type="text" runat="server" placeholder="Name or ID Number" CssClass="form-control"></asp:TextBox>
        </div>
        <div class="col-sm-2">
            <asp:Button type="button" ID="btnSearchStudent" Text="Search" runat="server" AutoPostBack="true" OnClick="btnSearchStudent_Click" CssClass="btn btn-default"/>
        </div>
        <asp:HiddenField id="hdnStuId" runat="server" />
    </div>
    <div class="form-group">
        <label for="tbxStuID" class="col-sm-2">Student ID:</label>
        <div class="col-sm-3">
            <asp:TextBox ID="tbxStuID" type="text" runat="server" Enabled="false" ReadOnly="true" CssClass="form-control"></asp:TextBox>
        </div>
    </div>
    <div class="form-group">
        <label for="tbxStuName" class="col-sm-2">Student Name:</label>
        <div class="col-sm-3">
            <asp:TextBox ID="tbxStuName" type="text" runat="server" Enabled="false" ReadOnly="true" CssClass="form-control"></asp:TextBox>
        </div>
    </div>
    <div class="form-group">
        <div class="col-sm-12" style="margin-bottom: -10px;">
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
            <div class="col-sm-offset-4 col-sm-4">
                <asp:Button id="btnSave" runat="server" CssClass="btn btn-primary btn-block" Text="Save Meal Plan" OnClick="btnSave_Click"/>
            </div>
        </div>
    </div>
</div>