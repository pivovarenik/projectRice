using System;
using System.Linq;
using System.Data.Entity;
using System.Web.UI.WebControls;

namespace Akimbus
{
    public partial class Students : System.Web.UI.Page
    {
        private string SortDirection
        {
            get { return ViewState["SortDirection"] as string ?? "ASC"; }
            set { ViewState["SortDirection"] = value; }
        }

        private string SortExpression
        {
            get { return ViewState["SortExpression"] as string ?? "PersonID"; }
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
                var query = db.Person.Where(p => p.Discriminator == "Student");
                
                // Применяем фильтры поиска
                if (!string.IsNullOrWhiteSpace(txtSearchLastName.Text))
                {
                    query = query.Where(p => p.LastName.Contains(txtSearchLastName.Text));
                }
                
                if (!string.IsNullOrWhiteSpace(txtSearchFirstName.Text))
                {
                    query = query.Where(p => p.FirstMidName.Contains(txtSearchFirstName.Text));
                }
                
                if (!string.IsNullOrWhiteSpace(txtSearchDateFrom.Text))
                {
                    DateTime dateFrom = DateTime.Parse(txtSearchDateFrom.Text);
                    query = query.Where(p => p.EnrollmentDate >= dateFrom);
                }
                
                if (!string.IsNullOrWhiteSpace(txtSearchDateTo.Text))
                {
                    DateTime dateTo = DateTime.Parse(txtSearchDateTo.Text);
                    query = query.Where(p => p.EnrollmentDate <= dateTo);
                }

                // Сортировка
                switch (SortExpression)
                {
                    case "PersonID":
                        query = SortDirection == "ASC" ? query.OrderBy(p => p.PersonID) : query.OrderByDescending(p => p.PersonID);
                        break;
                    case "LastName":
                        query = SortDirection == "ASC" ? query.OrderBy(p => p.LastName) : query.OrderByDescending(p => p.LastName);
                        break;
                    case "FirstMidName":
                        query = SortDirection == "ASC" ? query.OrderBy(p => p.FirstMidName) : query.OrderByDescending(p => p.FirstMidName);
                        break;
                    case "EnrollmentDate":
                        query = SortDirection == "ASC" ? query.OrderBy(p => p.EnrollmentDate) : query.OrderByDescending(p => p.EnrollmentDate);
                        break;
                    default:
                        query = query.OrderBy(p => p.PersonID);
                        break;
                }

                StudentsGrid.DataSource = query.ToList();
                StudentsGrid.DataBind();
            }
        }

        protected void StudentsGrid_RowEditing(object sender, GridViewEditEventArgs e)
        {
            StudentsGrid.EditIndex = e.NewEditIndex;
            BindGrid();
        }

        protected void StudentsGrid_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int personId = (int)StudentsGrid.DataKeys[e.RowIndex].Value;

            using (var db = new SchoolEntities1())
            {
                var person = db.Person.Find(personId);
                if (person != null)
                {
                    person.LastName = e.NewValues["LastName"] as string;
                    person.FirstMidName = e.NewValues["FirstMidName"] as string;
                    
                    if (e.NewValues["EnrollmentDate"] != null)
                    {
                        person.EnrollmentDate = Convert.ToDateTime(e.NewValues["EnrollmentDate"]);
                    }

                    db.SaveChanges();
                }
            }

            StudentsGrid.EditIndex = -1;
            BindGrid();
        }

        protected void StudentsGrid_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            StudentsGrid.EditIndex = -1;
            BindGrid();
        }

        protected void StudentsGrid_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            // Ensure cascade behavior even if DB doesn't cascade
            var idObj = StudentsGrid.DataKeys[e.RowIndex].Value;
            int personId = Convert.ToInt32(idObj);
            using (var db = new SchoolEntities1())
            {
                var person = db.Person.Include("Enrollment").SingleOrDefault(p => p.PersonID == personId);
                if (person != null)
                {
                    if (person.Enrollment != null && person.Enrollment.Any())
                    {
                        db.Enrollment.RemoveRange(person.Enrollment);
                    }
                    db.Person.Remove(person);
                    db.SaveChanges();
                }
            }
            e.Cancel = true;
            StudentsGrid.EditIndex = -1;
            BindGrid();
        }

        protected void StudentsGrid_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            StudentsGrid.PageIndex = e.NewPageIndex;
            BindGrid();
        }

        protected void StudentsGrid_Sorting(object sender, GridViewSortEventArgs e)
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
        
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            StudentsGrid.PageIndex = 0; // Сбрасываем на первую страницу
            BindGrid();
        }
        
        protected void btnClearSearch_Click(object sender, EventArgs e)
        {
            txtSearchLastName.Text = "";
            txtSearchFirstName.Text = "";
            txtSearchDateFrom.Text = "";
            txtSearchDateTo.Text = "";
            StudentsGrid.PageIndex = 0;
            BindGrid();
        }
    }
}
