namespace Kucherba;

public class DepositType
{
    public int Id { get; set; }
    public string Name { get; set; }
    public double Rate { get; set; }
    public bool Capitalization { get; set; }
    public decimal MinAmount { get; set; }

    public virtual decimal CalculateInterest(decimal balance, DateTime from, DateTime to)
    {
        TimeSpan period = to - from;
        return balance * (decimal)Rate / 100 * (decimal)(period.Days / 365.0);
    }

    public virtual void ValidateAmount(decimal amount)
    {
        if (amount < MinAmount) throw new ArgumentException("Сумма меньше минимальной");
    }

    public void DisplayInfo() 
    {
        Console.WriteLine($"№{Id} -> Тип: {Name}, Ставка: {Rate}%, Мин. сумма: {MinAmount}");
    }
}