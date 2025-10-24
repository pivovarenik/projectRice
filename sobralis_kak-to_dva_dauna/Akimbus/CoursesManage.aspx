<%@ Page Title="Управление курсами" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CoursesManage.aspx.cs" Inherits="Akimbus.CoursesManage" ResponseEncoding="utf-8" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2>📚 Управление курсами</h2>
    
    <div style="margin-bottom: 1.5rem;">
        <a href="CoursesAdd.aspx" class="btn btn-success" style="text-decoration: none;">➕ Добавить новый курс</a>
    </div>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
    <asp:GridView ID="CoursesGrid" runat="server" AllowPaging="True" AllowSorting="True" 
        AutoGenerateColumns="False" DataKeyNames="CourseID" PageSize="15"
        OnRowEditing="CoursesGrid_RowEditing" OnRowUpdating="CoursesGrid_RowUpdating"
        OnRowCancelingEdit="CoursesGrid_RowCancelingEdit" OnRowDeleting="CoursesGrid_RowDeleting"
        OnPageIndexChanging="CoursesGrid_PageIndexChanging" OnSorting="CoursesGrid_Sorting">
        <Columns>
            <asp:CommandField ShowDeleteButton="True" DeleteText="Удалить" />
            <asp:TemplateField HeaderText="Название курса" SortExpression="Title">
                <EditItemTemplate>
                    <asp:TextBox ID="txtTitle" runat="server" Text='<%# Bind("Title") %>' MaxLength="100"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="valTitle" runat="server" ControlToValidate="txtTitle" 
                        ErrorMessage="Название обязательно" Display="Dynamic" ForeColor="Red">*</asp:RequiredFieldValidator>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblTitle" runat="server" Text='<%# Bind("Title") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="Credits" HeaderText="Количество мест" SortExpression="Credits" />
            <asp:TemplateField HeaderText="Кафедра" SortExpression="DepartmentID">
                <EditItemTemplate>
                    <asp:DropDownList ID="ddlDepartment" runat="server" 
                        SelectedValue='<%# Bind("DepartmentID") %>'
                        DataTextField="Name" DataValueField="DepartmentID">
                    </asp:DropDownList>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblDepartment" runat="server" Text='<%# Eval("Department.Name") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <PagerSettings Mode="NumericFirstLast" PageButtonCount="5" FirstPageText="« Первая" LastPageText="Последняя »" />
    </asp:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ForeColor="Red" CssClass="validation-summary-errors" HeaderText="Пожалуйста, исправьте ошибки:" />
</asp:Content>
