# Stage 1: Build Angular app
FROM node:20 AS node-build
WORKDIR /app
COPY ClientApp/package*.json ./ClientApp/
WORKDIR /app/ClientApp
RUN npm install
COPY ClientApp/ ./
RUN npm run build 

# Stage 2: Build .NET app
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS dotnet-build
WORKDIR /app
COPY MyFullStackApp.csproj ./
RUN dotnet restore
COPY . ./
# Copy Angular build output to the expected location
COPY --from=node-build /app/ClientApp/dist/client-app/browser ./ClientApp/dist/client-app
RUN dotnet publish -c Release -o out

# Stage 3: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app
COPY --from=dotnet-build /app/out ./
ENV ASPNETCORE_URLS=http://+:80
EXPOSE 80
ENTRYPOINT ["dotnet", "MyFullStackApp.dll"]