<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Akimbus._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="jumbotron">
        <h1>Лаба: ПРОЕКТУС</h1>
        <p class="lead">воркае.</p>
    </div>

    <div class="row">
        <div class="col-md-4">
            <h2>Студенты</h2>
            <p><a class="btn btn-primary" href="~/Students.aspx" runat="server">Список студентов &raquo;</a></p>
        </div>
        <div class="col-md-4">
            <h2>Добавить студента</h2>
            <p><a class="btn btn-success" href="~/StudentsAdd.aspx" runat="server">Добавить &raquo;</a></p>
        </div>
        <div class="col-md-4">
            <h2>Курсы</h2>
            <p><a class="btn btn-info" href="~/Courses.aspx" runat="server">Просмотр курсов &raquo;</a></p>
        </div>
    </div>
</asp:Content>
