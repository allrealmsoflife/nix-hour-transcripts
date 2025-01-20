# Nix Hour Transcripts

This repository contains transcripts of **Nix Hour**, a series of sessions by
[Tweag](https://www.tweag.io/) presented by **Silvan Mosberger**. The sessions
provide deep insights into the Nix and NixOS ecosystem.

The goal is to make the knowledge from these sessions more accessible and easier
to reference for the community.

To have a more complete experience following along have the nixpkgs locally:

### Fork, Clone, and Sync Nixpkgs Locally

1. Fork the repository on GitHub by visiting
   [Nixpkgs](https://github.com/NixOS/nixpkgs) and clicking the "Fork" button.

2. Clone your fork locally and sync with upstream:

```bash
git clone https://github.com/<your-username>/nixpkgs.git
cd nixpkgs
git remote add upstream https://github.com/NixOS/nixpkgs.git
git fetch upstream
git checkout master
git merge upstream/master
```

### nix-hour source

```bash
git clone https://github.com/tweag/nix-hour

# This is not necessary, lfs files are just youtube video thumbnails
nix-shell -p git-lfs --run "git lfs install --local; git lfs pull; git lfs checkout"
```

The playlist on
[youtube](https://www.youtube.com/playlist?list=PLyzwHTVJlRc8yjlx4VR4LU5A5O44og9in)

### Current Progress

Below are the transcripts completed or in progress:

| no. | link                                                                                   | status   | transcriber                                                                          |
| --- | -------------------------------------------------------------------------------------- | -------- | ------------------------------------------------------------------------------------ |
| 0   | [Informal introduction to Nix language, derivations and nixpkgs](episodes/0/0.md)      | &#x2705; | [Domagoj Mišković][c1]                                                               |
| 1   |                                                                                        | WIP      | [Domagoj Mišković][c1]                                                               |
| 2   | Overriding derivations, fixed-output derivations, sharing closures                     | WIP      | [Domagoj Mišković][c1]                                                               |
| 3   | Flake updating, nix edit and some corners of the nix language                          | WIP      | [Domagoj Mišković][c1]                                                               |
| 4   | [Comparing flakes to traditional nix](episodes/4/4.md)                                 | &#x2705; | [Domagoj Mišković][c1]                                                               |
| 5   | [Overriding a rust source, derivation internally, closure inspection](episodes/5/5.md) | &#x2705; | [Domagoj Mišković][c1]                                                               |
| 52  | [The Nix Hour #52](episodes/52/52.md)                                                  | &#x2705; | [Phani Rithvij][c2] - https://github.com/allrealmsoflife/nix-hour-transcripts/pull/3 |
| 67  | [Language Tooling](episodes/67/67.md)                                                  | &#x2705; | [Phani Rithvij][c2] - https://github.com/allrealmsoflife/nix-hour-transcripts/pull/4 |
| 69  | [lookup path syntax](episodes/69/69.md)                                                | WIP      | [Phani Rithvij][c2]                                                                  |
| 75  | [nix tooling](episodes/75/75.md)                                                       | &#x2705; | [Phani Rithvij][c2] - https://github.com/allrealmsoflife/nix-hour-transcripts/pull/6 |
| 77  | [language tooling (again)](episodes/77/77.md)                                          | &#x2705; | [Phani Rithvij][c2] - https://github.com/allrealmsoflife/nix-hour-transcripts/pull/7 |

### Contributing

If you are interested be warned, it will take a long time for each episode.

> [!IMPORTANT]
>
> Before contributing make sure to open an issue in the repo with title clearly
> specifying what issues you would like to work on.
>
> eg. issues 52, 67
>
> This allows people to not waste time doing duplicate work.

Also completed issues can have mistakes, or can use some different wording or
other improvements

please do send prs correcting them, if you find some!

### TODO

See [TODO.md](./TODO.md)

---

_Transcriptions by Domagoj Mišković and contributors._

[c1]: https://github.com/allrealmsoflife
[c2]: https://github.com/phanirithvij
