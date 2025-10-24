<%@ Page Title="Courses" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Courses.aspx.cs" Inherits="Akimbus.Courses" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2>📖 Курсы по кафедрам</h2>
    <div style="background: white; padding: 2rem; border-radius: 16px; box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1); margin-bottom: 2rem;">
        <div style="margin-bottom: 1.5rem;">
            <label style="font-weight: 600; color: #4a5568; margin-bottom: 0.5rem; display: block; font-size: 1.1rem;">
                🏫 Выберите кафедру:
            </label>
            <asp:DropDownList ID="ddlDepartments" runat="server" AutoPostBack="True" 
                DataTextField="Name" DataValueField="DepartmentID" 
                OnSelectedIndexChanged="ddlDepartments_SelectedIndexChanged"
                style="width: 100%; max-width: 400px; padding: 0.8rem 1rem; border: 2px solid #e2e8f0; border-radius: 10px; font-size: 1rem; background: white;">
            </asp:DropDownList>
        </div>
    <asp:GridView ID="CoursesGrid" runat="server" AutoGenerateColumns="False" 
        DataKeyNames="CourseID" EmptyDataText="Выберите кафедру для просмотра курсов">
        <Columns>
            <asp:BoundField DataField="Title" HeaderText="Название" />
            <asp:BoundField DataField="Credits" HeaderText="Количество мест" />
            <asp:BoundField DataField="DepartmentName" HeaderText="Кафедра" />
        </Columns>
    </asp:GridView>
    </div>
</asp:Content>
