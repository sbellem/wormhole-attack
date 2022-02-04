# wormhole attack analysis
Scattered notes on the wormhole attack

The Dockerfile sets a wormhole version prior to the patched version, and uses soteria
to scan the code for vulnerabilities. See
https://www.soteria.dev/post/the-wormhole-hack-how-soteria-detects-the-vulnerability-automatically
for details about the attack and soteria.

The quickest way to run the example is by using the image from dockerhub:

```console
docker run --rm sbellem/wormhole-soteria-scan
```

Alternatively, clone this repo, e.g.:

```console
git clone https://github.com/sbellem/wormhole-attack-analysis.git
```

and run:

```console
docker-compose run --rm wormhole-soteria-scan
```

You should see an output similar to:

![image](https://user-images.githubusercontent.com/125458/152494070-29558993-993a-49bf-8218-6b2a59dea54a.png)


## Questions
Which version of wormhole has been attacked? The above blog seems to imply that it was the dev.v1 branch, but that is not a release, and it does not seem to be recent. The latest release is v2.7.2 ...
