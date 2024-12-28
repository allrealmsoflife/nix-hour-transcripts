Silvan: All right, so just repeating the question about, you might be able to get Nix into your company,
but you aren't sure about the whole flakes situation, and it being labeled as experimental stuff,
and just kind of some clarification about that, what the best practice would be and if it's a 
good idea to get into Nix now, does that sound about accurate?

Q: Yeah basically when I look at documentation there is two different approaches fundamentally,
and I don't know really if I can propose, "hey we can use that for our project, but it's experimental",
it just seems a little bit crazy to do that. 

Silvan: Yeah, yeah, so personally what I would go for is to hold off flakes just for the time being.
Maybe I can, do we have anything good to look at, mhm, maybe the, let me share my browser window here,
so flakes is in the process of, there is some effort to stabilize it, we can maybe go into, here
RFC's 127, no it's not this one, this one, RFC number 136. This is an RFC that lays out kind of first
steps towards stabilizing flakes and so that's currently going on. Just recently the Nix team has been
founded, there is weekly events I think on discourse, they are publishing meeting notes, the Nix team,
Nix team creation yeah, https://discourse.nixos.org/t/nix-team-creation/22228.

So the Nix team has been created recently to kind of distribute the Nix development process a bit, so
the Nix repositories is where all of the flake magic currently is and currently marked as experimental,
and up to recently Eelco Dolstra, the inventor of, or creator of Nix was pretty much the main person to
do this development, to do the merges and pull request reviews and he kind of gave the direction of Nix.
And that's also kind of how flakes came to be, but recently because this was deemed not super stable,
or not super sustainable, the Nix team has been created to kind of have more than one person do this flow
and make sure Nix can progress and there's a good vision and stuff like that.

Also recently, this kind of all happened at the same I'd say, at NixCon, there was a lot of talk about, uh
well a lot of people met and a lot of things have been discussed, and I don't think a lot of flake discussions
have been had, it most mostly kind of an avoided topic, it's definetly the elephant in the room currently,
in the nix community, but what should we do about that. So I'm optimistic that in let's say in the next
year, either, yeah in the next year I'd say flakes can get stabilized. How it's gonna get stabilized, I'm
not sure, it might stay the way it is right now which I think it's problematic for some reasons, or 
it might change in backwards incompatible ways, and because we don't know I would not recommend adopting
flakes at the moment. Only, not like on a large scale at least. If you want to try out flakes because it is
an experimental feature that might be cool to try out but I wouldn't recommend building it into the stable
workflow of everyday developers. Just, well, of course I am a bit biased, flakes does provide a lot of benefit
that is a bit harder to get in standard nix or traditional nix, say, but there are a lot of things, there are,
flakes does provide a lot of utility but you can also get some of that in standard nix if you adopt some
conventions and stuff. So I think I'll go now into some, into showing a bit about how I think flakes, a lot
of features of flakes can be gotten regardless without flakes, so you can still use stable nix without depending
on flakes. Does that sound good or are there any questions about things I've just said?

Q: No, that be very helpful yeah.

Silvan: All right, let me share this then

```bash
cd nix-hour
mkdir flakes
cd flakes
vim flake.nix
```
One of the main things flakes gets you is the pure evaluation. So let's say we have a `flake.nix` file, we
have a simple, let's say `outputs` equal `self`, then let's also take `nixpkgs`, we just then, let's do,
let's say `foo` equals, say `import` nixpkgs, and then let's go, well let's not do anything for now, let's just
do this and see what happens.

```nix
{

  outputs = { self, nixpkgs }: {
    foo = import nixpkgs {};
  };
}
````
So let's say `myHello`, let's call it like that, `myHello = (import nixpkgs {}).hello;`, so let's say you have
a very simple flake here, you import nix packages and now we need to call `:!nix flake lock` I believe, oh actually,
it totally crashed actually, did it? No, it just was very slow. Let's do `git init` here because flakes relies on
git repositories, let's add all the files here, `gaa`, and now we should be able to `nix flake show`, all right,
so it did create a lock file automatically locking the nix packages I believe (checks the .lock file). Now, let's
try the `nix build .#myHello`, and so now we get this error (`error: attribute 'currentSystem' missing`), and 
this is going to be when you use flake you see a lot of these errors unless you, well, not a lot, it's fairly easy
to get around it but this is the pure evaluation of flakes that if you use flakes, nix enforces a pure evaluation
of your nix code. This means there is no access to `builtins.currentSystem` which we see here:

```nix
nix-repl> builtins.currentSystems
"x86_64-linux"
```
Current system is different on whatever system you evaluated on. If I were on darwin it would be a different
string here so this is why it's impure, the same expression leads to different results on different systems
and environments. Similarly there is `builtins.getEnv "USER"` which allows you to get the environment variables
in nix which is of course impure because it depends on the environment and there's a bunch of others like this.

