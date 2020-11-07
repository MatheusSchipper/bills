using System;
using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Hosting;

namespace BillsAPI
{
    public class Program
    {
        public static void Main(string[] args)
        {
            //CreateHostBuilder(args).Build().Run();
            CreateWebHostBuilder(args).Build().Run();
        }

         public static IWebHostBuilder CreateWebHostBuilder(string[] args)
    {
        var port = Environment.GetEnvironmentVariable("PORT");

        return WebHost.CreateDefaultBuilder(args)
            .UseStartup<Startup>()
            .UseUrls("http://*:"+port);
    }

        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    var port = Environment.GetEnvironmentVariable("PORT");
                    webBuilder.UseStartup<Startup>().UseUrls("http://*.*" + port);
                });
    }
}
