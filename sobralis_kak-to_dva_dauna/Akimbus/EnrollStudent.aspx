<%@ Page Title="Записать на курс" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EnrollStudent.aspx.cs" Inherits="Akimbus.EnrollStudent" ResponseEncoding="utf-8" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2>📝 Записать студента на курс</h2>
    
    <div class="form-container">
        <div class="form-group">
            <label for="ddlStudent">Студент:</label>
            <asp:DropDownList ID="ddlStudent" runat="server" CssClass="form-control">
            </asp:DropDownList>
            <asp:RequiredFieldValidator ID="valStudent" runat="server" ControlToValidate="ddlStudent" 
                InitialValue="" ErrorMessage="Выберите студента" Display="Dynamic" ForeColor="Red">*</asp:RequiredFieldValidator>
        </div>

        <div class="form-group">
            <label for="ddlCourse">Курс:</label>
            <asp:DropDownList ID="ddlCourse" runat="server" CssClass="form-control">
            </asp:DropDownList>
            <asp:RequiredFieldValidator ID="valCourse" runat="server" ControlToValidate="ddlCourse" 
                InitialValue="" ErrorMessage="Выберите курс" Display="Dynamic" ForeColor="Red">*</asp:RequiredFieldValidator>
        </div>

        <div class="form-group">
            <label for="ddlGrade">Оценка (необязательно):</label>
            <asp:DropDownList ID="ddlGrade" runat="server" CssClass="form-control">
                <asp:ListItem Text="-- Не выбрано --" Value=""></asp:ListItem>
                <asp:ListItem Text="1" Value="1"></asp:ListItem>
                <asp:ListItem Text="2" Value="2"></asp:ListItem>
                <asp:ListItem Text="3" Value="3"></asp:ListItem>
                <asp:ListItem Text="4" Value="4"></asp:ListItem>
                <asp:ListItem Text="5" Value="5"></asp:ListItem>
                <asp:ListItem Text="6" Value="6"></asp:ListItem>
                <asp:ListItem Text="7" Value="7"></asp:ListItem>
                <asp:ListItem Text="8" Value="8"></asp:ListItem>
                <asp:ListItem Text="9" Value="9"></asp:ListItem>
                <asp:ListItem Text="10" Value="10"></asp:ListItem>
            </asp:DropDownList>
        </div>

        <div class="button-group">
            <asp:Button ID="btnSubmit" runat="server" Text="✔ Записать" CssClass="btn btn-primary" OnClick="btnSubmit_Click" />
            <asp:Button ID="btnCancel" runat="server" Text="✖ Отмена" CssClass="btn btn-secondary" OnClick="btnCancel_Click" CausesValidation="false" />
        </div>

        <asp:ValidationSummary ID="ValidationSummary1" runat="server" ForeColor="Red" CssClass="validation-summary-errors" HeaderText="Пожалуйста, исправьте ошибки:" />
        
        <asp:Label ID="lblMessage" runat="server" CssClass="message" Visible="false"></asp:Label>
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
        }
        
        .message.success {
            background: #e8f5e9;
            color: #2e7d32;
            border: 1px solid #66bb6a;
        }
        
        .message.error {
            background: #ffebee;
            color: #c62828;
            border: 1px solid #ef5350;
        }
    </style>
</asp:Content>
