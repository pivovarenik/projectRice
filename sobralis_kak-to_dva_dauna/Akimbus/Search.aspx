<%@ Page Title="Поиск" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Search.aspx.cs" Inherits="Akimbus.Search" ResponseEncoding="utf-8" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="page-header">
        <h1>🔍 Поиск студентов</h1>
        <p>Найдите студента по имени, фамилии или дате зачисления</p>
    </div>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="search-container">
            
                <div class="search-card">
                    <h2>Параметры поиска</h2>
                    
                    <div class="search-form">
                        <div class="form-row">
                            <div class="form-group">
                                <label>Фамилия:</label>
                                <asp:TextBox ID="txtLastName" runat="server" 
                                    CssClass="form-control" 
                                    placeholder="Введите фамилию..."></asp:TextBox>
                            </div>

                            <div class="form-group">
                                <label>Имя:</label>
                                <asp:TextBox ID="txtFirstName" runat="server" 
                                    CssClass="form-control" 
                                    placeholder="Введите имя..."></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Дата зачисления (от):</label>
                                <asp:TextBox ID="txtDateFrom" runat="server" 
                                    CssClass="form-control" 
                                    TextMode="Date"></asp:TextBox>
                            </div>

                            <div class="form-group">
                                <label>Дата зачисления (до):</label>
                                <asp:TextBox ID="txtDateTo" runat="server" 
                                    CssClass="form-control" 
                                    TextMode="Date"></asp:TextBox>
                            </div>
                        </div>

                        <div class="button-group">
                            <asp:Button ID="btnSearch" runat="server" 
                                Text="🔍 Найти" 
                                CssClass="btn btn-primary"
                                OnClick="btnSearch_Click" />
                            
                            <asp:Button ID="btnClear" runat="server" 
                                Text="🔄 Сбросить" 
                                CssClass="btn btn-secondary"
                                OnClick="btnClear_Click" />
                        </div>
                    </div>
                </div>

                <div class="results-card">
                    <h2>
                        Результаты поиска
                        <span class="result-count">
                            (<asp:Label ID="lblResultCount" runat="server" Text="0"></asp:Label>)
                        </span>
                    </h2>

                    <asp:GridView ID="gvResults" runat="server" 
                        CssClass="table table-striped" 
                        AutoGenerateColumns="False"
                        AllowSorting="True"
                        AllowPaging="True"
                        PageSize="10"
                        OnSorting="gvResults_Sorting"
                        OnPageIndexChanging="gvResults_PageIndexChanging"
                        EmptyDataText="Студенты не найдены. Попробуйте изменить критерии поиска.">
                        <Columns>
                            <asp:BoundField DataField="StudentID" HeaderText="ID" SortExpression="StudentID" />
                            <asp:BoundField DataField="LastName" HeaderText="Фамилия" SortExpression="LastName" />
                            <asp:BoundField DataField="FirstMidName" HeaderText="Имя" SortExpression="FirstMidName" />
                            <asp:BoundField DataField="EnrollmentDate" HeaderText="Дата зачисления" 
                                SortExpression="EnrollmentDate" DataFormatString="{0:dd.MM.yyyy}" />
                            <asp:BoundField DataField="CourseCount" HeaderText="Курсов" SortExpression="CourseCount" />
                            <asp:TemplateField HeaderText="Действия">
                                <ItemTemplate>
                                    <a href='<%# "Students.aspx?id=" + Eval("StudentID") %>' class="btn-link">Подробнее</a>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>

    <style>
        .search-container {
            animation: fadeInUp 0.5s ease both;
        }

        .search-card, .results-card {
            background: white;
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .search-card h2, .results-card h2 {
            margin-top: 0;
            margin-bottom: 25px;
            color: #2c3e50;
            font-size: 1.5em;
        }

        .result-count {
            color: #667eea;
            font-size: 0.9em;
        }

        .search-form {
            max-width: 800px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group label {
            margin-bottom: 8px;
            font-weight: 600;
            color: #555;
        }

        .form-control {
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1em;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }

        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            outline: none;
        }

        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 25px;
        }

        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            font-size: 1em;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .btn-secondary {
            background: #95a5a6;
            color: white;
        }

        .btn-secondary:hover {
            background: #7f8c8d;
            transform: translateY(-2px);
        }

        .btn-link {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
            padding: 5px 15px;
            border-radius: 5px;
            transition: background-color 0.2s ease;
        }

        .btn-link:hover {
            background-color: #f0f0ff;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }

            .button-group {
                flex-direction: column;
            }

            .btn {
                width: 100%;
            }
        }
    </style>
</asp:Content>
