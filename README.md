# ruby-test-bandung

## Please build a solution to "Backup" all the files and folders under specified folder(s).

### Features
Core Features that we are expecting:
* Authentication / Login
* Backup
* Browse all folders/files that has been backed up

Nice to have:
* Restore
* Storage usage
* Statistic of files
* 2FA, Captcha

### Authentication / Login
User have to login to use the backup service. If the user doesn't exist in the system, he/she can register first.

### Backup
User can create profile(s) and choose which folders/files that user want to backup and exclude.

User can specify folders/files that they want to backup
e.g. Include: /home/ubuntu/backup, /home/test, /var/sys/log

User can specify folders/files that they don't want to backup
e.g. Exclude: .ssh, /home/ubuntu/exclude, /var/sys/sensitive, .gitignore, *.dmg

After the profile is created, user can press backup button to run the backup process.

Important things to take note:
* The solution have to be able to differentiate the new files and updated/changed files (e.g. 1st backup, we backup 10 new files. 2nd backup, we backup 1 new files, and 4 files has been changed.)
* The solution have to be able to track the backup history. (e.g. 1st backup, content of file a is "1234". 2nd backup, content of file a is became "123456789")
* The solution have to be able to track the file information (file permission, group id, owner id, modified time, etc)

### Browse all folders/files that has been backed up
After the backup process completed, user have to be able to browse/see all folders/files that has been backed up.

## If you think your solution is great and you still have a lot of time, you can improve the solution by adding more features

### Restore
User can choose any files/folders from the backup histories. The restore process will replace all existing folder(s)/file(s) information with whichever backup version/history that user chose.
1st Backup, Content file a: "123456"
2nd Backup, Content file a: "123456789"
So if user restore file a with 1st version, content of file a will be "123456"

### Storage usage
Track how much storage that user used.

### Statistic of files
Show chart/insight for each profile:
* file's types that has been backed up
* Range of sizes
* Files that always changed

### 2FA, Captcha
Add more security features on Login


