# NixCon 2017: Nixpkgs Overlays - A place for all excluded packages

*Nicolas B. Perron*

Announcement: Our next speaker is Nicolas whom you probably know from the module system, the one thing I definetly
know about Nicolas is if something annoys him strong enough he'll do something like implement
module system. He works day to day at Mozilla, recently working on a new project called holy JIT,
which is a just-in-time compiler for JavaScript written in Rust.

Nicolas: So one thing I was looking for this presentation, I was trying something with
overlays and I figure out that we already have overlays, we just need a bit of transparency
to see them, and adding transparency to the logo you can see that we already have overlays and
we also had a fixed point.. of printing it, and if you recall some old t-shirts its not always
easy to understand fixed point, especially if you are a printer.. so the goal of this presentation
is to make sure you understand overlays and make sure you understand them correctly:

### This Presentation

* Why adding overlays?
* How to use them?
* How do they work?
* What can we do with them?

I gave to the nix community a gift for christmas, I give you overlays, and almost a year after
I come back to and want to look for things where people use overlays and realize, oh crap, 
people have used it, but there are things that are in the documentation which might be not
well explained, and I of this presentation will verify that so I will go and describe what
they are, how they work and what you can do with them.

So NixOS is awesome. We have the module system which gives us the ability to be declarative and
this module system also gives us the ability to compose different modules from all over the place
and make that into one set, except that,

### Nixpkgs before Overlays

1. ~~Declarative~~
2. ~~Composable~~


Okay that's nice but not everything is awesome, sorry for the lego movie but nix packages is like
you have these functions, and they return something, it's not that much declarative and it was not
composable before overlays and we will see how overlays make that composable so before going into
overlays:

### Before Overlays

* packageOverride
* overridePackages
* `import <nixpkgs> {} // { ... }

All replaced by Overlays

Let's look at how we used to extend nix packages before that. Before that we had these three functions
and these three functions were like okay, there is `packageOverride` that everybody almost everybody use
in their `config.nix` and it's nice, you can extend things, you can change the sources, okay great, but
you cannot share that easily because you have some (?) stuff and it's like there is this one file and
if you want to share you have to share portion of it and we're back to the problems that I had before 
making the NixOS modules which were, okay, how do we avoid getting into forums when we want to have a
solution? And how can I just share a file and just pull that down?

Then we have this other function which I'm glad I removed it, which is `overridePackage` and if you
don't know about it don't go dig, don't dig further, it's like awful and it's no longer there, so do
not even try to use it, it won't work.

Then there is this other side which is like okay, I'm from an external file in another project and I
want to import nixpkgs and extend these version that I imported and add these few packages inside it.
That works well until the point when you want to add multiple and then you realize okay, then I want
to import something else that needs packages which already extends it and it's becoming hell, so all of
these methods are replaced by overlays and the thing no longer exists, great, soon, maybe I hope to
break all of you if you are still using that (smiles)

### Overlays are Composable

1. Same syntax for all overlays
2. Replace/Add packages without Nixpkgs modifications.
3. List overlays under `~/.config/nixpkgs/overlays`.

So composable, we can compose overlays in a way where we have the same size for all of them, we have a
simple syntax which is made to copy and paste and that's basically all and then you can do all the things
that you could do with the overlays before which is like you can add packages, you can replace some of
them by tuning them, you can change the recipe, and you can remove some of them which for example say,
oh `xlib = null;`, yep, no more xlib which will break tons which will break tons of sets ..(5.04) I guess.

And the way overlay works is that you have one directory or an option in NixOS, or a single file which (5.15)
recently. This one directory let's you add files at the coarse-grained granularity and you add files into this
directory and this will be overlays which will be used one after the other, and will be combined into nixpkgs.
So I will go through multiple examples and after a while I will ask you solve some of them so I will go with
the easy one:

```nix
self: super:
{
}
```

So this is the simplest overlays that you can make, it takes two arguments, one is self the other is super and
you give it an empty set and you extend nixpkgs with nothing. Great!

### Nixpkgs Internal

```nix
stdenvAdapters = self: super: ...;
trivialBuilders = self: super: ...;
stdenvBootstappingAndPlatforms = self: super: ...;
platformCompat = self: super: ...;
splice = self: super: ...;
allPackages = self: super: ...;
stdenvOverrides = self: super: ...;
configOverrides = self: super: ...;
```

So overlays are not just some things that are made up, it's actually the internal of nixpkgs.
Nixpkgs is using the overlay system expect that it's doing a mess which is currently highlighted
in this slide and it's using the overlay system to basically stage the different levels of nixpkgs
that we currently have.

So this basically, the things that I did was like, I was trying to do the grafting work again, yeah
if you recall this, the presentation from two years ago, and I realize that huh, there is this function
`overridePackages` which gives me tons of trouble, and I can replace it and just add overlays at the end
and that's basically all it is. Overlays are just adding something to the internal of nixpkgs and you
get to extend all of nixpkgs. And I can remove one of the side features that was there and was awful in
terms of performance and hey, no longer here so now we have overlays, yes!

### Examples

```nix
self: super:

{
  google-chrome = super.google-chrome.override {
    commandLineArgs =
      ''--proxy-server="https=127.0.0.1:3128;http=127.0.0.1:3128"'';
  };
}
```

It's resourceful internet, you find tons of things, and sometimes you find good examples and this one is
just adding a command line, a command line argument to a google chrome which is saying hey, use this proxy
to redirect all my network connections through this proxy which is really nice, especially if you can set it
on the command line and get all the nice feature protections that you get with a proxy, so okay, that's a good
way to get an overlay, and you need to recompile once more so why we are discussing about recompilation?

```nix
self: super:
{
  nix = super.nix.override {
    storeDir = "${<nix-dir>}/store";
    stateDir = "${<nix-dir>}/var";
  };
}
```

https://yrh.dev/blog/nix-in-custom-location/

Some other people wanted to get Nix but in a different directory and basically this is interesting if you are
stuck in your home and you have no root access for adding the nix directory at the top level so this is a simplified
example but has the same ideas which is that you want to configure nix to have it's nix store at a different
directory and that's an interesting one as well.

So then you have other example where you just have ordinary packages as we do in nixpkgs and just one of the tools
that we use within mozilla for discussing

### 2. Arguments

* **self**: Fix-point result.
* **super**: Result of the composition before this file

We call this `self` and `super` and it's not clear when you see them. So `self` is basically, in nix packages you
have a fixed-point, you have all the stages and you have a fixed-point which basically takes the output and give
it back at the input of all of them, and `super` is you have all of these stages and it's the previous one. You take
the next stage, it's the previous one, and so on, so that's out, that's basically all it is.

But that doesn't tell you how to use them. `self` is made to basically find all the dependencies, so if you have a
package and you package depends on say, Bison or Firefox then you will use `self`.

### Self

* Used for derivation result.

You will say `self.sed`, `self.bison`, `self.firefox` and that's all. If you want to use `self` for anything else,
that's wrong, that's the only bullet point here, that's the bullet. `super` is basically all the rest, is if you have
functions called packages or library functions or write text or `runCommand`, if you have functions it comes from
`super`. If you want to override the recipe it comes from `super`. It comes from `super` for the following reason.
Let's say I have said I want to override something in sed? (10:16) or I want to after overriding something in sed?
I want to define it at sed? You get an infinite loop because you say I want a recipe of the thing that I just defined,
and that's why you have to look for recipes for making packages in the previous ones until you find one and that's why
also overlays are ordered as opposed to NixOS modules 10.43