And flakes enables pure evaluation mode by default, uh yeah, so this is impossible, there is a way to get around
this but this is discouraged of course, there is `--impure`, this then works, `nix build .#myHello --impure`.
But yeah, to fix it in flakes you have to explicitly pass the system in this case, system equals then let's say,
in here, then we can't use `builtins.currentSystem` because of course that's impure, that's also the default and so
if I pass the system here it does work, oh let's do impure and it also works:

```nix
{

  outputs = { self, nixpkgs }: {
    myHello = (import nixpkgs {
      system = "x86_64-linux";
    }).hello;
  };

}
````

```bash
nix build .#myHello --impure
warning: ... is dirty

nix build .#myHello 
warning: ... is dirty
```
Now let's just check Hello:

```bash
> result/bin/hello
Hello, world!
```

So ok, now let's look at how this would look at in a `default.nix`, so let's try to do the very same thing, so we have
the locked nix packages in here (in lock file), we have the and we build the myHello package which is just the hello
from nixpkgs. To do this, oh let's actually do first, make this agnostic over the system because this a bit, usually we
have an output schema which is like this, and now flake utils would probably be good, let's just put up the output schema
right here and do it like this, so this is not the best practice in flakes but, let's do like this:

```nix
{

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.myHello = (import nixpkgs {system = "x86_64-linux"; }).hello;
    packages.x86_64-darwin.myHello = (import nixpkgs {system = "x86_64-darwin"; }).hello;
  };
  
}
```
So you can also use flake-utils for this, that is a third party community project that does this for all the systems,
so simplifies the setup for that, typically recommended yeah, but let's now do the same with standard nix, `vim default.nix`,
traditional nix, so first of all we might do, so we can do it very easily like this, `(import <nixpkgs>{}).hello` and let's also 
do `myHello`, this is an attribute set:

```nix
{
  myHello = (import <nixpkgs> {}).hello;
}
```

OK, this does work, now let me evaluate that, `:!nix-build -A myHello` and that works. And so this, but this is impure,
we also want the same purity of standard flakes, here we have a couple impurities, we have the nix packages from this,
`<nixpkgs>`, if we evaluate this in a nix repl:

```nix
> nix repl
nix-repl> <nixpkgs>
/nix/var/nix/profiles/per-user/root/channels/nixos
```

We can see this points to some channel, and this is different then this path for every user and this path changes when I
update the channels and stuff, and so this is an impurity, we want to get rid of this. The way we can do this is by
simply saying, let's add a `let in`, let's say nixpkgs is equal to, now we can say `fetchTarball {};`, so `fetchTarball`
is a builtin function that can fetch a tarball, in this case we can say we fetch from github.com, NixOS, nixpkgs,
then github provides archives, archives of the repositories at specific commits, we just need the revision here,
and the revision let's get it from the lock file, let's go into `flake.lock`, let's copy the same one it uses here,
`d01cb...tar.gz";`, then we provide the hash, as you can already see this is already a bit annoying to do here, in 
flakes we don't have to do any of that but we can get rid of this (`<nixpkgs>`) impurity now, so now let's evaluate this again:

```nix
let
  nixpkgs = fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/d01cb...tar.gz";
    sha256 = "000...0";
  };
in {
  myHello = (import nixpkgs {}).hello;
}
```

Let's do a `nix-build -A myHello` again, and it's gonna take a bit longer, it's going to fetch this tarball, it's gonna
try to verify that the hash is correct, and I'm kind of surprised that it doesn't reuse the result from flakes but I,
maybe that's a different cache, ah so we get the hash back (`error mismatch in file..`), let's insert this here and now 
we can build it again, and this should be the exact same result as flakes, let's try this, this now points to, (compares 
both `result -> nix/store/jidy..hello-2.12.1`.

All right, we also have another impurity, the same we had in flakes earlier, that's the system and there is actually some
more. So nix packages has kind of three main arguments that most people care about, that's `overlays`, `config`, and `system`,
the one we saw earlier, and all of these have defaults that are impure, `overlays` by default reads from `~/.config/nixpkgs/overlays`
I believe, `config` by default reads from `~/.config/nixpkgs/config.nix` and `system` by default is `builtins.currentSystem`,
so these are pretty bad here, these are like, like I've seen users have problems because they didn't realize the defaults were
pulled in, and they had some `overlays` in `config.nix` that was custom to their setup, and therefore breaking some 
development workflow for a project. Same in flakes can't happen because it enforces this.

