# Build and publish the application
dotnet publish -c Release -o out

# Create a zip file of the published application
Compress-Archive -Path out/* -DestinationPath deploy.zip -Force

Write-Host "Deployment package created: deploy.zip" 