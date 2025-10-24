using System;
using System.Linq;

namespace Akimbus
{
    public partial class Courses : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindDepartments();
                if (ddlDepartments.Items.Count > 0)
                {
                    BindCourses();
                }
            }
        }

        private void BindDepartments()
        {
            using (var db = new SchoolEntities1())
            {
                ddlDepartments.DataSource = db.Department.OrderBy(d => d.Name).ToList();
                ddlDepartments.DataBind();
            }
        }

        private void BindCourses()
        {
            if (ddlDepartments.SelectedValue == null) return;

            int departmentId = Convert.ToInt32(ddlDepartments.SelectedValue);
            using (var db = new SchoolEntities1())
            {
                var courses = db.Course
                    .Where(c => c.DepartmentID == departmentId)
                    .Select(c => new
                    {
                        c.CourseID,
                        c.Title,
                        c.Credits,
                        DepartmentName = c.Department.Name
                    })
                    .ToList();

                CoursesGrid.DataSource = courses;
                CoursesGrid.DataBind();
            }
        }

        protected void ddlDepartments_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindCourses();
        }
    }
}
