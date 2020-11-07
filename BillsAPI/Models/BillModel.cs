using BillsAPI.DateTimeValidations;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace BillsAPI.Models
{
    public class BillModel: IValidatableObject
    {
        public Guid Id { get; set; }

        [DataType(DataType.Text, ErrorMessage =ErrorMessages.InvalidFormat)]
        [Required(ErrorMessage = ErrorMessages.NameRequired)]
        public String Name { get; set; }

        [Range(0, double.MaxValue, ErrorMessage = ErrorMessages.OriginalValueMustBePositive)]
        public double OriginalValue { get; set; }

        [DataType(DataType.Date, ErrorMessage = ErrorMessages.InvalidFormat)]
        public DateTime DueDate { get; set; }

        [DataType(DataType.Date, ErrorMessage = ErrorMessages.InvalidFormat)]
        public DateTime PaymentDate { get; set; }

        public virtual int DaysOverdue
        {
            get
            {
                if (PaymentDate < DueDate)
                    return 0;
                else
                    return (int)Math.Floor((PaymentDate - DueDate).TotalDays);
            }
        }

        public virtual double CorrectedValue
        {
            get
            {
                if (PaymentDate <= DueDate)
                    return OriginalValue;
                else
                {
                    double penalty;
                    double interest;
                    //Até 3 dias, aplicar multa de 2% e juros de 0,1% ao dia
                    if (DaysOverdue < 3)
                    {
                        penalty = OriginalValue * (2 / 100.0);
                        interest = OriginalValue * (DaysOverdue * 0.1 / 100);
                    }
                    //Entre 3 e 5 dias, aplicar multa de 3% e juros de 0,2% ao dia
                    else if (DaysOverdue >= 3 && DaysOverdue < 5)
                    {
                        penalty = OriginalValue * (3 / 100.0);
                        interest = OriginalValue * (DaysOverdue * 0.2 / 100);
                    }
                    //Acima de 5 dias, aplicar multa de 5% e juro de 0,3% ao dia
                    else
                    {
                        penalty = OriginalValue * (5 / 100.0);
                        interest = OriginalValue * (DaysOverdue * 0.3 / 100);
                    }
                    return OriginalValue + penalty + interest;
                }
            }
        }

        public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
        {
            var currentYear = DateTime.Now.Year;
            if (DueDate.Year < currentYear)
                yield return new ValidationResult($"{ErrorMessages.InvalidDueDate}{currentYear}");
            
        }
    }
}
