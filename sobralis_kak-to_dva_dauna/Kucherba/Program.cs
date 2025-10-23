using System.Xml.Linq;
using System.Collections.Generic;
using System.Linq;
using System.Globalization;
using System.Xml.Serialization;
using Kucherba;
class Program
{
    private static List<DepositType> _depositTypes = new List<DepositType>();
    private static List<Account> accounts = new List<Account>();
    private static readonly string XmlFilePath = "deposits.xml";
    private static void SaveAccounts()
    {
        try
        {
            XmlSerializer serializer = new XmlSerializer(typeof(List<Account>));
            using (var writer = new StreamWriter("accounts.xml"))
            {
                serializer.Serialize(writer, accounts);
            }
            Console.WriteLine("Счета сохранены в accounts.xml.");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Ошибка сохранения счетов: {ex.Message}");
        }
    }
    private static void LoadAccounts()
    {
        if (!File.Exists("accounts.xml"))
        {
            Console.WriteLine("Файл accounts.xml не найден. Начинаем с пустого списка счетов.");
            return;
        }

        try
        {
            XmlSerializer serializer = new XmlSerializer(typeof(List<Account>));
            using (var reader = new StreamReader("accounts.xml"))
            {
                accounts = (List<Account>)serializer.Deserialize(reader);
            }
            if (accounts.Any())
            {
                Account._nextId = accounts.Max(a => a.AccountId) + 1;  
            }
            Console.WriteLine($"Загружено {accounts.Count} счетов из accounts.xml.");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Ошибка загрузки счетов: {ex.Message}. Начинаем с пустого списка.");
            accounts = new List<Account>();
        }
    }
    static void Main(string[] args)
    {
        LoadDepositTypes();
        LoadAccounts();
        if (_depositTypes.Count < 5)
        {
            Console.WriteLine("Ошибка: В XML файле должно быть минимум 5 типов депозитов.");
            return;
        }

        bool running = true;
        while (running)
        {
            Console.Clear();
            Console.WriteLine("Меню банковской системы депозитов:");
            Console.WriteLine("1. Открыть новый счёт");
            Console.WriteLine("2. Выбрать существующий счёт для операций");
            Console.WriteLine("3. Сгенерировать отчёты");
            Console.WriteLine("4. Выход");
            Console.Write("Выберите опцию: ");
            string choice = Console.ReadLine();

            switch (choice)
            {
                case "1":
                    OpenNewAccount();
                    break;
                case "2":
                    PerformOperationsOnAccount();
                    break;
                case "3":
                    GenerateReports();
                    break;
                case "4":
                    SaveAccounts();
                    running = false;
                    break;
                default:
                    Console.WriteLine("Неверный выбор. Нажмите Enter для продолжения.");
                    Console.ReadLine();
                    break;
            }
        }
    }

    private static void LoadDepositTypes()
    {
        try
        {
            var doc = XDocument.Load(XmlFilePath);
            _depositTypes = doc.Root.Elements("Deposit")
                .Select(e => new DepositType
                {
                    Id = int.Parse(e.Attribute("id")?.Value ?? throw new InvalidDataException("Отсутствует id")),
                    Name = e.Attribute("name")?.Value ?? throw new InvalidDataException("Отсутствует name"),
                    Rate = double.Parse(e.Attribute("rate")?.Value ?? throw new InvalidDataException("Отсутствует rate"), CultureInfo.InvariantCulture),
                    Capitalization = bool.Parse(e.Attribute("capitalization")?.Value ?? throw new InvalidDataException("Отсутствует capitalization")),
                    MinAmount = decimal.Parse(e.Attribute("minAmount")?.Value ?? throw new InvalidDataException("Отсутствует minAmount"), CultureInfo.InvariantCulture)
                }).ToList();

            if (_depositTypes.Select(d => d.Id).Distinct().Count() != _depositTypes.Count)
                throw new InvalidDataException("Дубликаты ID в XML.");

            var newDoc = new XDocument(new XElement("Deposits", _depositTypes.Select(d => new XElement("Deposit",
                new XAttribute("id", d.Id),
                new XAttribute("name", d.Name),
                new XAttribute("rate", d.Rate),
                new XAttribute("capitalization", d.Capitalization),
                new XAttribute("minAmount", d.MinAmount)))));
            newDoc.Save("deposits_modified.xml");
            Console.WriteLine("XML загружен и валидирован успешно.");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Ошибка загрузки XML: {ex.Message}");
        }
    }

