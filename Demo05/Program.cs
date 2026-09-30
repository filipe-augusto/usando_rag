
using Microsoft.EntityFrameworkCore;
using Microsoft.SemanticKernel.Embeddings;
using OllamaSharp;
using Pgvector;
using Pgvector.EntityFrameworkCore;

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

app.MapPost("v1/products", async (
    CreateProductViewModel model,
    AppDbContext context, OllamaApiClient ollama) =>
{
    var product = new Product()
    {
        Title = model.Title,
        Category = model.Category,
        Summary = model.Summary,
        Description = model.Description
    };
    await context.Products.AddAsync(product);

    var service = ollama.AsTextEmbeddingGenerationService();
    var embedding = await service.GenerateEmbeddingAsync(model.Category);
    var recomendation = new Recomendation()
    {
        Title = model.Title,
        Category = model.Category,
        Embedding = new Vector(embedding)
    };
    await context.Recomendations.AddAsync(recomendation);

    await context.SaveChangesAsync();
    return Results.Ok(new
    {
        message = "OK"
    });
});


app.MapPost("v1/prompt", async (
    QuestionViewModel model,
    AppDbContext context, OllamaApiClient ollama) =>
{
    var service = ollama.AsTextEmbeddingGenerationService();
    var embedding = await service.GenerateEmbeddingAsync(model.Prompt);
    var vector = new Vector(embedding);

    var recomendations = await context.Recomendations.AsNoTracking()
        .OrderBy(r => r.Embedding.CosineDistance(vector))
        .Take(5).
        Select(r => new
        {
            r.Title,
            r.Category
        }) 
        .ToListAsync();

    return Results.Ok(recomendations);
});


app.Run();
