using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;

namespace Akimbus
{
    public partial class Statistics : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadStatistics();
            }
        }

        private void LoadStatistics()
        {
            using (var db = new SchoolEntities1())
            {
                // Общие счетчики
                lblTotalStudents.Text = db.Person.Count(p => p.Discriminator == "Student").ToString();
                lblTotalCourses.Text = db.Course.Count().ToString();
                lblTotalDepartments.Text = db.Department.Count().ToString();
                lblTotalEnrollments.Text = db.Enrollment.Count().ToString();

                // Статистика по кафедрам
                var departmentStats = db.Department
                    .Select(d => new
                    {
                        DepartmentName = d.Name,
                        CourseCount = d.Course.Count(),
                        TotalCredits = d.Course.Sum(c => (int?)c.Credits) ?? 0
                    })
                    .OrderByDescending(d => d.CourseCount)
                    .ToList();
                gvDepartmentStats.DataSource = departmentStats;
                gvDepartmentStats.DataBind();

                // Статистика по оценкам
                var totalEnrollments = db.Enrollment.Count();
                var gradeStats = db.Enrollment
                    .Where(e => e.Grade != null)
                    .GroupBy(e => e.Grade)
                    .Select(g => new
                    {
                        Grade = g.Key ?? 0,
                        Count = g.Count()
                    })
                    .OrderBy(g => g.Grade)
                    .ToList()
                    .Select(g => new
                    {
                        Grade = GetGradeText(g.Grade),
                        Count = g.Count,
                        Percentage = totalEnrollments > 0 ? (double)g.Count / totalEnrollments * 100 : 0
                    })
                    .ToList();
                gvGradeStats.DataSource = gradeStats;
                gvGradeStats.DataBind();

                // Топ-5 популярных курсов
                var topCourses = db.Course
                    .Select(c => new
                    {
                        CourseTitle = c.Title,
                        DepartmentName = c.Department.Name,
                        EnrollmentCount = c.Enrollment.Count()
                    })
                    .OrderByDescending(c => c.EnrollmentCount)
                    .Take(5)
                    .ToList();
                gvTopCourses.DataSource = topCourses;
                gvTopCourses.DataBind();

                // Активность студентов
                var studentActivity = db.Person
                    .Where(p => p.Discriminator == "Student")
                    .Select(p => new
                    {
                        StudentName = p.LastName + " " + p.FirstMidName,
                        EnrollmentDate = p.EnrollmentDate,
                        CourseCount = p.Enrollment.Count()
                    })
                    .OrderByDescending(s => s.CourseCount)
                    .ToList();
                gvStudentActivity.DataSource = studentActivity;
                gvStudentActivity.DataBind();
            }
        }

        private string GetGradeText(decimal? grade)
        {
            if (grade == null) return "Без оценки";
            
            switch ((int)grade.Value)
            {
                case 0: return "F (Неуд)";
                case 1: return "D (Удовл)";
                case 2: return "C (Хорошо)";
                case 3: return "B (Очень хорошо)";
                case 4: return "A (Отлично)";
                default: return grade.Value.ToString();
            }
        }

        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            LoadStatistics();
        }

        protected void gvStudentActivity_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvStudentActivity.PageIndex = e.NewPageIndex;
            LoadStatistics();
        }
    }
}
