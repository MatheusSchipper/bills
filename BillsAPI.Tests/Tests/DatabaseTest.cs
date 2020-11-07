using BillsAPI.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using Xunit;

namespace BillsAPI.Tests.Tests
{
    public class DatabaseTest : TestBase
    {

        [Trait(CategoryTrait, InitialStateOfDatabaseCategory)]
        [Fact(DisplayName ="Should verify if table is empty on start")]
        public void TableCreatedAndEmpty()
        {
            Assert.False(billContext.Bills.Any());
        }

        [Trait(CategoryTrait, FieldRequiredCategory)]
        [Fact(DisplayName = "billModel without field Name")]
        public void ThrowsADbUpdateExcpetionWhenNameIsMissing()
        {
            var testBill = new BillModel();
            billContext.Bills.Add(testBill);
            Assert.Contains(ValidateModel(testBill), result => result.ErrorMessage == ErrorMessages.NameRequired);
            Assert.Throws<DbUpdateException>(() => billContext.SaveChanges());
        }

        [Trait(CategoryTrait, InvalidFieldCategory)]
        [Fact(DisplayName = "DueDate previous than current year")]
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

        [Trait(CategoryTrait, InvalidFieldCategory)]
        [Fact(DisplayName = "OriginalValue negative")]
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

        [Trait(CategoryTrait, VerificationOfPersistedDataCategory)]
        [Fact(DisplayName = "Verify if ID is persisted in the database")]
        public void GenerateAnIDWhenABillModelIsCreatedAndSavedInTheDatabase()
        {
            var testBill = new BillModel
            {
                Name = testName,
                OriginalValue = testValidOriginalValue,
                DueDate = testValidDueDate,
                PaymentDate = testValidPrePaymentDate,
            };

            billContext.Bills.Add(testBill);
            billContext.SaveChanges();

            Assert.NotEqual(Guid.Empty, testBill.Id);
        }

        [Trait(CategoryTrait, VerificationOfPersistedDataCategory)]
        [Fact(DisplayName = "Verify if model is persisted in the database")]
        public void GetTheSameRecordThaWasSavedInTheDatabase()
        {
            var testBill = new BillModel
            {
                Name = testName,
                OriginalValue = testValidOriginalValue,
                DueDate = testValidDueDate,
                PaymentDate = testValidPrePaymentDate,
            };

            billContext.Bills.Add(testBill);
            billContext.SaveChanges();

            Assert.Equal(testBill, billContext.Bills.Find(testBill.Id));
            Assert.Equal(1, billContext.Bills.Count());
        }

        #region Helpers
        /// <summary>
        /// Método para chamar as validações de modelo. Tal qual é feito durante testes de API.
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
        #endregion
    }
}