    private static void OpenNewAccount()
    {
        Console.WriteLine("Доступные типы депозитов:");
        foreach (var type in _depositTypes)
        {
            type.DisplayInfo();
        }

        Console.Write("Введите ID типа депозита: ");
        if (!int.TryParse(Console.ReadLine(), out int id))
        {
            Console.WriteLine("Неверный ID.");
            return;
        }

        var selectedType = _depositTypes.FirstOrDefault(t => t.Id == id);
        if (selectedType == null)
        {
            Console.WriteLine("Тип не найден.");
            return;
        }

        Console.Write("Введите начальную сумму: ");
        if (!decimal.TryParse(Console.ReadLine(), out decimal initialAmount) || initialAmount <= 0)
        {
            Console.WriteLine("Сумма должна быть положительной.");
            return;
        }

        Console.Write("Введите дату окончания договора (yyyy-MM-dd): ");
        if (!DateTime.TryParse(Console.ReadLine(), out DateTime endDate) || endDate <= DateTime.Now)
        {
            Console.WriteLine("Дата окончания должна быть в будущем.");
            return;
        }

        var account = new Account
        {
            Id = selectedType.Id,
            Name = selectedType.Name,
            Rate = selectedType.Rate,
            Capitalization = selectedType.Capitalization,
            MinAmount = selectedType.MinAmount
        };

        try
        {
            account.Open(initialAmount, endDate);
            accounts.Add(account);
            Console.WriteLine("Счёт открыт успешно.");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Ошибка: {ex.Message}");
        }

        Console.ReadLine();
    }

