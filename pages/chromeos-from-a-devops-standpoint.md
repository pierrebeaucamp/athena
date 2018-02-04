---
title: ChromeOS from a DevOps standpoint
date: 2015-11-25
description: ChromeOS from a DevOps standpoint
...

I've been using a Dell Chromebook 11 as my main development machine for nearly two years now. As I recently revived my blog, I thought I'll share my view on ChromeOS.

## Why ChromeOS in the first place
I didn't plan on using my Chromebook for any actual work when I bought it in 2014. I was about to start university in a couple of months and I needed a small and inexpensive laptop with a good battery. At home, I was using Ubuntu on an older laptop, which was... decent enough.

Chromebooks are cheap (except for the Pixel), run fast and have a great battery. In fact, their battery will last through the whole day (that's 12 hours, not 8 like Apple or MS will tell you). They run on Linux, more specifically a modified version of Gentoo, with a custom boot process and a custom window manager (No X11).

So, for 200$, I got a modern and fast Linux laptop with good build quality and *no driver issues*! This alone convinced me to give it a try.

## Developer mode
ChromeOS comes pretty locked down by default, which is a **good** thing. In my opinion, no regular user should have root privileges, ever (see Android as a good example). To unlock more advanced features, you need to set the OS in *developer mode*. Once in developer mode, the computer will display a warning on every boot and offer you to restore the OS. This annoys a lot of people, but again, it's a **good** thing. Developers are a minority and this feature adds security for everyone.

Developer mode will give you access to the root shell, among other goodies.

## The boot process
The boot process of ChromeOS is a very interesting and well-engineered part of the OS. In fact, it is so well done that it served as a base for [CoreOS](https://coreos.com). The core principle is that you have two partitions on your disk: One read-only partition with the stable firmware and one read-write partition with updated firmware.

While booting, the bootloader will either boot the read-only firmware (which is known to be stable) or try to boot the updated firmware. If the updated firmware encounters problems, it falls back to the stable one. If everything is fine, the updated firmware becomes read-only and is marked as the new stable.

The key takeaway from this? **No breaking updates!** This doesn't sound like an exciting thing at first. But having run different operating systems over many years, I would always encounter a breaking update at one point, no matter what system.

Another great feature of Chromebooks (but not ChromeOS in general): A custom BIOS cryptographically validates the integrity of the disk. **This should be in every modern computation device** as it renders most attacks useless.

I hope this quick summary of the boot process will excite every system administrator - reason enough to support ChromiumOS. More information about the boot process can be found [here](https://www.chromium.org/chromium-os/chromiumos-design-docs/disk-format).

## Web Apps
Everything on ChromeOS is a web app. This is something which bothers virtually all people, but I think Web Apps will be the de-facto standard in a few years. Right now, however, it means restrictions. Chrome has the advantage to support Google's Native Client (NaCl) and  comes with a VM for Android apps (although hidden). I hope once WebAssembly is ready, we won't need those things anymore. At the moment, though, it's nice to see a growing catalog of apps.

Unfortunately, most of those apps are targeted towards consumers, not developers. This brings us to crouton.

## Crouton
This is the single most important piece of software for any developer on ChromeOS. It allows you to run a chroot environment on this OS. So, let's just all install Ubuntu and we're good to go.

And this is the point which annoys me the most about ChromeOS. Until the ecosystem of web apps is ready, we'll always need VMs or chroots to get access to basic tools. I honestly believe we'll be there in a few years but right now, tools like Cloud9 just won't cut it.

And as long as we still need to install those VMs or chroots, disk space is a major issue. My Chromebook has a 16GB SSD, but after installing a chroot and all my tools (see  [my dotfiles](https://github.com/pierrebeaucamp/dotfiles)), I have only 5GB left. Now install a couple of SDKs, and that's gone too.

So, to get to the "Dev" in "DevOps": I'm successfully hacking with Go, C, Java, Haskell, Python and other tools on ChromeOS. Running servers, debugging Android or accessing other hardware is no problem. The only issue I ran into was *Docker* (but heck, I prefer *rkt* anyways).

## Conclusion
ChromeOS is a glimpse into a better future. I can't wait until the day I'll only run web apps on my computer and my phone (look out for FirefoxOS). But  if you depend on more tools, it's just not there yet. It'll get there, maybe even pretty soon, which is exciting.

ChromeOS is the best Linux desktop I've encountered so far, but it's ahead of its time.


