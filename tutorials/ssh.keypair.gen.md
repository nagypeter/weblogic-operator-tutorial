## Creating an SSH key pair for user authentication

The simplest way to generate a key pair is to run `ssh-keygen` without arguments. In this case, it will prompt for the file in which to store keys.

First, the tool asked where to save the file. SSH keys for user authentication are usually stored in the user's `.ssh` directory under the home directory. The default key file name depends on the algorithm, in this case `id_rsa` when using the default RSA algorithm.

Then it asks to enter a passphrase. The passphrase is used for encrypting the key, so that it cannot be used even if someone obtains the private key file. If you don't want to use passphrase leave empty.

Here's an example:

    $ ssh-keygen
    Generating public/private rsa key pair.
    Enter file in which to save the key (/home/oracle/.ssh/id_rsa):
    Enter passphrase (empty for no passphrase):
    Enter same passphrase again:
    Your identification has been saved in /home/oracle/.ssh/id_rsa.
    Your public key has been saved in /home/oracle/.ssh/id_rsa.pub.
    The key fingerprint is:
    SHA256:59A8ONyLBiSpliPCTDyD45OHDSd5XoNJGNSDHeKKz3o oracle@localhost.localdomain
    The key's randomart image is:
    +---[RSA 2048]----+
    |.+*o.            |
    |+o++o.           |
    |oX =+o.          |
    |B.%o.o.. =       |
    |=B=+  . S *      |
    |.=o.   . * o     |
    |  o     o o      |
    | .E    .         |
    |..               |
    +----[SHA256]-----+

Now two files were generated into your `~/.ssh` folder.

- `id_rsa`: private key
- `id_rsa.pub`: public key

On Windows use [PuTTYgen](https://www.ssh.com/ssh/putty/windows/puttygen) to create ssh key pair.
