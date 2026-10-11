# syntax=docker/dockerfile:1

########## build stage ##########
FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build
WORKDIR /src

# restore first so dependency layer is cached between CI runs
COPY Homework.Api.csproj .
RUN dotnet restore

COPY . .
RUN dotnet publish -c Release -o /app/publish --no-restore

########## runtime stage ##########
FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS final
WORKDIR /app

COPY --from=build /app/publish .

# .NET 8+ images ship a built-in non-root user 'app' (uid 1654, exposed as $APP_UID)
USER $APP_UID

ENV ASPNETCORE_HTTP_PORTS=8080
EXPOSE 8080
ENTRYPOINT ["dotnet", "Homework.Api.dll"]
