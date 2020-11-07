#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["BillsAPI/BillsAPI.csproj", "BillsAPI/"]
RUN dotnet restore "BillsAPI/BillsAPI.csproj"
COPY ./BillsAPI ./BillsAPI
WORKDIR "/src/BillsAPI"
RUN dotnet build "BillsAPI.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "BillsAPI.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "BillsAPI.dll"]