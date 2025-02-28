## Bash Timer

Shows a human-readable execution time for every command run in bash.

You might also find my [**Amazing Linux, PHP, and Git Aliases**](https://gist.github.com/hopeseekr/fb85b7a179e3b9c97212925a2bd8400b) quite useful as well.

The time will show up in the bottom left, immediately left of your `$PS1`.

![bash-timer image](https://user-images.githubusercontent.com/1125541/93687425-7c392100-fa83-11ea-9d36-cacbe03cc725.png)
```
2 days 05:02:11.33 # A very long process
```

## Installation

### Use the Installer

```bash
curl https://raw.githubusercontent.com/hopeseekr/bash-timer/v1.5.0/install | bash
```

### Manual

1. Download the files:

```bash
curl https://raw.githubusercontent.com/hopeseekr/bash-timer/v1.5.0/bash-timer.sh -o $HOME/.bash-timer.sh
echo "c9cf58a86712eb7360e08a072d03e53548e5e362944ab651aa71ee2a7846d22f $HOME/.bash-timer.sh" | sha256sum -c -

curl https://raw.githubusercontent.com/hopeseekr/bash-timer/v1.5.0/assets/bash-preexec.sh -o $HOME/.bash-preexec.sh
echo "d512aa6043d69d636f0db711aab1675cc7c49b39da9ae58afcfb916dca8c4464 $HOME/.bash-preexec.sh" | sha256sum -c -
```

2. Add the following to the very bottom of your `~/.bashrc`.

```bash
# Bash Timer
# See https://github.com/hopeseekr/bash-timer
[[ -f ~/.bash-timer.sh ]] && source ~/.bash-timer.sh

# See https://github.com/rcaloras/bash-preexec
# **WARNING:** This must be the last line of your .bashrc.
# Source our file at the end of our bash profile (e.g. ~/.bashrc, ~/.profile, or ~/.bash_profile)
[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
```
## License

This project is licensed under the [Creative Commons Attribution License v4.0 International](LICENSE.cc-by.md).

![License Summary](https://user-images.githubusercontent.com/1125541/93617603-cd6de580-f99b-11ea-9da4-f79c168c97df.png)

## Contributors

[Theodore R. Smith](https://www.phpexperts.pro/]) <theodore@phpexperts.pro>  
GPG Fingerprint: 4BF8 2613 1C34 87AC D28F  2AD8 EB24 A91D D612 5690  
CEO: PHP Experts, Inc.
