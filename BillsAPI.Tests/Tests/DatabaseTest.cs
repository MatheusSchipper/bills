using BillsAPI.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using Xunit;

namespace BillsAPI.Tests.Tests
{
    public class DatabaseTest : SqliteDatabaseInMemory
    {
        private int currentYear = DateTime.Now.Year;
        private string testName = "Name";
        private double testValidOriginalValue = 100.0;
        private double testInvalidOriginalValue = -100.0;
        private DateTime testInvalidDueDate = new DateTime(DateTime.Now.Year - 1, 1, 1);
        private DateTime testValidDueDate = new DateTime(DateTime.Now.Year, 11, 6);
        private DateTime testInvalidPaymentDate = new DateTime(2019, 2, 2);
        private DateTime testValidPrePaymentDate = new DateTime(DateTime.Now.Year, 11, 5);
        private DateTime testValidPosPaymentDate = new DateTime(DateTime.Now.Year, 11, 16);


        [Fact(DisplayName ="Should verify if table is empty on start")]
        public void TableCreatedAndEmpty()
        {
            Assert.False(billContext.Bills.Any());
        }

        [Fact(DisplayName = "Should throws an DbUpdateException when name is missing")]
        public void ThrowsAnExcpetionWhenNameIsMissing()
        {
            var testBill = new BillModel();
            billContext.Bills.Add(testBill);
            Assert.Contains(ValidateModel(testBill), result => result.ErrorMessage == ErrorMessages.NameRequired);
            Assert.Throws<DbUpdateException>(() => billContext.SaveChanges());
        }

        [Fact(DisplayName = "Should return ValidationResult with InvalidDueDate message when due date is previous than current year")]
        public void ReturnValidationResultWithDueDateInvalidMessageWhenDueDateIsPreviousThanCurrentYear()
        {

            var testBill = new BillModel
            { 
                Name = testName, 
                DueDate = testInvalidDueDate,
                OriginalValue = testValidOriginalValue, 
                PaymentDate = testValidPrePaymentDate, 
            };
            Assert.Contains(ValidateModel(testBill), result => result.ErrorMessage == $"{ErrorMessages.InvalidDueDate}{currentYear}");
        }

        [Fact(DisplayName = "Should return ValidationResult with OriginalValueMustBePositive message when originalValue is negative")]
        public void ReturnValidationResultWithDueOriginalValueMustBePositiveMessageWhenOriginalValueIsNegative()
        {
            var testBill = new BillModel
            { 
                Name = testName, 
                OriginalValue = testInvalidOriginalValue, 
                DueDate = testValidDueDate,
                PaymentDate = testValidPrePaymentDate, 
            };
            Assert.Contains(ValidateModel(testBill), result => result.ErrorMessage == ErrorMessages.OriginalValueMustBePositive);
        }

        /// <summary>
        /// Método para realizar as validações do modelo. Tal qual é feito durante testes de API.
        /// </summary>
        /// <param name="billModel"></param>
        /// <returns></returns>
        private IList<ValidationResult> ValidateModel(BillModel billModel)
        {
            var validationResults = new List<ValidationResult>();
            var validationContext = new ValidationContext(billModel);
            Validator.TryValidateObject(billModel, validationContext, validationResults, true);
            return validationResults;
        }
    }
}
