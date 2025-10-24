<%@ Page Title="Add Student" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="StudentsAdd.aspx.cs" Inherits="Akimbus.StudentsAdd" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2>➕ Добавить студента</h2>
    <div class="details-view">
    <asp:DetailsView ID="StudentsDetails" runat="server" AutoGenerateRows="False" 
        DefaultMode="Insert" OnItemInserting="StudentsDetails_ItemInserting" CssClass="details-view">
        <Fields>
            <asp:TemplateField HeaderText="Фамилия">
                <InsertItemTemplate>
                    <asp:TextBox ID="txtLastName" runat="server" Text='<%# Bind("LastName") %>' placeholder="Введите фамилию"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="valLastName" runat="server" ControlToValidate="txtLastName" 
                        ErrorMessage="Фамилия обязательна" Display="Dynamic" ForeColor="Red">*</asp:RequiredFieldValidator>
                </InsertItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Имя">
                <InsertItemTemplate>
                    <asp:TextBox ID="txtFirstName" runat="server" Text='<%# Bind("FirstMidName") %>' placeholder="Введите имя"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="valFirstName" runat="server" ControlToValidate="txtFirstName" 
                        ErrorMessage="Имя обязательно" Display="Dynamic" ForeColor="Red">*</asp:RequiredFieldValidator>
                </InsertItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Дата зачисления">
                <InsertItemTemplate>
                    <asp:TextBox ID="txtDate" runat="server" Text='<%# Bind("EnrollmentDate", "{0:yyyy-MM-dd}") %>' TextMode="Date"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="valDateReq" runat="server" ControlToValidate="txtDate" 
                        ErrorMessage="Дата обязательна" Display="Dynamic" ForeColor="Red">*</asp:RequiredFieldValidator>
                </InsertItemTemplate>
            </asp:TemplateField>
            <asp:CommandField ShowInsertButton="True" InsertText="Добавить" />
        </Fields>
    </asp:DetailsView>
    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ForeColor="Red" CssClass="validation-summary-errors" HeaderText="Пожалуйста, исправьте ошибки:" />
    </div>
</asp:Content>
