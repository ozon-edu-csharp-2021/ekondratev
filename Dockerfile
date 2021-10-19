FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["src/OzonEdu.Merchandise.Service/OzonEdu.Merchandise.Service.csproj", "OzonEdu.Merchandise.Service/"]
RUN dotnet restore "OzonEdu.Merchandise.Service/OzonEdu.Merchandise.Service.csproj"
COPY ./src .
WORKDIR "/src/OzonEdu.Merchandise.Service"
RUN dotnet build "OzonEdu.Merchandise.Service.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "OzonEdu.Merchandise.Service.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "OzonEdu.Merchandise.Service.dll"]
