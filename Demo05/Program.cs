
using Microsoft.EntityFrameworkCore;
using Microsoft.SemanticKernel.Embeddings;
using OllamaSharp;
using Pgvector;

var builder = WebApplication.CreateBuilder(args);
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");  

builder.Services.AddDbContext<AppDbContext>(x =>
{
    x.UseNpgsql(connectionString, p => p.UseVector());
});


builder.Services.AddTransient<OllamaApiClient>(_ =>
    new OllamaApiClient(
        "http://localhost:11434",
        "mxbai-embed-large"));
var app = builder.Build();

app.MapGet("/", () => "Hello World!");
app.MapGet("/v1/seed", async (
    AppDbContext context,
    OllamaApiClient ollama) =>
{
    var products = await context.Products.ToListAsync();

    foreach (var product in products)
    {
        var service = ollama.AsTextEmbeddingGenerationService();
        var embedding = await service.GenerateEmbeddingAsync(product.Category);

        var recomendation = new Recomendation()
        {
    Title = product.Title,
    Category = product.Category,
    Embedding = new Vector(embedding)
        };
        await context.Recomendations.AddAsync(recomendation);
        await context.SaveChangesAsync();

    }

     

    return Results.Ok(new
    {
        message = "OK"
    });
});
app.Run();
