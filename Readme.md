# turtlepower/gecko

Gecko is a turtle powered wrapper for xmr-stak (https://github.com/fireice-uk/xmr-stak-cpu). Gecko handles start up and shut down and can be easily installed as a service. Check out mondo for gecko on docker (https://github.com/michelangelo314/mondo)

## Install

Use curl to grab the installer script and pipe it to bash w/ sudo.

```
$ curl -sL https://raw.githubusercontent.com/michelangelo314/gecko/master/bin/installer.sh | sudo bash -
```

Sudo is needed to install the compiler tools and install the utilities.

## Usage

Once the installer is done the xmr stak software will be installed and ready to use with the `gecko` wrapper. Use `gecko config` to edit the config file, 

### Supported Gecko Commands

#### start

starts up the  xmr miner 

```
$ gecko start
```

#### config

opens up the xmr miner config.txt file for editing

```
$ gecko config
```

also can print the path of the config.txt file (for copypasta)

```
$ gecko config path
```

### See also

* TurtleCoin (https://turtlecoin.lol)
* fireiceuk (https://github.com/fireice-uk/)
