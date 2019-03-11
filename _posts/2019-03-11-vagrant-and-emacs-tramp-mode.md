---
title: Test Kitchen/Vagrant Remote Shell and File Editing with Emacs' TRAMP Mode
---

<a href="https://www.gnu.org/software/emacs/"><img src="/assets/emacs.png" alt="Emacs" align="right" /></a>

I use [Emacs](https://www.gnu.org/software/emacs/)' [Shell Mode](https://www.gnu.org/software/emacs/manual/html_node/emacs/Shell-Mode.html) for embedding my terminal in my editor, so I have access to the output and history of every command I run. Using [Kitchen](https://kitchen.ci) with [Vagrant](https://www.vagrantup.com/) allows me to quickly go back and forth between my [Chef](https://chef.io) recipes and testing with [InSpec](https://inspec.io). Emacs' [TRAMP Mode](https://www.emacswiki.org/emacs/TrampMode) is a package for editing remote files, but it can also be used to open remote shells. This is quite useful when working with tools like Vagrant and Test Kitchen when you need to debug how your code is behaving on test instances.

The video below demonstrates what this looks like in action, the relevant commands follow below.

# Vagrant Remote Shell and File Editing via Emacs' TRAMP Mode

<iframe width="560" height="315" src="https://www.youtube.com/embed/I6_Ze2Am7-4" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

## Commands Used

To use Emacs' Shell mode:

    M-x shell

The Example cookbook from the video is here: https://github.com/mattray/example-cookbook/ Run the Chef client on the Vagrant VM:

    kitchen converge

Use InSpec to verify the contents:

    kitchen verify

Open the remote directory with Emacs' TRAMP mode.

    C-x C-f
    /ssh:vagrant@127.0.0.1#2222:/tmp/

Open the remote file with `sudo`:

    C-x C-f
    /ssh:vagrant@127.0.0.1#2222|sudo:127.0.0.1:/tmp/example

Verify the changes:

    kitchen verify

That works, but let's SSH to the Vagrant instance and remove the files:

    C-u M-x shell

I called it `vagrant` and set the starting directory to `/tmp/` and set my shell to `/bin/bash`. I `sudo`d to `root`, because that's what Chef runs as and deleted that example file. I then edited the recipe to match the expected test.

    kitchen converge

and

    kitchen verify

Everything appears to be working, so I closed my remote TRAMP buffers and deleted the Vagrant VM.

    kitchen destroy
