using System;
using System.Threading.Tasks;
using Xunit;

namespace BillsAPI.Tests
{
    public class BillContextTest : SqliteDatabaseInMemory
    {
        /// <summary>
        /// Teste para verificar se o banco usado para teste est� sendo criado corretamente e � poss�vel conectar a ele.
        /// </summary>
        /// <returns>Resultado da tentativa de conex�o ao banco de teste.</returns>
        [Fact(DisplayName = "Verify if inMemory database is available and can be connected to")]
        public async Task SqliteDatabaseIsAvailableAndCanBeConnectedTo()
        {
            Assert.True(await billContext.Database.CanConnectAsync());
        }
    }
}
