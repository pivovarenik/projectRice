using System;
using System.Linq;
using System.Data.Entity;
using System.Web.UI.WebControls;

namespace Akimbus
{
    public partial class CoursesManage : System.Web.UI.Page
    {
        private string SortDirection
        {
            get { return ViewState["SortDirection"] as string ?? "ASC"; }
            set { ViewState["SortDirection"] = value; }
        }

        private string SortExpression
        {
            get { return ViewState["SortExpression"] as string ?? "CourseID"; }
            set { ViewState["SortExpression"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindGrid();
            }
        }

        private void BindGrid()
        {
            using (var db = new SchoolEntities1())
            {
                var query = db.Course.Include(c => c.Department);

                // Сортировка
                switch (SortExpression)
                {
                    case "CourseID":
                        query = SortDirection == "ASC" ? query.OrderBy(c => c.CourseID) : query.OrderByDescending(c => c.CourseID);
                        break;
                    case "Title":
                        query = SortDirection == "ASC" ? query.OrderBy(c => c.Title) : query.OrderByDescending(c => c.Title);
                        break;
                    case "Credits":
                        query = SortDirection == "ASC" ? query.OrderBy(c => c.Credits) : query.OrderByDescending(c => c.Credits);
                        break;
                    case "DepartmentID":
                        query = SortDirection == "ASC" ? query.OrderBy(c => c.Department.Name) : query.OrderByDescending(c => c.Department.Name);
                        break;
                    default:
                        query = query.OrderBy(c => c.CourseID);
                        break;
                }

                CoursesGrid.DataSource = query.ToList();
                CoursesGrid.DataBind();
            }
        }

        protected void CoursesGrid_RowEditing(object sender, GridViewEditEventArgs e)
        {
            CoursesGrid.EditIndex = e.NewEditIndex;
            BindGrid();
            
            // Загрузить список кафедр в DropDownList
            var row = CoursesGrid.Rows[e.NewEditIndex];
            var ddl = row.FindControl("ddlDepartment") as DropDownList;
            if (ddl != null)
            {
                using (var db = new SchoolEntities1())
                {
                    ddl.DataSource = db.Department.OrderBy(d => d.Name).ToList();
                    ddl.DataBind();
                }
            }
        }

        protected void CoursesGrid_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int courseId = (int)CoursesGrid.DataKeys[e.RowIndex].Value;

            using (var db = new SchoolEntities1())
            {
                var course = db.Course.Find(courseId);
                if (course != null)
                {
                    var txtTitle = CoursesGrid.Rows[e.RowIndex].FindControl("txtTitle") as TextBox;
                    var txtCredits = CoursesGrid.Rows[e.RowIndex].FindControl("txtCredits") as TextBox;
                    var ddlDepartment = CoursesGrid.Rows[e.RowIndex].FindControl("ddlDepartment") as DropDownList;

                    if (txtTitle != null && txtCredits != null && ddlDepartment != null)
                    {
                        course.Title = txtTitle.Text;
                        course.Credits = Convert.ToInt32(txtCredits.Text);
                        course.DepartmentID = Convert.ToInt32(ddlDepartment.SelectedValue);

                        db.SaveChanges();
                    }
                }
            }

            CoursesGrid.EditIndex = -1;
            BindGrid();
        }

        protected void CoursesGrid_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            CoursesGrid.EditIndex = -1;
            BindGrid();
        }

        protected void CoursesGrid_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int courseId = (int)CoursesGrid.DataKeys[e.RowIndex].Value;

            using (var db = new SchoolEntities1())
            {
                var course = db.Course.Include("Enrollment").SingleOrDefault(c => c.CourseID == courseId);
                if (course != null)
                {
                    // Удалить связанные Enrollments
                    if (course.Enrollment != null && course.Enrollment.Any())
                    {
                        db.Enrollment.RemoveRange(course.Enrollment);
                    }
                    db.Course.Remove(course);
                    db.SaveChanges();
                }
            }

            e.Cancel = true;
            CoursesGrid.EditIndex = -1;
            BindGrid();
        }

        protected void CoursesGrid_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            CoursesGrid.PageIndex = e.NewPageIndex;
            BindGrid();
        }

        protected void CoursesGrid_Sorting(object sender, GridViewSortEventArgs e)
        {
            if (SortExpression == e.SortExpression)
            {
                SortDirection = (SortDirection == "ASC") ? "DESC" : "ASC";
            }
            else
            {
                SortExpression = e.SortExpression;
                SortDirection = "ASC";
            }
            BindGrid();
        }
    }
}