```nix
myHello = (import nixpkgs {
  # overlays, by default ~/.config/nixpkgs/overlays
  # config, by default ~/.config/nixpkgs/config.nix
  # system, by default builtins.currentSystem
```

In non-flakes we can also do this just by overriding these with empty values, you can say overlays is empty, config is empty,
overlays is a list, so we can pass an empty list, `overlays = [];`, config is I guess attribute sets so we pass an empty attribute
set, `config = {};`, and system, now we don't want to do this here, `"x86_64-linux"`, because, well the `builtins.currentSystem`
impurity is OK, it's typically what users expect and so we don't really want to make that more annoying to do, so we want to
leave this here, but we also want this expression to be, like we want to be able to change the system even if we are on a 
different one, so what typically is done is that we have a system argument to the top level function which defaults to 
`builtins.currentSystem and then in the result here or in the nix packages import we just use inherit system or system equals 
system and so this expression is a pure one but it has this impure default up here:

```nix
{ system ? builtins.currentSystem }:
let
  nixpkgs = fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/d01cb...tar.gz";
    sha256 = "000...0";
  };
in {
  myHello = (import nixpkgs
    # overlays, by default ~/.config/nixpkgs/overlays
    # config, by default ~/.config/nixpkgs/config.nix
    # system, by default builtins.currentSystem
    overlays = [];
    config = {};
    inherit system;
  }).hello;
}
```

But we can override this one, and the way we can override it is, well if we import this file from somewhere else,
say `import ./default.nix { system = "x86_64-darwin"; }`, or the CLI we can do let's try this `nix-build -A myHello`
so this still works and we can pass our string here as even with autocompletion, will pass another system,
`nix-build -A myHello --argstr system x86_64-darwin`, now this actually might, yeah this works because I have a,
cache.nixos.org has it cached, we can also try to build it by adding a check, `nix-build -A myHello --argstr system x86_64-darwin --check`
this only works if you already have the path in your store and why it's called check, so it builds it again and then
checks whether it results in the same path, the same binary. This will fail because I'm not on a darwin system, (building),
any second.. yep (fails), but yeah if you had remote builders this could also work.

Yeah, so this, as far as I know, does not have any impurities, and so this doesn't work super well at the moment,
I hope it improves a bit. You can also use pure evaluation mode in the old nix commands. So there is two flags,
one of them is `--pure` and one of them is `--pure-eval`, the `--pure-eval` one is for pure evaluation mode, the 
`--pure` is for nix shell, and this is, it is a bit misleading, `> nix-shell --pure`, it just doesn't propagate
your environment into the nix shell from outside but yeah in this case we want to use `--pure-eval`, 
`nix-build -A myHello --pure-eval`, and we get the problem here:

```nix
> nix-build -A myHello --pure-eval
error: access to absolute path '/home/tweagsy..default.nix' is forbidden in pure eval mode (use '--impure' to override)
```
Pure evaluation is so strict that you cannot even access the `default.nix` file which is evaluated by default so what
can we do? Can we pass the `default.nix` here, `nix-build -A myHello --pure-eval default.nix`, no, that also doesn't
work, the only way to make pure eval work is by giving an expression, so `--expr` short for expression and then here
now we can evaluate things in pure evaluation mode `'1 + 1'`, let's also remove the `-A` here, let's just do
`nix-instantiate --eval --pure-eval --expr '1 + 1'` (outputs 2). So this works, this in here is now pure evaluation,
so we can try to access `builtins.currentSystems` and it doesn't work, `nix-instantiate --eval --pure-eval --expr 'builtins.currentSystem'`,
the attribute doesn't exist, that's the same behaviour as in flakes, so here the only way to actually get access to 
any code and to import nix is by using builtin fetchers, and so what we can do here is we can use `builtins.fetchGit`, or
doesn't need the prefix, we can say `url` equals now dot slash dot I believe that should work, if we just try this:

```nix
nix-instantiate --eval --pure-eval --expr 'fetchGit { url = ./.; }'
error: in pure evaluation mode, 'fetchTree' requires locked input, at (string):1:1
```

It says, requires a locked input, so we need to provide a revision so now, the problem, we haven't commited our code yet, so
let's try this:

```bash
gst
gaa
rm result
git reset
gaa
gst
```

Let's commit these files and let's try this again:

```bash
nix-instantiate --eval --pure-eval --expr 'fetchGit { url = ./.; }'
git log
commit 6bb6.. (HEAD -> main) 
```

(Copies the commit hash) Now let's try this again:

```nix
nix-instantiate --eval --pure-eval --expr 'fetchGit { url = ./.; rev = "6bb6.."; }'

