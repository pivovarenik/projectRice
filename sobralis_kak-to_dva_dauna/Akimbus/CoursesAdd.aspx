<%@ Page Title="Добавить курс" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CoursesAdd.aspx.cs" Inherits="Akimbus.CoursesAdd" ResponseEncoding="utf-8" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2>➕ Добавить новый курс</h2>
    
    <div class="form-container">
        <div class="form-group">
            <label for="txtTitle">Название курса:</label>
            <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" MaxLength="100"></asp:TextBox>
            <asp:RequiredFieldValidator ID="valTitle" runat="server" ControlToValidate="txtTitle" 
                ErrorMessage="Название обязательно" Display="Dynamic" ForeColor="Red">*</asp:RequiredFieldValidator>
        </div>

        <div class="form-group">
            <label for="txtCredits">Количество мест на курсе:</label>
            <asp:TextBox ID="txtCredits" runat="server" CssClass="form-control" TextMode="Number"></asp:TextBox>
            <asp:RequiredFieldValidator ID="valCredits" runat="server" ControlToValidate="txtCredits" 
                ErrorMessage="Количество мест обязательно" Display="Dynamic" ForeColor="Red">*</asp:RequiredFieldValidator>
            <asp:RangeValidator ID="rangeCredits" runat="server" ControlToValidate="txtCredits" 
                MinimumValue="1" MaximumValue="100" Type="Integer" 
                ErrorMessage="Количество мест: от 1 до 100" Display="Dynamic" ForeColor="Red">*</asp:RangeValidator>
        </div>

        <div class="form-group">
            <label for="ddlDepartment">Кафедра:</label>
            <asp:DropDownList ID="ddlDepartment" runat="server" CssClass="form-control">
            </asp:DropDownList>
            <asp:RequiredFieldValidator ID="valDepartment" runat="server" ControlToValidate="ddlDepartment" 
                InitialValue="" ErrorMessage="Выберите кафедру" Display="Dynamic" ForeColor="Red">*</asp:RequiredFieldValidator>
        </div>

        <div class="button-group">
            <asp:Button ID="btnSubmit" runat="server" Text="✔ Сохранить" CssClass="btn btn-primary" OnClick="btnSubmit_Click" />
            <asp:Button ID="btnCancel" runat="server" Text="✖ Отмена" CssClass="btn btn-secondary" OnClick="btnCancel_Click" CausesValidation="false" />
        </div>

        <asp:ValidationSummary ID="ValidationSummary1" runat="server" ForeColor="Red" CssClass="validation-summary-errors" HeaderText="Пожалуйста, исправьте ошибки:" />
        
        <asp:Label ID="lblMessage" runat="server" CssClass="message" Visible="false" EnableViewState="false"></asp:Label>
    </div>

    <style>
        .form-container {
            max-width: 600px;
            background: white;
            padding: 2rem;
            border-radius: 4px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            border: 1px solid #cccccc;
            margin-top: 1rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: #333333;
        }

        .form-control {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1px solid #cccccc;
            border-radius: 4px;
            font-size: 0.9rem;
        }

        .form-control:focus {
            border-color: #000000;
            outline: none;
        }

        .button-group {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }

        .message {
            display: block;
            margin-top: 1rem;
            padding: 1rem;
            border-radius: 4px;
            background: #e8f5e9;
            color: #2e7d32;
            border: 1px solid #66bb6a;
        }
        
        .error-message {
            background: #ffebee;
            color: #c62828;
            border: 1px solid #ef5350;
        }
    </style>
</asp:Content>
