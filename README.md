# BOINConPi
A script to help automate the installation of BOINC on Raspberry Pis. This has been tested to work on Rpi3B/3B+ and Rpi4 models, but should work on any raspbian-based distro.

The script supports crunching as guest or using your own account manager such as BAM!. By default, priority is given to projects in the following order: medical research, physics/astrophysics, umbrella projects (World Community Grid, for example), math.

To install boinc on your pi, run the following in any terminal:

`wget 'https://github.com/springfielddatarecovery/BOINConPi/blob/main/boinconpi.sh';sudo chmod +x boinconpi.sh;sudo ./boinconpi.sh`

You can run with as `./boinconpi.sh 1` to enable auto-mode which installs guest crunching without requiring you to answer any prompts.