```

And so yeah, this works now, we have a something representing our source, we have an outpath which is where source
actually lives, and by the way outpath is, that's really how you can evaluate derivations to the path, to path, like
we can say import, `nix-repl> :l <nixpkgs>` `hello.outPath`, hello has an outpath but if you just interpolate using
antiquotation, `nix-repl> "${hello}"`, that's what gets returned, similarly we can also say `attrs = { outPath = "foo"; }`,
and now we can do `"${attrs}"` and it results in `foo`.

```nix
nix-repl> :l <nixpkgs>
Added 16766 variables.

nix-repl> hello.outPath
"/nix/store/i9p5..-hello-2.12"

nix-repl> "${hello}"
"/nix/store/i9p5..-hello-2.12"

nix-repl> attrs = { outPath = "foo"; }

nix-repl> "${attrs}"
"foo"
```

Kind of an internal implementation detail for how derivations get their, get interpolated to strings. Anyways that aside, we
now have a source here, we can now import this, import this path:

```nix
> nix-instantiate --eval --pure-eval --expr 'import (fetchGit { url = ./.; rev = "6bb.."; })'
<LAMBDA>
```
It get's converted to the outpath for the import expression, so that works with the import. Now we get the lambda.
And that's the `default.nix` file here, `cat default.nix`, that's a lambda at the top, (`{ system ? builtins.currentSystem }:`).
Let's call it with an empty set but that then shouldn't work:

```nix
> nix-instantiate --eval --pure-eval --expr 'import (fetchGit { url = ./.; rev = "6bb.."; }) {}'
{ myHello = <CODE>; }
```
Because `currentSystem` isn't available, let's try `myHello`:

```nix
> nix-instantiate --eval --pure-eval --expr '(import (fetchGit { url = ./.; rev = "6bb.."; }) {}).myHello'
error: attribute 'currentSystem' missing..
```
Yeah, that works, so we have this here:

```nix
> nix-instantiate --eval --pure-eval --expr '(import (fetchGit { url = ./.; rev = "6bb.."; }) { system = "x86_64-linux"; }).myHello'
```

All right, and that works, let me change this to a nix build, ok it works:

```nix
> nix-build --pure-eval --expr '(import (fetchGit { url = ./.; rev = "6bb.."; }) { system = "x86_64-linux"; }).myHello'
/nix/store/jiddy..-hello-2.12.1
```

But as you can see, this is quite annoying to do, and now also every time I make a change I have to comit it again so we get a new 
revision, I need to interpolate the string here somehow to get the revision into the string, we can use something like
`--argstr`, that just doesn't work. You can, the thing nix should do that I'm going to provide a simple wrapper around something
like this, a pattern where you commited, provide the hash here just to make pure evaluation work mode work nicely, but this is how
it works right now, and in flakes it's obviously much easier and it just does by default. Are there any questions about this?

No? All right, I'll continue on then. Something else here, so in this case, well I guess in flakes, let's say we want to
build this flake with a different nix packages, what we can do here is, we can say `--overide-input` and currently nix packages
is locked to some, to this revision that we can also change this, let's say we wanna build so `github:NixOS/nixpkgs`and then I think
let's build `nixos-21.05`, sure.

```nix
> nix build .#myHello --override-input nixpkgs github:NixOS/nixpkgs/nixos-21.05
[0.0 MiB DL] downloading ...
```

So it fetches it, kind of weird that there is zero megabytes here, all right, fetches it, updates it, and builds hello, and yeah,
changed her and now this would be another hello version. You can check this,

```bash
> result/bin/hello
Hello, world!

> result/bin/hello --version
hello (GNU Hello) 2.10
```

This is fairly easy, but in our `default.nix`we can't currently do that, we have the nix packages hardcoded here in a 
`let in` statement, so a common way to get this to work is to provide an additional argument here which is `pkgs`, mhm, 
`nixpkgs ?`, we can also do both so we can say nixpkgs which defaults to this tarball, we can also use another one,
and then we can also say `pkgs`, sometimes people might have packages, like imported packages already and they might
want to provide this so we can put this into here so let's move this entire right into this argument, interleave this bit
here, `myHello` is now `myHello = pkgs.hello;`:

```nix
{ system ? builtins.currentSystem,
  nixpkgs ? fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/d01cb..tar.gz";
    sha256 = "0gff..";
  },
  pkgs ? import nixpkgs {
    overlays = [];
    config = [];
    inherit system;
  },
}: {
  myHello = pkgs.hello;
}
```

Alexander Sosedkin: ..refer to attributes like that?

Silvan: How do you mean? The hello or?

Alexander Sosedkin: I mean that refering to nix packages from the, yeah, from here

Silvan: I'm not sure, oh, you mean how this expression here (`pkgs ? import nixpkgs..`) refers to, like uses this
`nixpkgs ? fetch..` as dependency really. Yeah, that's possible, the function arguments here are just like a recursive,
just like a let in statement or like a recursive attribute set definition. So all of the definitions here are available
in the others and themselves, you could even do like `pkgs = pkgs;` here. Doesn't make a lot of sense there.

Alexander Sosedkin: Interesting

Silvan: Yeah

Ok now with this we can do the same thing as with flakes, we can do nix build, let's not do pure evaluation mode now,
so `nix-build -A myHello` works but we can also say `nix-build -A myHello --arg` so arg provides a nix value as an
argument, `--argstr` turns a given string into a nix string directly, and in this case we want to use `--arg` so let's
se if we want to override nixpkgs so in here we could say `--arg nixpkgs 'fetchTarball`, let's see what did we use earlier,
`nix-build -A myHello --arg nixpkgs 'fetchTarball { url = "https://github.com/NixOS/nixpkgs/archive/nixos-21.05.tar.gz"; }' `
And so in this case we can leave out the sha and also this url reference can change over time, just because I'm not gonna
bother making this pure because it's only temporary override. So this works. You could also add some additional convenience 
things where you can say like `--arg channel nixos-21.05`, this would then be impure but you can also integrate it with
some other purity aspects.

