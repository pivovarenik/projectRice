namespace Kucherba;

public partial class Account : DepositType
{
    public int AccountId { get; set; }
    public decimal Balance { get; set; }
    public DateTime OpenDate { get; set; }
    public DateTime? CloseDate { get; set; }
    public DateTime ContractEndDate { get; set; }
    public List<Operation> Operations { get; set; } = new List<Operation>();

}