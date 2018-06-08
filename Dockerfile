FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY helloapi/*.csproj ./helloapi/
RUN dotnet restore

# copy everything else and build app
COPY helloapi/. ./helloapi/
WORKDIR /app/helloapi
RUN dotnet publish -c Release -o out


FROM microsoft/dotnet:2.1-aspnetcore-runtime AS runtime
WORKDIR /app
COPY --from=build /app/helloapi/out ./
ENTRYPOINT ["dotnet", "helloapi.dll"]
