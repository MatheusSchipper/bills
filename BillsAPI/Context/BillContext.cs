using BillsAPI.Models;
using Microsoft.EntityFrameworkCore;

namespace BillsAPI.Context
{
    public class BillContext : DbContext
    {
        public BillContext(DbContextOptions<BillContext> options) : base(options)
        {
            Database.EnsureCreated();
        }

        public DbSet<BillModel> Bills { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<BillModel>().HasKey(model => model.Id);
            base.OnModelCreating(modelBuilder);
        }
    }
}
