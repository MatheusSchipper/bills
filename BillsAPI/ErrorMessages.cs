using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace BillsAPI
{
    public class ErrorMessages
    {
        public const string InvalidFormat = "Campo está no formato incorreto";
        public const string InvalidDueDate = "Só é possível inserir contas com data de vencimento a partir de 01/01/";
        public const string NameRequired = "Campo Name é obrigatório";
        public const string OriginalValueMustBePositive = "O Valor da conta deve ser um valor positivo";
        public const string DataNotPersisted = "Dados não salvos";
    }
}
