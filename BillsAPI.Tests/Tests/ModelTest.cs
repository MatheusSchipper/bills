using BillsAPI.Models;
using System;
using System.Collections.Generic;
using System.Text;
using Xunit;

namespace BillsAPI.Tests.Tests
{
    public class ModelTest : TestBase
    {
        [Trait(CategoryTrait, CalculationCategory)]
        [Fact(DisplayName = "Should CorrectedValue be equal to 102,20 when OriginalValue = 100,00 , PaymentDate is 2 days after the DueDate ")]
        public void CalculateCorrectValueWhenPaymentDateIs2DaysAfterDueDateAndOriginalValueIs100()
        {
            var daysOverdue = 2;
            var testBill = new BillModel
            {
                Name = testName,
                OriginalValue = testValidOriginalValue,
                DueDate = testValidDueDate,
                PaymentDate = testValidDueDate.AddDays(daysOverdue),
            };

            Assert.Equal(daysOverdue, testBill.DaysOverdue);
            Assert.Equal(102.2, testBill.CorrectedValue);
        }

        [Trait(CategoryTrait, CalculationCategory)]
        [Fact(DisplayName = "Should CorrectedValue be equal to 103,80 when OriginalValue = 100,00 , PaymentDate is 4 days after the DueDate ")]
        public void CalculateCorrectValueWhenPaymentDateIs4DaysAfterDueDateAndOriginalValueIs100()
        {
            var daysOverdue = 4;
            var testBill = new BillModel
            {
                Name = testName,
                OriginalValue = testValidOriginalValue,
                DueDate = testValidDueDate,
                PaymentDate = testValidDueDate.AddDays(daysOverdue),
            };

            Assert.Equal(daysOverdue, testBill.DaysOverdue);
            Assert.Equal(103.8, testBill.CorrectedValue);
        }

        [Trait(CategoryTrait, CalculationCategory)]
        [Fact(DisplayName = "Should CorrectedValue be equal to 108,00 when OriginalValue = 100,00 , PaymentDate is 10 days after the DueDate ")]
        public void CalculateCorrectValueWhenPaymentDateIs10DaysAfterDueDateAndOriginalValueIs100()
        {
            var daysOverdue = 10;
            var testBill = new BillModel
            {
                Name = testName,
                OriginalValue = testValidOriginalValue,
                DueDate = testValidDueDate,
                PaymentDate = testValidDueDate.AddDays(daysOverdue),
            };

            Assert.Equal(daysOverdue, testBill.DaysOverdue);
            Assert.Equal(108.0, testBill.CorrectedValue);
        }

    }
}
