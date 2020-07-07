## Window Share Folder
```bash
sudo mount -t cifs //<ip>/<folder_name> -o username=<username>,password=<password>  /mnt/sv001
```
## NAS Synology Share Folder
[Refer this link to setup permission at NAS server](https://www.synology.com/en-us/knowledgebase/DSM/tutorial/File_Sharing/How_to_access_files_on_Synology_NAS_within_the_local_network_NFS)

> Additional steps to setup permission for folder to allow non root user to access

> Allow `Read/Write` permission for `Local Groups` administrators

> Set `NFS Permission` squash for `Map all users to admin`

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

Note 1: Run the following command to show export list from NAS
```bash
showmount -e 192.168.8.251
```

3. Automount
```bash
sudo vi /etc/fstab
```
Add bottom line to end of the file
```bash
192.168.8.251:/volume1/eperp  /mnt/nas001 nfs default 1 2
```
Run following command to test fstab, if the file got error, you might not able to boost the system on next restart
```bash
mount -a
```
