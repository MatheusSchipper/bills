using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using BillsAPI.Context;
using BillsAPI.Models;

namespace BillsAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class BillController : ControllerBase
    {
        private readonly BillContext _context;

        public BillController(BillContext context)
        {
            _context = context;
        }

        // GET: api/Bill
        [HttpGet]
        public async Task<ActionResult<IEnumerable<BillModel>>> GetBills()
        {
            return await _context.Bills.ToListAsync();
        }

        // PUT: api/Bill/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPut("{id}")]
        public async Task<IActionResult> PutBillModel(Guid id, BillModel billModel)
        {
            if (id != billModel.Id)
            {
                return BadRequest();
            }

            _context.Entry(billModel).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!BillModelExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/Bill
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPost]
        public async Task<ActionResult<BillModel>> PostBillModel(BillModel billModel)
        {
            try
            {
                var currentYear = DateTime.Now.Year;
                var firstDateOfYear = new DateTime(currentYear, 1, 1);
                if (String.IsNullOrEmpty(billModel.Name))
                    return BadRequest(ErrorMessages.NameRequired);
                else if (billModel.OriginalValue < 0)
                    return BadRequest(ErrorMessages.OriginalValueMustBePositive);
                else if (billModel.DueDate < firstDateOfYear)
                    return BadRequest($"{ErrorMessages.InvalidDueDate}{currentYear}");
                _context.Bills.Add(billModel);
                var persisted = await _context.SaveChangesAsync();
                if (persisted > 0)
                    return Ok();
                else
                    return BadRequest(ErrorMessages.DataNotPersisted);

            } catch(Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        // DELETE: api/Bill/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<BillModel>> DeleteBillModel(Guid id)
        {
            var billModel = await _context.Bills.FindAsync(id);
            if (billModel == null)
            {
                return NotFound();
            }

            _context.Bills.Remove(billModel);
            await _context.SaveChangesAsync();

            return billModel;
        }

        private bool BillModelExists(Guid id)
        {
            return _context.Bills.Any(e => e.Id == id);
        }
    }
}
