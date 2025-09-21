# dxvk-build-tools

A collection of scripts and tools for constructing a docker image to build dxvk, vkd3d-proton, dxvk-sarek, dxvk-ags, dxvk-nvapi, dxvk-tests, d3d8to9, nvcuda, nvidia-libs, apitrace and even dsoal. Are you on Debian & derivatives or some other obscure distro and are tired of shuffling MinGW versions? Forget about your worries and build dxvk, vkd3d-proton, dxvk-sarek, dxvk-ags, dxvk-nvapi, dxvk-tests, d3d8to9, nvcuda, nvidia-libs, apitrace and dsoal using an Arch based docker container (much like the dxvk GitHub CI is doing).

## What do I need?

Docker and dependencies (containerd, runc etc.), in whatever form it comes with your distro. As a note, on Debian and friends the docker package is very intuitively called `docker.io`.

And also git, in case that wasn't already painfully obvious.

## How do I use these things?

* After installing docker you'll need to add your user to the docker group.
  
    `sudo usermod -aG docker <your_username>`
  
    Will do the trick, afterwards you'll need a restart of the docker demon (or your system).

* Secondly, you need to make sure all the .sh scripts have their execute permissions set, otherwise nothing will work. Note that execute permissions also need to be added to the scripts that are in the `source` and `misc` folders.

* Now you're set to fetch the latest Arch docker image and construct your build containers. To do that simply run:
  
    `./docker_build.sh`

* Finally, you're now ready to launch the build container and enjoy your builds! Use:
  
    `./repo_build_runner.sh <repo_name> [<build_name>]`
  
    Where `<repo_name>` can be either dxvk, vkd3d-proton, dxvk-sarek, dxvk-ags, dxvk-nvapi, dxvk-tests, d3d8to9, nvcuda, nvidia-libs, apitrace or dsoal. You can optionally also specify a `<build_name>`, otherwise it will default to `devel`.
  
    Run the above whenever you need to build/rebuild dxvk, vkd3d-proton, dxvk-sarek, dxvk-ags, dxvk-nvapi, dxvk-tests, d3d8to9, nvcuda, nvidia-libs, apitrace or dsoal. Note that the scripts will delete the previously compiled binaries if you use the same parameters. Back up any folders in the `output` directory if you want to keep older versions around.

## Wait, d3d8to9? Isn't that built using MSVC?

The release builds are, indeed, however the provided script will use MinGW to build a 32-bit library on the same Arch docker container. Apart from an increased size, it should very much behave identically to its MSVC counterpart.

## What about dxvk-native?

To build the native version of dxvk, you can use:

`./repo_build_runner.sh <repo_name> [<build_name>] --native`

Where `<repo_name>` can only be dxvk. You can optionally also specify a `<build_name>`, otherwise it will default to `devel`.

Note that by default the builder will use an Arch image for the build process. If you want a Steam Runtime SDK compatible "Sniper" build, please first download and build the image, using:

`./docker_build-sniper.sh`

And change the following line in the `repo_build_runner.sh` script:

`DOCKER_IMAGE_TAG=":sniper"`

Subsequent builds will use the Sniper image, and you will need to revert the value to `":latest"` if you wish to return to Arch based builds.

