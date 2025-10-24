using System;
using System.Data.Entity;
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
                LoadCourses();
            }
        }

        private void LoadCourses()
        {
            using (var db = new SchoolEntities1())
            {
                var courses = db.Course
                    .Include(c => c.Department)
                    .Include(c => c.Enrollment)
                    .OrderBy(c => c.Title)
                    .Select(c => new
                    {
                        c.CourseID,
                        c.Title,
                        c.Credits,
                        DepartmentName = c.Department.Name,
                        StudentCount = c.Enrollment.Count()
                    })
                    .ToList();

                if (courses.Any())
                {
                    rptCourses.DataSource = courses;
                    rptCourses.DataBind();
                    lblNoData.Visible = false;
                }
                else
                {
                    lblNoData.Visible = true;
                }
            }
        }

        protected void rptCourses_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                var courseData = e.Item.DataItem;
                int courseId = (int)courseData.GetType().GetProperty("CourseID").GetValue(courseData);

                GridView gvStudents = (GridView)e.Item.FindControl("gvStudents");

                using (var db = new SchoolEntities1())
                {
                    var enrollments = db.Enrollment
                        .Where(en => en.CourseID == courseId)
                        .OrderBy(en => en.Person.LastName)
                        .ThenBy(en => en.Person.FirstMidName)
                        .Select(en => new
                        {
                            StudentName = en.Person.LastName + " " + en.Person.FirstMidName,
                            EnrollmentDate = en.Person.EnrollmentDate,
                            GradeValue = en.Grade
                        })
                        .ToList();

                    var students = enrollments.Select(enr => new
                    {
                        enr.StudentName,
                        enr.EnrollmentDate,
                        Grade = enr.GradeValue.HasValue ? GetGradeText(enr.GradeValue.Value) : "Нет оценки"
                    }).ToList();

                    gvStudents.DataSource = students;
                    gvStudents.DataBind();
                }
            }
        }

        private string GetGradeText(decimal grade)
        {
            return ((int)grade).ToString();
        }
    }
}
