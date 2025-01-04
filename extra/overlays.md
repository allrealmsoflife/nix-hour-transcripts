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

So this is the simplest overlays that you can make, it takes two arguments, one is self the other is super.
