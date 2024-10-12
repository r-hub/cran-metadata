# Extra CRAN metadata for pak and pkgcache

[![codecov](https://codecov.io/github/r-hub/cran-metadata/graph/badge.svg?token=QP22VG3Q51)](https://codecov.io/github/r-hub/cran-metadata?branch=main)

Currently contains:
- file sizes,
- SHA 256 hashes,
- system requirements, i.e. the `SystemRequirements` field from
  `DESCRIPTION`,
- for binaries, their build timestamp, i.e. the `Built` field from
  `DESCRIPTION`,
- the timestamp when the package was published on CRAN, i.e. the
  `Date/Publication` field from `DESCRIPTION`.

## Development

This project uses dev containers. It should work out of the box with
VS Code, GitHub Codespaces, VS Codium + DevPod, etc.

### Positron

Positron does not have dev container support yet, so you need to build the
container manually, and connect to it through SSH.

#### Starting for the first time

If you use Positron, then for the first time:
1. Install the [devcontainer cli](https://github.com/devcontainers/cli).
   On macOS you can use
   ```
   brew install devcontainer
   ```
1. Use a random port for SSH (optional).
   ```
   echo PORT=2222 >> .env
   ```
1. Build and start the dev container:
   ```
   devcontainer up --workspace-folder .
   ```
1. Connect from Positron. From the command palette choose
   'Remote-SSH: Connect to Host...' or 'Remote-SSH: Connect Current Window
   to Host...'. The connection string is
   ```
   root@localhost:2222
   ```
   (Use the port you set in `.env`. The default is 2222 if you don't have
   `.env`.)
1. Open the `/workspaces/cran-metadata` folder.

#### Reconnecting

The easiest is to select the remote folder from the list of recently
opened project on the top right. If it is not there, use the last two
steps of the previous section.

#### Stopping

Positron does not stop the container when it disconnects. The devcontainer
cli also cannot stop it currently. To stop the container call docker
directly:
```
docker stop cran-metadata-r-app-1
```

#### Restarting

To restart a stopped container call
```
devcontainer up --workspace-folder .
```

#### Rebuilding

To rebuild a container stop it and delete it before you build it again:
```
docker stop cran-metadata-r-app-1
docker rm cran-metadata-r-app-1
devcontainer up --workspace-folder .
```

# License

MIT (c) Posit, PBC