So nix, the traditional nix here is impure by default, well, a lot of things are impure by default and you need to fix those,
but you can make them pure in like all cases. So let's take another look at the flake again. So let's say we want to update the 
pinned nix packages version in flakes. The way we can do this is `nix flake update`, all right, so I guess nothing changed.
So let's say, we're going to `vim flake.nix`, all right, we haven't declared the nix packages in here, it defaults to the
master version of NixOS nix packages:

```nix
{

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.myHello = (import nixpkgs {system = "x86_64-linux"; }).hello;
    packages.x86_64-darwin.myHello = (import nixpkgs {system = "x86_64-darwin"; }).hello;
  };
  
}
```

But let's say we define it explicitly here with `inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";` let's say 
we pin it to 21.05 again, so `nix flake update`. All right that worked. And so yeah that's good, this works without filaments.
So we can build our hello again, we get the old hello version here. If we want to do the same in our `default.nix` we would
have to go in here or go on GitHub, find out this revision, and in this case I'm gonna cheat because I'm going to use the 
`flake.lock` here, so let me just pick the revision from here, turn here, change this (in `default.nix` Silvan changes
the revision number in the `url = "https..` line at the top), now we have to update this hash (the `sha256`) to be, change `0` to `1`
in the beginning, now we have to try building it again or you can also use a prefetcher to determine the hash beforehand,
that would be useful in CI, so it's gonna fetch it again (`nix-build -A myHello`), we get the new hash back and we can insert
(in `sha256`) again, all right and now it works again (`nix-build -A myHello`), but yeah, this is obviously quite painful.
There is a kind of established way to do this more streamlined, that is using `niv`, `niv` is a third party community
project to essentially do this source updating for you and so install it, I'm just gonna use nix shell here, 
`nix-shell -p niv`, then we can run `niv init`, this creates a bunch of files, and so let's look at these files, 
we have a nix directory, `cd nix`, which it creates for us, all the files are in there, has a `vim sources.json`, that's
the file, essentially the lock file it uses to track services, and so here we can see, oh it also detected the, this
locks in the same way as flake lock does and we have the `sources.nix`, this is just a big file managed by niv to do the
import correctly, so it has the builtin fetchers, packages fetchers, a whole bunch of things. So the way to use it is we 
can go into our `vim default.nix` here and instead of using this here:

```nix
nixpkgs ? fetchTarball {
  url = "https://github.com/NixOS/nixpkgs/archive/022..tar.gz";
  sha256 = "12q..4n";
},
```

We can do, let's say, add another argument here, `sources ?`, so niv, this is the way it is used:

```nix
{ system ? builtins.currentSystem,
  sources ? import nix/sources.nix,
  nixpkgs ?
  pkgs ? ..
```

