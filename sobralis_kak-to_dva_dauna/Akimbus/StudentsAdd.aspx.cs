using System;
using System.Web.UI.WebControls;

namespace Akimbus
{
    public partial class StudentsAdd : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void StudentsDetails_ItemInserting(object sender, DetailsViewInsertEventArgs e)
        {
            try
            {
                using (var db = new SchoolEntities1())
                {
                    var person = new Person
                    {
                        LastName = e.Values["LastName"] as string,
                        FirstMidName = e.Values["FirstMidName"] as string,
                        EnrollmentDate = e.Values["EnrollmentDate"] != null 
                            ? Convert.ToDateTime(e.Values["EnrollmentDate"]) 
                            : (DateTime?)null,
                        Discriminator = "Student"
                    };

                    db.Person.Add(person);
                    db.SaveChanges();
                }

                Response.Redirect("~/Students.aspx");
            }
            catch (Exception ex)
            {
                e.Cancel = true;
                // Можно добавить label для отображения ошибки
            }
        }
    }
}
