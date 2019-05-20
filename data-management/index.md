---
layout: post
title: Data Management
categories:
 - data-management
---

<script src="/js/smooth-scroll.min.js"></script>

This page is a description of recommended data management practices specifically for the Riggleman Lab, but some of the tools and techniques described below are relevant and useful to other labs or individuals using \*nix-based systems.

## Table of Contents

- [Our Network-Attached Storage (NAS) Device](#our-network-attached-storage-nas-device)
- [Getting Started](#getting-started)
  + [Step 0: Ask whoever’s running the NAS to make an account for you](#step-0-ask-whoevers-running-the-nas-to-make-an-account-for-you)
  + [Step 1: Change your password](#step-1-change-your-password)
  + [Step 2: Set up password-free SSH](#step-2-set-up-password-free-ssh)
  + [Step 3: Set up recurring automatic backups](#step-3-set-up-recurring-automatic-backups)
- [Navigating rrstorage](#navigating-rrstorage)
- [Some useful tools for data management](#some-useful-tools-for-data-management)
  + [screen](#screen)
  + [rsync](#rsync)
  + [tar](#tar)

## Our Network-Attached Storage (NAS) Device

We use an 8-bay [Synology DS1817+](https://www.synology.com/en-us/products/DS1817+) NAS device. This device will help us achieve 2 important things: 1) regular backups of ongoing work, and 2) long-term storage of completed work. The storage on this device is divided into 2 volumes, `volume1` and `volume2`, where `volume1` is intended for regular backups and `volume2` is intended for long-term storage. The image and table below summarize the differences between the two volumes.

![Synology NAS Device](/images/data-management/synology-nas.png "Synology NAS Device")

|              | `volume1`                      | `volume2`                     |
| ------------ | ------------------------------ | ----------------------------- |
| Disks        | 2 x 10 TB                      | 4 x 8 TB                      |
| RAID Level   | 0                              | 5                             |
| Redundancy   | lose all data if 1 disk fails  | lose all data if 2 disks fail |
| Storage      | ~18 TB                         | ~ 21 TB                       |
| Intended Use | rrlogin home directory backups | long-term storage of previous projects |

We won't get into the weeds with RAID (Redundant Array of Independent Disks) terminology but you can follow [this link](https://en.wikipedia.org/wiki/Standard_RAID_levels) to learn more about RAID from Wikipedia. The main thing you need to know is that with RAID level 0 (as in `volume1`) we have no reduncancy, meaning we lose everything if one of the 2 disks fail, but with RAID level 5 (as in `volume2`) we give up about 1 disk's worth of storage space to ensure that we lose nothing if one of the 4 disks fails. The complete lack of redundancy is fine for `volume1` since this is **only** intended to hold regular backups of ongoing work anyway.

## Getting Started

NOTE: Anywhere it says `user` below, substitute your own username.

The NAS can be accessed either via SSH in your terminal or in a browser-based GUI. You'll need to do some setup steps in both. Here are the steps you'll need to take:

### Step 0: Ask whoever's running the NAS to make an account for you

Whoever adds your account needs to make sure of the following things:
1. The username on the NAS matches the username you have on rrlogin
2. You are added as an admin, which is necessary to get SSH access
3. You have read/write access to the `/volume2/homes/` and `/volume1/backup/` directories
4. They write down the dummy password they used to create your account and give it to you.

### Step 1: Change your password

To change your password, type `rrstorage.synology.me:5000` into a web browser. You should see a screen that looks like the one below. Sign in with the username and password set up in Step 0.

![rrstorage login screen](/images/data-management/login-screen.png "rrstorage login screen")

From there, click the "Personal" option under the Profile dropdown. This will open a window that lets you change your password.

![rrstorage profile dropdown](/images/data-management/personal-settings-dropdown.png)

### Step 2: Set up password-free SSH

For auto-backups to take place, rrlogin and rrstorage need to be able to communicate with each other without asking you for a password each time. To set this up, you need to do the following while logged into rrlogin:

```
user@rrlogin:~$ cd /opt/share/rrbackup
user@rrlogin:/opt/share/rrbackup$ ./setup_ssh.sh
```

The script will ask you some questions, and you need to leave things blank and press `Enter`, or `yes` then `Enter` if it asks a yes/no question. The script will do the following things:
1. Check if password-free SSH access has already been set up
2. If not, then create `~/.ssh/authorized_keys` file with proper permissions in your account on the NAS and copy your public key to the NAS
3. Create an alias (with your permission) to make SSH-ing into the NAS easier (you'll type `rrstorage` to log in)

*Side Note:* Usually, to set up password-free SSH access, you need to the following:

```
$ user@macbook:~$ ssh-keygen -t rsa
$ user@macbook:~$ cat .ssh/id_rsa.pub | ssh user@hostname 'cat >> .ssh/authorized_keys'
```

The first command generates a public key in `.ssh/id_rsa.pub`, so if this file already exists, you don't need to do it again. The second command adds the contents of that file to the end of the `.ssh/authorized_keys` file on the remote server so it recognizes your computer next time you SSH in. For the NAS, a few other things need to happen, like creating necessary directories with the right permissions, so the script simplifies the process. You can see the contents of the script [here](https://github.com/benlindsay/rrbackup/blob/master/setup_ssh.sh).

<div class="spacer"></div>

### Step 3: Set up recurring automatic backups

While still in the `/opt/share/rrbackup` directory, run the following command:

```
user@rrlogin:/opt/share/rrbackup$ ./setup_cron_backup.sh
```

This will do the following:
1. Add a line to your crontab file that runs the `backup.sh` file at 12:01 AM every night. Although `backup.sh` will be run every night, the script itself checks whether it's your day for a backup, and only runs the actual backup command if it's your day.
2. Add a line to the `user_list.txt` file with your username. This file determines the order of backups. i.e. if backups happen every 2 weeks (which is the case as of 7/28/2017), then the first person (and the 15th and 29th people etc.) will be backed up on the first day of the cycle, the second person (and the 16th and 30th people etc.) will be backed up on the second day of the cycle etc.

To make sure the command worked, you could type `crontab -l` to print the contents of your crontab file, which would look like this (if you didn't already have stuff in your crontab file):

```
user@rrlogin:~$ crontab -l
# BEGIN BACKUP COMMAND
1 0 * * * /opt/share/rrbackup/backup.sh
# END BACKUP COMMAND
```

If you want more information about setting up `cron` jobs, you can find that [here](http://www.adminschoice.com/crontab-quick-reference).

<div class="bigspacer"></div>

## Navigating rrstorage

Now that you're done with the initial setup stuff, let's log in and explore. Begin by either using the `rrstorage` alias setup for you in rrlogin or typing `ssh user@rrstorage.synology.me`:

```
user@rrlogin:~$ rrstorage
user@rrstorage:~$ pwd
/var/services/homes/user
user@rrstorage:~$ readlink -f .
/volume2/homes/user
```

The `readlink -f .` command above tells us the true file path of the home directory, showing that when we log in, we are in `volume2`. As mentioned above, this is where you'll move data to when you are not currently working on it.

After the first time your rrlogin home directory has been backed up, you'll be able to find that data in your `/volume1/backup/user/rrbackup/` folder. So finding your backed-up data would look like this:

```
user@rrlogin:~$ rrstorage
user@rrstorage:~$ cd /volume1/backup/$USER/rrbackup
user@rrstorage:/volume1/backup/user$ ls
[all of user's backed-up files]
```

<div class="bigspacer"></div>

## Some useful tools for data management

A little farther below we'll talk about some best practices for data management. This will involve very useful tools like `screen`, `rsync`, and `tar`, so let's go over those tools first.

### screen

The `screen` command opens a persistent session that can continue even after you close your terminal. This lets you run commands on the head node that take hours, days, or weeks without having to maintain a terminal connection. Let's see how this works in a simple example.

If I'm logged into rrlogin and type `screen`, like so:

```
user@macbook:~$ ssh user@rrlogin.seas.upenn.edu
user@rrlogin:~$ screen
```

then my terminal window will clear and show a new screen session. Now let's say I need to do something very important like print "hello" to the terminal once a second until I tell it to stop in a week or so.

```
user@rrlogin:~$ while true; do echo hello; sleep 1; done
hello
hello
hello
hello
...
```

While this command is running, I can leave this screen session using `CTRL-A`+`CTRL-D`, after which I can see what screen processes are running. In my case I had a couple others running at the same time, so all of them show up:

```
user@macbook:~$ ssh user@rrlogin.seas.upenn.edu
user@rrlogin:~$ screen
[detached]
user@rrlogin:~$ screen -ls
There are several suitable screens on:
        17658.pts-8.rrlogin     (Detached)
        9479.pts-18.rrlogin     (Detached)
        6457.pts-2.rrlogin      (Detached)
        665.pts-8.rrlogin     	(Detached)
Type "screen [-d] -r [pid.]tty.host" to resume one of them.
```

At this point, I can log out of rrlogin, come back a week or so later and jump back into my important process:

```
user@macbook:~$ ssh user@rrlogin.seas.upenn.edu
user@rrlogin:~$ screen -r 6457
```

at which point I'll see my super useful process, which I'll kill with `CTRL-C`, then kill the whole screen session using `exit` or `CTRL-D` (not `CTRL-A`+`CTRL-D`, which would detach it again).

```
...
hello
hello
hello
hello

user@rrlogin:~$ exit
```

CAUTION: Any computationally intensive task should still be done on the compute nodes rather than using `screen` on the head node so we don't slow down the cluster.

### rsync

`rsync` is a more powerful and versatile alternative to `scp`. Here are its benefits over `scp`:
- `rsync` compares local files to remote files and only transfers files that are different or new
- Stopping and restarting an rsync job doesn’t make it start back from the beginning
- Sync-ing files again after making changes is much faster if not all files have been changed since last sync

`rsync` has lots of options you can choose from, but here are the most important ones:
- `-a` means "archive mode", which basically means copy recursively and keep everything the same (owner, permissions, etc.)
- `-v` means "verbose mode", which prints the paths of all files copied
- `--delete` means that if there are files in the destination directory that aren't there in the source directory, those files are deleted from the destination directory. This is good for regular backups, you but won't need it for a one-time file transfer.

Another little nuance is that it matters whether or not there's a `/` after the directory. Use the `/` if you want to copy the contents of the directory and not the directory itself.

Example 1:

```
user@rrlogin:~$ rsync -av dir_to_copy user@rrstorage.synology.me:~
building file list ... done
dir_to_copy/
dir_to_copy/dir1/
dir_to_copy/dir1/file1
dir_to_copy/dir1/dir2/
dir_to_copy/dir1/dir2/file2

sent 285 bytes  received 82 bytes  244.67 bytes/sec
total size is 16  speedup is 0.04
user@rrlogin:~$ rrstorage
user@rrstorage:~$ tree .
.
`-- dir_to_copy
    `-- dir1
        |-- dir2
        |   `-- file2
        `-- file1
```

Example 2:

```
user@rrlogin:~$ rsync -av dir_to_copy/ user@rrstorage.synology.me:~
building file list ... done
./
dir1/
dir1/file1
dir1/dir2/
dir1/dir2/file2

sent 274 bytes  received 82 bytes  237.33 bytes/sec
total size is 16  speedup is 0.04
user@rrlogin:~$ rrstorage
user@rrstorage:~$ tree .
.
`-- dir1
    |-- dir2
    |   `-- file2
    `-- file1
```

<div class="spacer"></div>

### tar

The `tar` command compresses and decompresses files and folders. Compression and decompression can take a while, especially if you're dealing with 10s or 100s of GB of data, but if you have a large project that you don't expect to touch for a long time, it's probably worth it to compress. Compressing a large directory before moving it off of rrlogin has several benefits:
- You can use less storage space to store the same amount of data
- File transfer is faster for one large file than many small files of the same total size
- Having a single compressed file will make it easier to back up archived projects on our Team Google Drive.

The `tar` command, like `rsync`, has many available options, but only a few that will likely matter to us. Here are the important ones:
- `-c` tells `tar` to create a tar file, as opposed to extracting from one
- `-x` tells `tar` to extract from a tar file, as opposed to creating one
- `-z` means to use zip/gzip to compress (any `.tar.gz` or `.tgz` file used this option)
- `-v` means "verbose", or print file names as they're compressed
- `-f` means we'll specify the name of the tarball

But really all you need to know is that creating a tarball looks like this:

```
user@rrlogin:~$ tar -czvf my_big_project.tar.gz my_big_project/
```

and decompressing that tarball looks like this:

```
user@rrlogin:~$ tar -xzvf my_big_project.tar.gz
```

For big projects, it's best to do this within a screen session using the `screen` command since these commands can take a while to run.

<script>
  $("a").each(function(i) {
    $(this).attr("data-scroll", true);
  });
  smoothScroll.init();
</script>
