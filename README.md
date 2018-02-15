# How to use these configs

```
$ git clone https://gitlab.com/mjwhitta/weechat $HOME/.weechat
$ cd $HOME/.weechat
$ mkdir -p configs/server
$ cp samples/{irc,sec}.conf configs/server/
```

Open all the conf files with your editor of choice and fill in the
needed variables. Then start weechat with your config like so:

```
$ source $HOME/.weechat/irc
$ irc -a server
```

or

```
$ $HOME/.weechat/irc -a server
```

Once in Weechat, run `/secure passphrase ******`. The values in
`configs/server/sec.conf` are now aes-256 encrypted. If you want to
change these values easily, you can run `/secure passphrase <tab>` in
Weechat to decrypt `configs/server/sec.conf`, then edit in your editor
of your choice. After your changes are made, you can re-encrypt again
like before.

These configs set Weechat to automatically connect to the server
unless you pass the `-a` or `--no-connect` flag (disables
autoconnect). If running with the `-a` flag, you can connect to the
server with this command, `/connect server`.

# How to install weechat

These configs depend on a newer version of Weechat that allows the use
of sec data in config values that don't need to be encrypted
(something like 1.9.1 or above). This may require compiling by hand
for some distros. Check your package manager first.

## Debian

```
$ sudo apt-get install \
      cmake \
      guile-2.0-libs \
      libaspell15 \
      libc6 \
      libgc1c2 \
      libgcrypt20 \
      libgcrypt20-dev \
      libgmp10 \
      libgnutls-deb0-28 \
      libgnutls28-dev \
      liblua5.2-0 \
      liblua5.2-dev \
      libnotify-bin \
      libperl-dev \
      libperl5.20 \
      libpython2.7 \
      libpython2.7-dev \
      libruby2.1 \
      libtcl8.6 \
      xfce4-notifyd \
      zlib1g
$ cd /path/to/where/you/want/repo
$ git clone https://github.com/weechat/weechat.git
$ mkdir -p weechat/build
$ cd weechat/build
$ cmake ..
$ make
$ sudo make install
```

## OSX

```
$ brew install --with-aspell --with-curl --with-lua --with-perl \
    --with-python --with-ruby weechat
```

### Install terminal-notifier

via RubyGems:

```
$ gem install terminal-notifier
```

via HomeBrew:

```
$ brew install terminal-notifier
```
