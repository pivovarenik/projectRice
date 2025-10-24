using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;

namespace Akimbus
{
    public partial class Search : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Не загружаем данные до поиска
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            PerformSearch();
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtLastName.Text = "";
            txtFirstName.Text = "";
            txtDateFrom.Text = "";
            txtDateTo.Text = "";
            gvResults.DataSource = null;
            gvResults.DataBind();
            lblResultCount.Text = "0";
        }

        private void PerformSearch()
        {
            using (var db = new SchoolEntities1())
            {
                var query = db.Person.Where(p => p.Discriminator == "Student").AsQueryable();

                // Фильтр по фамилии
                if (!string.IsNullOrWhiteSpace(txtLastName.Text))
                {
                    query = query.Where(p => p.LastName.Contains(txtLastName.Text));
                }

                // Фильтр по имени
                if (!string.IsNullOrWhiteSpace(txtFirstName.Text))
                {
                    query = query.Where(p => p.FirstMidName.Contains(txtFirstName.Text));
                }

                // Фильтр по дате (от)
                if (!string.IsNullOrWhiteSpace(txtDateFrom.Text))
                {
                    DateTime dateFrom = DateTime.Parse(txtDateFrom.Text);
                    query = query.Where(p => p.EnrollmentDate >= dateFrom);
                }

                // Фильтр по дате (до)
                if (!string.IsNullOrWhiteSpace(txtDateTo.Text))
                {
                    DateTime dateTo = DateTime.Parse(txtDateTo.Text);
                    query = query.Where(p => p.EnrollmentDate <= dateTo);
                }

                // Получаем результаты с количеством курсов
                var results = query
                    .Select(p => new
                    {
                        StudentID = p.PersonID,
                        p.LastName,
                        p.FirstMidName,
                        p.EnrollmentDate,
                        CourseCount = p.Enrollment.Count()
                    })
                    .ToList();

                // Применяем сортировку
                string sortExpression = ViewState["SortExpression"] as string ?? "LastName";
                string sortDirection = ViewState["SortDirection"] as string ?? "ASC";

                var sortedResults = ApplySorting(results.Cast<dynamic>().ToList(), sortExpression, sortDirection);

                gvResults.DataSource = sortedResults;
                gvResults.DataBind();
                lblResultCount.Text = results.Count.ToString();
            }
        }

        private List<dynamic> ApplySorting(List<dynamic> results, string sortExpression, string sortDirection)
        {
            if (sortDirection == "ASC")
            {
                switch (sortExpression)
                {
                    case "StudentID":
                        return results.OrderBy(r => ((dynamic)r).StudentID).ToList();
                    case "LastName":
                        return results.OrderBy(r => ((dynamic)r).LastName).ToList();
                    case "FirstMidName":
                        return results.OrderBy(r => ((dynamic)r).FirstMidName).ToList();
                    case "EnrollmentDate":
                        return results.OrderBy(r => ((dynamic)r).EnrollmentDate).ToList();
                    case "CourseCount":
                        return results.OrderBy(r => ((dynamic)r).CourseCount).ToList();
                    default:
                        return results;
                }
            }
            else
            {
                switch (sortExpression)
                {
                    case "StudentID":
                        return results.OrderByDescending(r => ((dynamic)r).StudentID).ToList();
                    case "LastName":
                        return results.OrderByDescending(r => ((dynamic)r).LastName).ToList();
                    case "FirstMidName":
                        return results.OrderByDescending(r => ((dynamic)r).FirstMidName).ToList();
                    case "EnrollmentDate":
                        return results.OrderByDescending(r => ((dynamic)r).EnrollmentDate).ToList();
                    case "CourseCount":
                        return results.OrderByDescending(r => ((dynamic)r).CourseCount).ToList();
                    default:
                        return results;
                }
            }
        }

        protected void gvResults_Sorting(object sender, GridViewSortEventArgs e)
        {
            string sortExpression = e.SortExpression;
            string sortDirection = "ASC";

            if (ViewState["SortExpression"] as string == sortExpression)
            {
                sortDirection = ViewState["SortDirection"] as string == "ASC" ? "DESC" : "ASC";
            }

            ViewState["SortExpression"] = sortExpression;
            ViewState["SortDirection"] = sortDirection;

            PerformSearch();
        }

        protected void gvResults_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvResults.PageIndex = e.NewPageIndex;
            PerformSearch();
        }
    }
}
