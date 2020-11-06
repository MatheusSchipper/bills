using System;
using System.ComponentModel.DataAnnotations;

namespace BillsAPI.Models
{
    public class BillModel
    {
        public Guid Id { get; set; }
        [Required(ErrorMessage = "Campo Name é obrigatório")]
        public String Name { get; set; }
        [Required(ErrorMessage = "Campo OriginalValue é obrigatório")]
        public double OriginalValue { get; set; }
        [Required(ErrorMessage = "Campo OriginalValue é obrigatório")]
        public DateTime DueDate { get; set; }
        [Required(ErrorMessage = "Campo PaymentDate é obrigatório")]
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
    }
}
