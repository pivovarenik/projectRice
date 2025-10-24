<%@ Page Title="Курсы и студенты" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Statistics.aspx.cs" Inherits="Akimbus.Statistics" ResponseEncoding="utf-8" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2>📊 Курсы и зачисленные студенты</h2>
    
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:Repeater ID="rptCourses" runat="server" OnItemDataBound="rptCourses_ItemDataBound">
                <ItemTemplate>
                    <div class="course-card">
                        <div class="course-header">
                            <h3>📚 <%# Eval("Title") %></h3>
                            <div class="course-meta">
                               
                                <span class="badge">Кафедра: <%# Eval("DepartmentName") %></span>
                                <span class="badge">Мест: <%# Eval("Credits") %></span>
                                <span class="badge badge-primary">Студентов: <%# Eval("StudentCount") %></span>
                            </div>
                        </div>
                        
                        <asp:GridView ID="gvStudents" runat="server" 
                            AutoGenerateColumns="False"
                            CssClass="students-table"
                            EmptyDataText="На этот курс пока никто не записан">
                            <Columns>
                                <asp:BoundField DataField="StudentName" HeaderText="Студент" />
                                <asp:BoundField DataField="EnrollmentDate" HeaderText="Дата зачисления" DataFormatString="{0:dd.MM.yyyy}" />
                                <asp:BoundField DataField="Grade" HeaderText="Оценка" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            
            <asp:Label ID="lblNoData" runat="server" CssClass="no-data" Visible="false" Text="Нет курсов в системе"></asp:Label>
        </ContentTemplate>
    </asp:UpdatePanel>

    <style>
        .course-card {
            background: white;
            border-radius: 4px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            border: 1px solid #cccccc;
        }

        .course-header {
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #000000;
        }

        .course-header h3 {
            margin: 0 0 0.75rem 0;
            font-size: 1.5rem;
            color: #000000;
            font-weight: 600;
        }

        .course-meta {
            display: flex;
            gap: 0.75rem;
            flex-wrap: wrap;
        }

        .badge {
            padding: 0.4rem 0.8rem;
            border-radius: 4px;
            font-size: 0.85rem;
            font-weight: 500;
            background: #f5f5f5;
            color: #333333;
            border: 1px solid #cccccc;
        }

        .badge-primary {
            background: #000000;
            color: white;
            border-color: #000000;
        }

        .students-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }

        .students-table thead {
            background: #f5f5f5;
        }

        .students-table th {
            padding: 0.75rem;
            text-align: left;
            font-weight: 500;
            color: #333333;
            font-size: 0.9rem;
            border-bottom: 1px solid #cccccc;
        }

        .students-table td {
            padding: 0.75rem;
            border-bottom: 1px solid #e0e0e0;
            font-size: 0.9rem;
            color: #333333;
        }

        .students-table tr:last-child td {
            border-bottom: none;
        }

        .students-table tr:hover {
            background: #f9f9f9;
        }

        .no-data {
            display: block;
            text-align: center;
            padding: 3rem;
            color: #666666;
            font-size: 1.1rem;
        }
    </style>
</asp:Content>