So this imports the `sources.nix` file which also then imports all the pinned sources from the `sources.json` file so 
in here we can use `nixpkgs ? sources.nixpkgs,` instead, yeah let's try this out, so `sources.nixpkgs`, this is the source
name here, so any of them can be used. Let's try it out: `nix-build -A myHello`. It works, it seems like it used a 
different version here, but niv is fairly cool, there's the cli, there's a lot of things to change. So we can say here,
`nix show` which shows the source, we can modify without updating, update dependencies, we can add dependencies, we 
can say `niv add`, let's say `niv add flake-compat` (error), or `niv add NixOS/flake-compat` (error), ok that's either
not a thing or, I don't know, my personal repository here, `infinisil/system`, so by default it uses the github syntax,
the github owner, and the github repository, so it's fairly easy to add most dependencies, and now we also have this
tracked in the `cat nix/sources.json` file, so let me remove this again, `niv drop system`, but we can also update,
so let's say we update nixpkgs just to use, which branch, we want to use the `nixos-21.05` branch,
`niv update nixpkgs --branch=nixos-21.05`, and build hello again, `nix-build -A myHello`, oh I think it might fetch
it twice here, anyways I think this is the same one as we have in flake now, yeah (compares the hash). So yeah niv 
can be used, niv only relies on stable nix features, it doesn't use flakes so this can be used to do automatic
source updates. I do need to point out though that `vim flake.nix`, they do the source tracking recursively, so what
would be a good example..

Yuriy Taraday: Home manager?

Silvan: Home-manager, yeah that's a good one. Let me do home-manager here:

```nix
{

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
  inputs.home-manager.url = "github:nix-community/home-manager";

  outputs = { self, nixpkgs, ... }: {
    # flake-utils
    packages.x86_64-linux.myHello = (import nixpkgs { system = "x86_64-linux"; }).hello;
    packages.x86_64-darwin.myHello = (import nixpkgs { system = "x86_64-darwin"; }).hello;
  };

}
```

Oh yeah, the `...` here. Now let's do a `nix flake update`, and so as you can see here it added not just home-manager but
also the flakes it depends on individually (added input `home-manager`, `home-manager/nixpkgs`, `home-manager/utils`), so
in the `vim flake.lock` file we now have home-manager, we have one nixpkgs, another nixpkgs, one for home-manager, one for nixpkgs, 
and flake-utils as well. And so this is convenient, flakes does provide that, niv doesn't have that, so let's say we add
`niv add nix-community/home-manager` to niv, and now, well yeah, that's also a thing with flakes, you can just do,
`nix flake show github:nix-community/home-manager`, so flake does have this standard structure that traditionally
nix never had, so in here we can see ok, this flake provides a default package, it provides NixOS module, it provides
packages for different architectures, templates as well and so this is nice and convenient. If we want to do the same
for traditional nix we need to really read the description of the project and figure out what convention it uses, so for
flakes let's say let's do like:

```nix
> nix repl
nix-repl> s = import ./nix/sources.nix
s.home-manager
```

Let me just get the `outPath` here, let's go in here, OK, home-manager provides a flake here but we don't want to rely
on this right now, so it's the `vim default.nix`, and now you can go in here, and you can say, it has this structure we
also had before, it doesn't allow us to override the system but we can just override the entire packages here, and so
let's say, let's say we want to build the docs:

```nix
{ pkgs ? import <nixpkgs> { } }:

rec {
  docs = with import ./docs { inherit pkgs; }; {
    html = manual.html;
    manPages = manPages;
    json = options.json;
    jsonModuleMaintainers = jsonModuleMaintainers; # Unstable, mainly for CI
  };

  home-manager = pkgs.callPackage ./home-manager { path = toString ./.; };

  install = 
    pkgs.callPackage ./home-manager/install.nix { inherit home-manager; };

  nixos = import ./nixos;

  path = ./.;
}
```

And so to do this, let's go back to `cd nix-hour/flakes` here, `vim default.nix`:

```nix
{ system ? builtins.currentSystem,
  sources ? import nix/sources.nix,
  nixpkgs ? sources.nixpkgs,
  pkgs ? import nixpkgs {
    overlays = [];
    config = [];
    inherit system;
  },
}: {
  myHello = pkgs.hello;
}
```

So we have home-manager in our sources, let's now use, `homeManagerDocs = sources.home-manager`, now we need to import
this, `homeManagerDocs = import sources.home-manager`, because this should work, home-manager has a file path which
is used by default, `homeManagerDocs = import sources.home-manager.outPath` and nix uses the `default.nix` file by 
default. It is however a function so we need to provide an argument here (deletes `outPath` and writes `{ }`) and here
we see that it takes a `pkgs = ` argument, and here we can provide the packages we had in our environment here,
`pkgs = pkgs;`:

```nix
{ system ? builtins.currentSystem,
  sources ? import nix/sources.nix,
  nixpkgs ? sources.nixpkgs,
  pkgs ? import nixpkgs {
    overlays = [];
    config = [];
    inherit system;
  },
}: {
  homeManagerDocs = import sources.home-manager {
    pkgs = pkgs;
  };

  myHello = pkgs.hello;
}
```

All right, now this is just the main attribute set, we want to get the docs, this is `.doc`, well let's try it out:

```nix
...
  homeManagerDocs = (import sources.home-manager {
    pkgs = pkgs;
  }).doc;
```

