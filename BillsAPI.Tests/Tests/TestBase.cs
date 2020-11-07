using System;


namespace BillsAPI.Tests.Tests
{
    public class TestBase : SqliteDatabaseInMemory
    {
        protected int currentYear = DateTime.Now.Year;
        protected string testName = "Name";
        protected double testValidOriginalValue = 100.0;
        protected double testInvalidOriginalValue = -100.0;
        protected DateTime testInvalidDueDate = new DateTime(2019, 1, 1);
        protected DateTime testValidDueDate = new DateTime(DateTime.Now.Year, 11, 6);
        protected DateTime testValidPrePaymentDate = new DateTime(DateTime.Now.Year, 11, 5);

        protected const string CategoryTrait = "Category";
        protected const string InitialStateOfDatabaseCategory = "Initial state of database";
        protected const string FieldRequiredCategory = "Field required";
        protected const string InvalidFieldCategory = "Invalid field";
        protected const string VerificationOfPersistedDataCategory = "Verification of persisted Data";
        protected const string CalculationCategory = "Calculation of interest and penalties";
    }
}
