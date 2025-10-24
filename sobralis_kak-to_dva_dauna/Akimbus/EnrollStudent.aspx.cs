using System;
using System.Linq;

namespace Akimbus
{
    public partial class EnrollStudent : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadStudents();
                LoadCourses();
            }
        }

        private void LoadStudents()
        {
            using (var db = new SchoolEntities1())
            {
                var students = db.Person
                    .Where(p => p.Discriminator == "Student")
                    .OrderBy(p => p.LastName)
                    .ThenBy(p => p.FirstMidName)
                    .Select(p => new
                    {
                        PersonID = p.PersonID,
                        FullName = p.LastName + " " + p.FirstMidName
                    })
                    .ToList();

                ddlStudent.DataSource = students;
                ddlStudent.DataTextField = "FullName";
                ddlStudent.DataValueField = "PersonID";
                ddlStudent.DataBind();

                ddlStudent.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Выберите студента --", ""));
            }
        }

        private void LoadCourses()
        {
            using (var db = new SchoolEntities1())
            {
                var courses = db.Course
                    .OrderBy(c => c.Title)
                    .Select(c => new
                    {
                        CourseID = c.CourseID,
                        CourseInfo = c.Title + " (" + c.Department.Name + ")"
                    })
                    .ToList();

                ddlCourse.DataSource = courses;
                ddlCourse.DataTextField = "CourseInfo";
                ddlCourse.DataValueField = "CourseID";
                ddlCourse.DataBind();

                ddlCourse.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Выберите курс --", ""));
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    int studentId = int.Parse(ddlStudent.SelectedValue);
                    int courseId = int.Parse(ddlCourse.SelectedValue);

                    using (var db = new SchoolEntities1())
                    {
                        // Проверка на существующую запись
                        if (db.Enrollment.Any(en => en.StudentID == studentId && en.CourseID == courseId))
                        {
                            lblMessage.Text = "Ошибка: Студент уже записан на этот курс!";
                            lblMessage.CssClass = "message error";
                            lblMessage.Visible = true;
                            return;
                        }

                        var enrollment = new Enrollment
                        {
                            StudentID = studentId,
                            CourseID = courseId,
                            Grade = string.IsNullOrEmpty(ddlGrade.SelectedValue) 
                                ? (decimal?)null 
                                : decimal.Parse(ddlGrade.SelectedValue)
                        };

                        db.Enrollment.Add(enrollment);
                        db.SaveChanges();

                        lblMessage.Text = "✓ Студент успешно записан на курс!";
                        lblMessage.CssClass = "message success";
                        lblMessage.Visible = true;

                        // Сброс формы
                        ddlStudent.SelectedIndex = 0;
                        ddlCourse.SelectedIndex = 0;
                        ddlGrade.SelectedIndex = 0;
                    }
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "Ошибка при записи на курс: " + ex.Message;
                    lblMessage.CssClass = "message error";
                    lblMessage.Visible = true;
                }
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("Default.aspx");
        }
    }
}
