using System;
using System.Threading.Tasks;
using Xunit;

namespace BillsAPI.Tests
{
    public class BillContextTest : SqliteDatabaseInMemory
    {
        /// <summary>
        /// Teste para verificar se o banco usado para teste está sendo criado corretamente e é possível conectar a ele.
        /// </summary>
        /// <returns>Resultado da tentativa de conexão ao banco de teste.</returns>
        [Fact(DisplayName = "Verify if inMemory database is available and can be connected to")]
        public async Task SqliteDatabaseIsAvailableAndCanBeConnectedTo()
        {
            Assert.True(await billContext.Database.CanConnectAsync());
        }
    }
}