   private static void PerformOperationsOnAccount()
{
    if (accounts.Count == 0)
    {
        Console.WriteLine("Нет открытых счетов.");
        Console.ReadLine();
        return;
    }

    Console.WriteLine("Существующие счета:");
    foreach (var acc in accounts)
    {
        Console.WriteLine($"ID: {acc.AccountId}, Тип: {acc.Name}, Баланс: {acc.Balance}, Открыт: {acc.OpenDate.ToShortDateString()}, Закрыт: {(acc.CloseDate.HasValue ? acc.CloseDate.Value.ToShortDateString() : "Нет")}");
    }

    Console.Write("Введите ID счёта: ");
    if (!int.TryParse(Console.ReadLine(), out int accId))
    {
        Console.WriteLine("Неверный ID.");
        Console.ReadLine();
        return;
    }

    var account = accounts.FirstOrDefault(a => a.AccountId == accId);
    if (account == null)
    {
        Console.WriteLine("Счёт не найден.");
        Console.ReadLine();
        return;
    }

    if (account.CloseDate.HasValue)
    {
        Console.WriteLine("Счёт закрыт. Операции недоступны.");
        Console.ReadLine();
        return;
    }

    bool accMenu = true;
    while (accMenu)
    {
        Console.Clear();
        Console.WriteLine($"Операции для счёта {account.AccountId}:");
        Console.WriteLine("1. Посчитать проценты и остаток на дату");
        Console.WriteLine("2. Снять проценты");
        Console.WriteLine("3. Пополнить счёт");
        Console.WriteLine("4. Закрыть счёт");
        Console.WriteLine("5. Назад");
        Console.Write("Выберите опцию: ");
        string opChoice = Console.ReadLine();

        try
        {
            switch (opChoice)
            {
                case "1":
                    Console.Write("Введите дату для расчёта (yyyy-MM-dd): ");
                    if (DateTime.TryParse(Console.ReadLine(), out DateTime calcDate))
                    {
                        var balance = account.GetBalanceOnDate(calcDate);
                        Console.WriteLine($"Остаток на {calcDate.ToShortDateString()}: {balance}");
                    }
                    else
                    {
                        Console.WriteLine("Неверная дата.");
                    }
                    Console.ReadLine();
                    break;
                case "2":
                    Console.Write("Введите дату для снятия процентов (yyyy-MM-dd): ");
                    if (DateTime.TryParse(Console.ReadLine(), out DateTime withdrawDate))
                    {
                        account.WithdrawInterest(withdrawDate);
                        Console.WriteLine("Проценты сняты.");
                    }
                    else
                    {
                        Console.WriteLine("Неверная дата.");
                    }
                    Console.ReadLine(); 
                    break;
                case "3":
                    Console.Write("Введите сумму пополнения: ");
                    if (decimal.TryParse(Console.ReadLine(), out decimal depositAmount) && depositAmount > 0)
                    {
                        account.Deposit(depositAmount);
                        Console.WriteLine("Счёт пополнен.");
                    }
                    else
                    {
                        Console.WriteLine("Сумма должна быть положительной.");
                    }
                    Console.ReadLine(); // Пауза после вывода результата
                    break;
                case "4":
                    account.Close();
                    Console.WriteLine("Счёт закрыт.");
                    accMenu = false;
                    break;
                case "5":
                    accMenu = false; 
                    break;
                default:
                    Console.WriteLine("Неверный выбор.");
                    Console.ReadLine(); 
                    break;
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Ошибка: {ex.Message}");
            Console.ReadLine();
        }
    }
}

    private static void GenerateReports()
    {
        if (accounts.Count == 0)
        {
            Console.WriteLine("Нет счетов для отчётов.");
            Console.ReadLine();
            return;
        }

        Console.WriteLine("Генерация отчётов:");
        Console.Write("Введите ID счёта для statement.csv (или 0 для всех в summary.csv): ");
        if (!int.TryParse(Console.ReadLine(), out int repId))
        {
            Console.WriteLine("Неверный ID.");
            return;
        }

        try
        {
            if (repId == 0)
            {
                GenerateSummaryCsv();
                Console.WriteLine("summary.csv сгенерирован.");
            }
            else
            {
                var account = accounts.FirstOrDefault(a => a.AccountId == repId);
                if (account == null)
                {
                    Console.WriteLine("Счёт не найден.");
                    return;
                }
                GenerateStatementCsv(account);
                Console.WriteLine("statement.csv сгенерирован.");
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Ошибка генерации отчёта: {ex.Message}");
        }

        Console.ReadLine();
    }

    private static void GenerateStatementCsv(Account account)
    {
        using (var writer = new StreamWriter("statement.csv", false, System.Text.Encoding.UTF8))
        {
            writer.WriteLine("Дата;Операция;Сумма;Остаток;Комментарий");
            foreach (var op in account.Operations)
            {
                string comment = op.Comment?.Replace("\"", "\"\"") ?? "";
                if (comment.Contains(",") || comment.Contains("\"") || comment.Contains("\n"))
                {
                    comment = $"\"{comment}\"";
                }
                writer.WriteLine($"{op.Date:yyyy-MM-dd HH:mm:ss};{op.Type};{op.Amount};{op.BalanceAfter};{comment}");
            }
        }
    }

    private static void GenerateSummaryCsv()
    {
        using (var writer = new StreamWriter("summary.csv", false, System.Text.Encoding.UTF8))
        {
            writer.WriteLine("Счёт;Доход");
            foreach (var acc in accounts)
            {
                decimal income = acc.TotalIncome();
                writer.WriteLine($"{acc.AccountId};{income}");
            }
        }
    }
}
