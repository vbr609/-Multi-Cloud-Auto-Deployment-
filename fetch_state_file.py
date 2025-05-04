from azure.storage.blob import BlobClient

# Replace with your SAS URL
sas_url = "INSERT YOUR SAS URL HERE IF YOUR REPOSITORY IS PRIVATE OTHERWISE USE AZURE IDENTITY OR KEY VAULT TO STORE SAS TOKEN" # SAS URL to the state file in the Azure Blob Storage
local_file_path = "state_file.tfstate"  # Path to save the downloaded file

try:
    # Create a BlobClient using the SAS URL
    blob_client = BlobClient.from_blob_url(sas_url)

    # Download the blob content to a local file
    with open(local_file_path, "wb") as download_file:
        download_stream = blob_client.download_blob()
        download_file.write(download_stream.readall())

    print(f"State file downloaded successfully to {local_file_path}")

except Exception as e:
    print(f"Failed to download state file: {e}")