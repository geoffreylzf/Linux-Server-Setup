## Window Share Folder
```bash
sudo mount -t cifs //<ip>/<folder_name> -o username=<username>,password=<password>  /mnt/sv001
```
## NAS Synology Share Folder
[Refer this link to setup permission at NAS server](https://www.synology.com/en-us/knowledgebase/DSM/tutorial/File_Sharing/How_to_access_files_on_Synology_NAS_within_the_local_network_NFS)

1. Create mount folder at `/mnt`
```bash
cd /mnt
mkdir nas001
```

2. Mount folder

```bash
sudo mount <ip>:/volume1/<folder_name> /mnt/<mount_folder> -vvv
```
Example
```bash
sudo mount 192.168.8.251:/volume1/eperp /mnt/nas001 -vvv
```

> `-vvv` is for showing connection log
