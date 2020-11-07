using System;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Text;
using Microsoft.Data.Sqlite;
using BillsAPI.Context;

namespace BillsAPI.Tests
{
    public abstract class SqliteDatabaseInMemory : IDisposable
    {
        private const string InMemorySqliteConnectionString = "DataSource=:memory:";
        private readonly SqliteConnection _connection;

        protected readonly BillContext billContext;

        protected SqliteDatabaseInMemory()
        {
            _connection = new SqliteConnection(InMemorySqliteConnectionString);
            _connection.Open();
            var options = new DbContextOptionsBuilder<BillContext>().UseSqlite(_connection).Options;
            billContext = new BillContext(options);
            billContext.Database.EnsureCreated();
        }
        public void Dispose()
        {
            _connection.Close();
        }
    }
}
