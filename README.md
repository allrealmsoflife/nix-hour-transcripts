# Nix Hour Transcripts

This repository contains transcripts of **Nix Hour**, a series of sessions by 
[Tweag](https://www.tweag.io/) presented by **Silvan Mosberger**. The sessions 
provide deep insights into the Nix and NixOS ecosystem.

The goal is to make the knowledge from these sessions more accessible and easier 
to reference for the community.

To have a more complete experience following along have the nixpkgs locally:

### Fork, Clone, and Sync Nixpkgs Locally

1. Fork the repository on GitHub by visiting [Nixpkgs](https://github.com/NixOS/nixpkgs) and clicking the "Fork" button.

2. Clone your fork locally and sync with upstream:

```bash
   git clone https://github.com/<your-username>/nixpkgs.git
   cd nixpkgs
   git remote add upstream https://github.com/NixOS/nixpkgs.git
   git fetch upstream
   git checkout master
   git merge upstream/master
```

### Current Progress

Below are the transcripts completed or in progress:

- [0: Informal introduction to Nix language, derivations and nixpkgs](episodes/0/0.md) &#x2705;
- 1: 
- 2: Overriding derivations, fixed-output derivations, sharing closures
- 3: Flake updating, nix edit and some corners of the nix language
- 4: Comparing flakes to traditional nix (Finished)
- 5: Overriding a rust source, derivation internally, closure inspection (Finished)
---

*Transcriptions by Domagoj Mišković.*
