<%@ Page Title="Статистика" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Statistics.aspx.cs" Inherits="Akimbus.Statistics" ResponseEncoding="utf-8" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2>📊 Курсы и зачисленные студенты</h2>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="stats-container">
                <!-- Общая статистика -->
                <div class="stats-grid">
                    <div class="stat-card stat-primary">
                        <div class="stat-icon">👨‍🎓</div>
                        <div class="stat-content">
                            <h3>Всего студентов</h3>
                            <div class="stat-number">
                                <asp:Label ID="lblTotalStudents" runat="server" Text="0"></asp:Label>
                            </div>
                        </div>
                    </div>

                    <div class="stat-card stat-success">
                        <div class="stat-icon">📚</div>
                        <div class="stat-content">
                            <h3>Всего курсов</h3>
                            <div class="stat-number">
                                <asp:Label ID="lblTotalCourses" runat="server" Text="0"></asp:Label>
                            </div>
                        </div>
                    </div>

                    <div class="stat-card stat-info">
                        <div class="stat-icon">🏛️</div>
                        <div class="stat-content">
                            <h3>Кафедр</h3>
                            <div class="stat-number">
                                <asp:Label ID="lblTotalDepartments" runat="server" Text="0"></asp:Label>
                            </div>
                        </div>
                    </div>

                    <div class="stat-card stat-warning">
                        <div class="stat-icon">📝</div>
                        <div class="stat-content">
                            <h3>Всего записей</h3>
                            <div class="stat-number">
                                <asp:Label ID="lblTotalEnrollments" runat="server" Text="0"></asp:Label>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Статистика по кафедрам -->
                <div class="section-card">
                    <h2>📊 Курсы по кафедрам</h2>
                    <asp:GridView ID="gvDepartmentStats" runat="server" 
                        CssClass="table table-striped" 
                        AutoGenerateColumns="False"
                        EmptyDataText="Нет данных">
                        <Columns>
                            <asp:BoundField DataField="DepartmentName" HeaderText="Кафедра" />
                            <asp:BoundField DataField="CourseCount" HeaderText="Количество курсов" />
                            <asp:BoundField DataField="TotalCredits" HeaderText="Всего кредитов" />
                        </Columns>
                    </asp:GridView>
                </div>

                <!-- Статистика по оценкам -->
                <div class="section-card">
                    <h2>🎯 Распределение оценок</h2>
                    <asp:GridView ID="gvGradeStats" runat="server" 
                        CssClass="table table-striped" 
                        AutoGenerateColumns="False"
                        EmptyDataText="Нет данных">
                        <Columns>
                            <asp:BoundField DataField="Grade" HeaderText="Оценка" />
                            <asp:BoundField DataField="Count" HeaderText="Количество" />
                            <asp:BoundField DataField="Percentage" HeaderText="Процент" DataFormatString="{0:F1}%" />
                        </Columns>
                    </asp:GridView>
                </div>

                <!-- Топ курсов -->
                <div class="section-card">
                    <h2>🌟 Топ-5 популярных курсов</h2>
                    <asp:GridView ID="gvTopCourses" runat="server" 
                        CssClass="table table-striped" 
                        AutoGenerateColumns="False"
                        EmptyDataText="Нет данных">
                        <Columns>
                            <asp:BoundField DataField="CourseTitle" HeaderText="Название курса" />
                            <asp:BoundField DataField="DepartmentName" HeaderText="Кафедра" />
                            <asp:BoundField DataField="EnrollmentCount" HeaderText="Студентов записано" />
                        </Columns>
                    </asp:GridView>
                </div>

                <!-- Активность студентов -->
                <div class="section-card">
                    <h2>📈 Студенты по количеству курсов</h2>
                    <asp:GridView ID="gvStudentActivity" runat="server" 
                        CssClass="table table-striped" 
                        AutoGenerateColumns="False"
                        AllowPaging="True"
                        PageSize="10"
                        OnPageIndexChanging="gvStudentActivity_PageIndexChanging"
                        EmptyDataText="Нет данных">
                        <Columns>
                            <asp:BoundField DataField="StudentName" HeaderText="Студент" />
                            <asp:BoundField DataField="EnrollmentDate" HeaderText="Дата зачисления" DataFormatString="{0:dd.MM.yyyy}" />
                            <asp:BoundField DataField="CourseCount" HeaderText="Количество курсов" />
                        </Columns>
                    </asp:GridView>
                </div>

                <div style="margin-top: 20px;">
                    <asp:Button ID="btnRefresh" runat="server" 
                        Text="🔄 Обновить статистику" 
                        CssClass="btn btn-primary"
                        OnClick="btnRefresh_Click" />
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>

    <style>
        .stats-container {
            animation: fadeInUp 0.5s ease both;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            display: flex;
            align-items: center;
            gap: 20px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        .stat-icon {
            font-size: 3em;
            flex-shrink: 0;
        }

        .stat-content {
            flex: 1;
        }

        .stat-content h3 {
            margin: 0 0 10px 0;
            font-size: 0.9em;
            color: #666;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .stat-number {
            font-size: 2.5em;
            font-weight: bold;
            margin: 0;
        }

        .stat-primary .stat-number { color: #667eea; }
        .stat-success .stat-number { color: #27ae60; }
        .stat-info .stat-number { color: #3498db; }
        .stat-warning .stat-number { color: #f39c12; }

        .section-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            animation: slideInFromLeft 0.6s ease both;
        }

        .section-card h2 {
            margin-top: 0;
            margin-bottom: 20px;
            color: #2c3e50;
            font-size: 1.5em;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 8px;
            font-size: 1em;
            cursor: pointer;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
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

        @keyframes slideInFromLeft {
            from {
                opacity: 0;
                transform: translateX(-50px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
    </style>
</asp:Content>
