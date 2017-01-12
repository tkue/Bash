Securely Deleting Files Using shred
===================================

1. find + shred to recursively delete

```shell
find <directory> -depth -type f -exec shred -v -n 10 -z -u {} \;
```

2. Should run on each file:

```shell
shred -v -n $1 "/path/to/your/file"         # overwriting with random data
sync;                                       # forcing a sync of the buffers to the disk
                                            #   (fsync should be run by shred, though)
shred -v -n 0 -z -u "/path/to/your/file";   # overwriting with zeroes and remove the file
```


----
__Source:__[StackExchange](https://unix.stackexchange.com/questions/27027/how-do-i-recursively-shred-an-entire-directory-tree)
