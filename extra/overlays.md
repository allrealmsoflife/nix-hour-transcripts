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

