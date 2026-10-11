var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/", () => Results.Json(new
{
    status  = "ok",
    message = "Hello from .NET 8 container!",
    machine = Environment.MachineName   // = container hostname, nice for proving the data comes from inside the image
}));

app.MapGet("/health", () => Results.Json(new { status = "ok" }));

app.Run();
