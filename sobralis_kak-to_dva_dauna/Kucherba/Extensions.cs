namespace Kucherba;

public static class AccountExtensions
{
    public static decimal TotalIncome(this Account account)  // Extension для Account
    {
        return account.Operations.Where(o => o.Type == "Interest").Sum(o => o.Amount);  // Пример
    }
}