using System;
using System.Linq;
using System.Web.UI;

namespace Akimbus
{
    public partial class CoursesAdd : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDepartments();
            }
        }

        private void LoadDepartments()
        {
            using (var db = new SchoolEntities1())
            {
                ddlDepartment.DataSource = db.Department.OrderBy(d => d.Name).ToList();
                ddlDepartment.DataTextField = "Name";
                ddlDepartment.DataValueField = "DepartmentID";
                ddlDepartment.DataBind();
                
                ddlDepartment.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Выберите кафедру --", ""));
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    using (var db = new SchoolEntities1())
                    {
                        var course = new Course
                {
                    Title = txtTitle.Text.Trim(),
                    Credits = int.Parse(txtCredits.Text),
                    DepartmentID = int.Parse(ddlDepartment.SelectedValue)
                };

                        db.Course.Add(course);
                        db.SaveChanges();

                        Response.Redirect("CoursesManage.aspx");
                    }
                }
                catch (Exception ex)
                {
                    var errorMsg = ex.Message;
                    if (ex.InnerException != null)
                    {
                        errorMsg += "<br/>" + ex.InnerException.Message;
                        if (ex.InnerException.InnerException != null)
                        {
                            errorMsg += "<br/>" + ex.InnerException.InnerException.Message;
                        }
                    }
                    lblMessage.Text = "Ошибка при добавлении курса: " + errorMsg;
                    lblMessage.CssClass = "message error-message";
                    lblMessage.Visible = true;
                }
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("CoursesManage.aspx");
        }
    }
}
