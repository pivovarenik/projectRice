using System.Xml.Serialization;

namespace Kucherba;

public partial class Account
{
    private const decimal MaxWithdrawal = 100000;
    [XmlIgnore]
    private readonly string _currency = "RUB";  
    public static int _nextId = 1;
    public delegate void OperationHandler(string message);
    public event OperationHandler OnOperation;

    public Account() { AccountId = _nextId++; }

    public override decimal CalculateInterest(decimal balance, DateTime from, DateTime to)
    {
        if (balance <= 0) return 0;

        TimeSpan period = to - from;
        double days = period.TotalDays;
        if (days <= 0) throw new ArgumentException("Дата 'to' должна быть после 'from'");

        double rate = Rate / 100.0;

        if (Capitalization)
        {
            double n = 365.0;
            double t = days / 365.0;
            decimal amount = balance * (decimal)Math.Pow(1 + rate / n, n * t);
            return amount - balance;
        }

        return balance * (decimal)rate * (decimal)(days / 365.0);
        
    }

    public void Open(decimal initialAmount, DateTime endDate)
    {
        ValidateAmount(initialAmount);
        Balance = initialAmount;
        OpenDate = DateTime.Now;
        ContractEndDate = endDate;
        AddOperation("Open", initialAmount, "Счёт открыт");
    }

    public decimal GetBalanceOnDate(DateTime date)
    {
        ValidateDate(date);
        decimal interest = CalculateInterest(Balance, OpenDate, date);
        return Balance + interest;
    }

    public void WithdrawInterest(DateTime date)
    {
        ValidateDate(date);
        if (CloseDate.HasValue) throw new InvalidOperationException("Счёт закрыт");
    
        decimal interest = CalculateInterest(Balance, OpenDate, date);
        if (interest <= 0) throw new InvalidOperationException("Нет процентов для снятия");
    
        Balance += interest;
        AddOperation("AccrueInterest", interest, "Начисление процентов");
    
        Balance -= interest;
        AddOperation("WithdrawInterest", -interest, "Снятие процентов");
    }

    public void Deposit(decimal amount)
    {
        Balance += amount;
        AddOperation("Deposit", amount, "Пополнение");
    }

    public void Close()
    {
        CloseDate = DateTime.Now;
        AddOperation("Close", -Balance, "Счёт закрыт");
        Balance = 0;
    }

    private void AddOperation(string type, decimal amount, string comment)
    {
        Operations.Add(new Operation { Date = DateTime.Now, Type = type, Amount = amount, BalanceAfter = Balance, Comment = comment });
        OnOperation?.Invoke($"Операция: {type}, Сумма: {amount}");
    }

    private void ValidateDate(DateTime date)
    {
        if (date < OpenDate || date > ContractEndDate) throw new ArgumentException("Дата вне диапазона договора");
    }
    

    
}