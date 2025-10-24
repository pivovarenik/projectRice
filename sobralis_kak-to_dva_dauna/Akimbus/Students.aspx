<%@ Page Title="Students" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Students.aspx.cs" Inherits="Akimbus.Students" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2>👨‍🎓 Список студентов</h2>
    
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
         
            <div class="search-panel">
                <div class="search-row">
                    <asp:TextBox ID="txtSearchLastName" runat="server" placeholder="Фамилия..." CssClass="search-input"></asp:TextBox>
                    <asp:TextBox ID="txtSearchFirstName" runat="server" placeholder="Имя..." CssClass="search-input"></asp:TextBox>
                    <asp:TextBox ID="txtSearchDateFrom" runat="server" TextMode="Date" CssClass="search-input" placeholder="Дата от"></asp:TextBox>
                    <asp:TextBox ID="txtSearchDateTo" runat="server" TextMode="Date" CssClass="search-input" placeholder="Дата до"></asp:TextBox>
                    <asp:Button ID="btnSearch" runat="server" Text="🔍 Найти" CssClass="btn btn-primary" OnClick="btnSearch_Click" />
                    <asp:Button ID="btnClearSearch" runat="server" Text="✖ Сбросить" CssClass="btn btn-secondary" OnClick="btnClearSearch_Click" />
                </div>
            </div>
            
    <asp:GridView ID="StudentsGrid" runat="server" AllowPaging="True" AllowSorting="True"
        AutoGenerateColumns="False" DataKeyNames="PersonID" PageSize="10"
        OnRowEditing="StudentsGrid_RowEditing" OnRowUpdating="StudentsGrid_RowUpdating"
        OnRowCancelingEdit="StudentsGrid_RowCancelingEdit" OnRowDeleting="StudentsGrid_RowDeleting"
        OnPageIndexChanging="StudentsGrid_PageIndexChanging" OnSorting="StudentsGrid_Sorting">
        <Columns>
            <asp:CommandField ShowEditButton="True" ShowDeleteButton="True" EditText="Редакт." DeleteText="Удалить" UpdateText="Сохранить" CancelText="Отмена" />
            <asp:TemplateField HeaderText="Фамилия" SortExpression="LastName">
                <EditItemTemplate>
                    <asp:TextBox ID="txtLastName" runat="server" Text='<%# Bind("LastName") %>'></asp:TextBox>
                    <asp:RequiredFieldValidator ID="valLastName" runat="server" ControlToValidate="txtLastName" 
                        ErrorMessage="Фамилия обязательна" Display="Dynamic" ForeColor="Red">*</asp:RequiredFieldValidator>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblLastName" runat="server" Text='<%# Bind("LastName") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Имя" SortExpression="FirstMidName">
                <EditItemTemplate>
                    <asp:TextBox ID="txtFirstName" runat="server" Text='<%# Bind("FirstMidName") %>'></asp:TextBox>
                    <asp:RequiredFieldValidator ID="valFirstName" runat="server" ControlToValidate="txtFirstName" 
                        ErrorMessage="Имя обязательно" Display="Dynamic" ForeColor="Red">*</asp:RequiredFieldValidator>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblFirstName" runat="server" Text='<%# Bind("FirstMidName") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Дата зачисления" SortExpression="EnrollmentDate">
                <EditItemTemplate>
                    <asp:TextBox ID="txtDate" runat="server" Text='<%# Bind("EnrollmentDate", "{0:yyyy-MM-dd}") %>' placeholder="гггг-мм-дд"></asp:TextBox>
                    <asp:CompareValidator ID="valDate" runat="server" ControlToValidate="txtDate" Type="Date" 
                        Operator="DataTypeCheck" ErrorMessage="Неверный формат даты" Display="Dynamic" ForeColor="Red">*</asp:CompareValidator>
                    <asp:RequiredFieldValidator ID="valDateReq" runat="server" ControlToValidate="txtDate" 
                        ErrorMessage="Дата обязательна" Display="Dynamic" ForeColor="Red">*</asp:RequiredFieldValidator>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblDate" runat="server" Text='<%# Bind("EnrollmentDate", "{0:d}") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <PagerSettings Mode="NumericFirstLast" PageButtonCount="5" FirstPageText="« Первая" LastPageText="Последняя »" />
    </asp:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ForeColor="Red" CssClass="validation-summary-errors" HeaderText="Пожалуйста, исправьте ошибки:" />
    
    <style>
        .search-panel {
            background: white;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            border-radius: 4px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            border: 1px solid #cccccc;
        }
        
        .search-row {
            display: flex;
            gap: 0.75rem;
            flex-wrap: wrap;
            align-items: center;
        }
        
        .search-input {
            flex: 1;
            min-width: 150px;
            padding: 0.75rem 1rem;
            border: 1px solid #cccccc;
            border-radius: 4px;
            font-size: 0.9rem;
        }
        
        .search-input:focus {
            border-color: #000000;
            outline: none;
        }
        
        .btn-secondary {
            background: #666666;
            color: white;
            border: 1px solid #666666;
        }
        
        .btn-secondary:hover {
            background: #333333;
        }
    </style>
</asp:Content>