So let's try `nix-build -A homeManagerDocs` (error), that wasn't it, (changes `.docs` to `.manual`), nope, it was, oh
`.docs`, and now we build that, and it fails (`error! anonymous function at..`), oh OK, so this is interesting now,
I think what happened here is that the packages version we have pinned here which is actually fairly old one, use the
nixos 21.05, year ago, or one and a half, and so I don't think home-manager works with that older version in the 
flake world. Let's go to `vim flake.nix` and do the same, let's do like linux, let's do home-manager, so we seen 
earlier, (looks at `nix flake show github:nix-community/home-manager`)

```nix
---x86_64-linux
    |--docs-html: package 'html-manual'
```

Let's try that:

```nix
{

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
  inputs.home-manager.url = "github:nix-community/home-manager";

  outputs = { self, nixpkgs, ... }: {
    # flake-utils
    packages.x86_64-linux.myHello = (import nixpkgs { system = "x86_64-linux"; }).hello;
    packages.x86_64-darwin.myHello = (import nixpkgs { system = "x86_64-darwin"; }).hello;

    packages.x86_64-linux.homeManagerDocs = home-manager.packages.x86_64-linux.docs-html;
  };

}
```

Now I should be able to do `nix build .\#homeManagerDocs` and if we are lucky, actually now, it should just work,
yeah it worked, now we can look at the docs, but yes what happened here is that, so flake did track the recursive
dependencies of home-manager. Home manager itself has some pinned nix packages that it uses and that it knows that
my docs build with that nix packages and so it just used that version by default. While in flake you can override this
and like you can say I think, Yuri is it like this? Yuri: yeah yeah, inputs dot nixpkgs.

```nix
inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";
```

Let's try this. So there is this follows mechanism in flakes where you can say that `home-manager` is nixpkgs input, 
should use the nixpkgs we have pinned here. Let's try this, `nix build .\#homeManagerDocs`, and so yeah now we get the
same error as before so in this case we wouldn't want to do this but this would be the equivalent of what we did
in the traditional nix one, so what do we do here (now looks at the other nix traditional `default.nix` file), 
we can update the `sources ? import nix/sources.nix,` to be like up to date or use the latest one that home-manager uses
which we also have to figure out somehow. We could also use a separate nixpkgs, so we go into home-manager here and 
look at `flake.lock` and say oh it has a nixpkgs that comes from this revision, let's copy this and do some kind of hacky
`niv add NixOS/nixpkgs --rev`, can I provide arguments here? Oh yeah, we have the package already existing. I do think there
should be a way to rename it. (Yuri comments about the name arg)

```nix
> niv add NixOS/nixpkgs --rev 3ba..62 --name nixpkgs-home-manager`
Adding package nixpkgs-home-manager
```

Let's call it that. And using it, so instead of using `pkgs = pkgs;` we have here let's use `pkgs = sources.nixpkgs-home-manager;`
But now this is nixpkgs in the packages so we could import it `pkgs = import sources.nixpkgs-home-manager { };`. Now we 
could do the same here again, let's do it for purity. We could also probably set like nixpkgs argument, but let's
just duplicated it for now:

```nix
{ system ? builtins.currentSystem,
  sources ? import nix/sources.nix,
  nixpkgs ? sources.nixpkgs,
  pkgs ? import nixpkgs {
    overlays = [];
    config = [];
    inherit system;
  },
}: {
  homeManagerDocs = (import sources.home-manager {
    pkgs = import sources.nixpkgs-home-manager {
      overlays = [];
      config = [];
      inherit system;
  }).docs;

  myHello = pkgs.hello;
}
```

Let's try it again, `nix-build -A homeManagerDocs`, probably fetching nixpkgs right now, all right, that did work though, `t result/`,
so yeah, if you have I guess packages like home-manager which have their own dependencies which they want to have pinned for
themselves, flakes does really add some value over niv, but if you want to, if you are ok with that, if you don't do
many these recursive dependencies it might be ok to just do something like this in case you need it (shows `default.nix`
with `pkgs = import sources.nixpkgs-home-manager` but also this, it's kind of a two edged sword because in the flake world
a lot of projects do pin their own nix packages and this since has been termed as cat of a thousand nixpkgs instances.
Let's see, yeah, thousand instances of nixpkgs, there is a good blog post I'm gonna link it in the chat here for now by
Jonas or zimbatm, he talks about this a bit, about how it really turned out that a lot of people pin their nixpkgs and this
gets out of hand quickly because, so in this case we only have home-manager which has it's own pinned nixpkgs
but if we have some dependency that uses home-manager or some dependent that uses home-manager as its dependency and they don't,
it also has it's own nixpkgs then that, there's two nixpkgs in that already, now we had our own here as well, and this not 
only leads to a lot of disk usage because you have so many nix packages, it also leads to problems with kind of composing
things, because every nixpkgs has its own, potentially has it's own set of entire versions, version trees and apis and 
stuff like that, and so generally a lot of people try to use follows as much as possible. In this case we can't do this
because this version (`21.05`) is too old so we have to update it to a later version, let's try this, this might actually work,

```nix
{

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.home-manager.url = "github:nix-community/home-manager";
...
```

`nix build .\#homeManagerDocs`, yes, let's see, seems to work.. 

Yuri: btw, I said my real experience with this like, we have a project, I think it's in public in Cardano area of the internet
where we have like hundred nix packages, some of them are different, some of them are the same, it's usually really
slow and sometimes causes problems, yes. 

Silvan: Yeah, yeah, and right, you'll often see in alot of these follows in the flake world, so also recursive, so we might have
like let's say we have `someProject.inputs.home-manager` and trees like this, and this is a very manual process to add
this, yeah. So it's a two edged sword yeah. Yeah we have like seven more minutes. Do we have any questions about this or also
something else, I'm open to anything.

Nat (the first questioner): So actually I have a lot of questions, I guess I'll wait until next week to add any more, I 
don't want to pick up the whole time but when it comes to working with all the various whatever to nix operations
I know that there is you know dream2nix which is also experimental, I've used node2nix and a couple other ones, but it just
seems to me like I'm not sure is this even a good idea or what would you recommend for any kind of, let's just take a node
project as an example.

Silvan: Yeah, yeah, um so nix itself doesn't know how to build a lot of these frameworks from like all these languages. Someone
needs to implement them in nix, and someone needs to make nix build work. And nix packages can't do that in a lot of cases,
because of IFD restrictions, import from derivation restrictions, um there are some, like 2nix tools in nixpkgs though,
but they can't be used in nixpkgs itself anyways, so it's really kind of a who comes up with the best way to build projects
in this language within Nix and there is often multiple ways of doing that so specifically in the javascript world
you have your node2nix, I think there is two version of node2nix, yarn2nix, there's just recently actually a build npm package
has been merged in nixpkgs and also just like yesterday some what was it called jays2nix or something like that has been
announced, and I also know someone else is working on something too, it's really quite, there is a lot of different
ways of doing it and there's no like clear general recommendation I can give, well, I guess I can, and it is to look
at these projects individually, see whether they're actively maintained, see how well they work, whether they have a lot of
issues, try them out, see do they have test suites, are they documented, did they improve on past tools, things like that,

Yuri: and also, I'm sorry, I would also mention that there is a different approach like if you are able to influence the
software itself that you're packaging then you can actually introduce for example for in Javascript world
there is this yarn plugin nixify which actually generate nix expression that you can then use to package the software
that would basically be updated automatically when you use yarn, so essentially it is quite, basically solve this problem from
the other side instead of reading in lock file and generating nix expression it generates nix expression and stores it in
the same basically repository as lock file in the software itself so it's also quite like useful to know.

Silvan: Nice, I didn't know about this but yeah, I guess we'd also have to take a look and kind of evaluate it how well
it works and right, if you had just your own project that you need to build then this might be a better way, right 
different requirements have different best solutions and dream2nix is interesting kind of trying to generalize 
these tools but then it's also experimental and being worked on um, uh also sometimes so and like Javascript and node is fairly 
popular, uh the more popular something is the higher the chances that someone from the nix world has already taken the time to
make something nice work but if it's not popular then chances is nobody bothered to do something like that just yet and that's
not just a black and white thing, there's a spectrum because you might have something that's half popular and then
you have kind of a solution that works in like half good, half's good as something twice as popular for example. It 
also depends on the people that do take a look at that for example in the Haskell world, haskellers are kind of
very pure evaluation focused, purists in many ways, kind of trying to find the best solutions and so on, and so their
tools generally work fairly well I'd say, there's only really two ways there, there's cabal2nix, and haskell.nix, they
have different trade-offs, they both work fairly well, so yeah, it depends in many ways, just look at the tools, try
to talk to people what their current recommendation is, like on matrix, on github issues and so on.

So cabal2nix for example comes from nixpkgs, haskell.nix is a third party tool and so generally if you want more stability and speed
generally the nixpkgs ones are preferred but others might be more, third party tools are often more sophisticated
but then also not as much tested, and maybe a bit slower because they don't have the efficency requirements of nixpkgs,
so yeah that's another general indication, but it's not a given, it all depends really again.

Yeah, we're just, we're out of time, does that answer the question.

Nat: Yeah, very helpful thank you.

Silvan: So yeah, I'll stop the recording, thanks for joining.
