---
title: The dangers of technological illiteracy
date: 2013-09-11
description: As someone writing computer programs for a living, I am increasingly concerned about the lack of common sense of people interacting with technology.
...

As someone writing computer programs for a living, I am increasingly concerned
about the lack of common sense of people interacting with technology. It feels
like the majority treat computers and smartphones as magic boxes, without any
basic clue on how they operate, yet they completely depend on them.

Sadly, instead of being inspired by the possibilities enabled by technology, I
feel like the common reaction to this lack of knowledge is fear and annoyance.
So here we are: People don't want to apply security patches, we read about
cyber-this and cyber-that each and every day and nobody comprehends the scale
of the data collection by their governments.

There is, however, one particular topic where I can't stand the amount of
ignorance at all: WiFi.

The router should be the single most important computer in any household or
business relying on the Internet. Yet people don't want to spend any money on
them, accept the complimentary black-box from their ISPs and don't maintain
them (with software updates).

And instead of using its technology to connect together and to create a better
experience for everyone, every access point transmits its signal as powerful as
it legally can to drown out all other surrounding devices.

Anyways, this is not the topic I want to write about today. Today, I want to
tell an anecdote about public WiFi.

Virtually every security expert tells us not to connect to public WiFi
networks. And right they are, but we do it anyways. How bad can it be?

Turns out, really bad. Recently, I stayed at a cheap hostel in Vancouver. Their
network was horrible although they promised "High-Speed Internet" on their
website. It was in fact so horrible, that text-based sites like Hacker News
took about a minute to load (If I didn't get a timeout error).

One rainy afternoon, I couldn't stand it anymore and decided to run some
network analysis tools. Now, just for the record: I never had the intention to
do anything malicious. That being said, I just looked up the standard gateway
and manually entered its IP to learn about the router. It was a TRENDnet /
D-Link device. I got a little suspicious that the SSID of the access point was
indeed `TRENDnet`. Has no-one configured it to the name of the hostel or
something different? Out of interest, I googled the standard login for TRENDnet
devices and got `admin:admin` as the first result.

I never thought anyone would ever leave the login of their device the same as
the factory settings, but I was wrong. This hostel, with hundreds of guests,
just leaves their master key under their virtual doormat. It was as if they
were just waiting for something to happen. Admittedly, there wasn't much to do
on the default interface, but I could flash different firmware onto the router.
It gave me chills thinking of all these possibilities someone could do on their
network.

Well, I discovered a serious security threat. But I didn't want to walk up to
the administration and tell them: "Hey, I have root access to your router!".
I was afraid to get kicked out of the hostel or to risk lawsuit. In the end, I
changed the SSID of to something along the lines of `This router uses the
default login`.

The administration of the hostel discovered my change about two hours later. I
think some customer asked them why they couldn't connect to the old SSID
anymore. But I saw from the logs that the majority of people figured out what
happened really quick and connected to the new source.

I don't know what I find sadder. The people connecting to an obviously
compromised router right away or the administration not being able to fix the
problem with "turning it off and on again". They didn't even try the reset
button. I guess the router now just waits for some script kiddie to come by.

Technology isn't magic, even if it seems so for some people. These people just
need to try reading the manual or to Google it. But even this seems like too
much. The biggest threat to our online security aren't hackers - it's the
technological illiteracy of the majority of our population.

### Appendix:
 - "*The Instagram and Spotify hacking ring*" on
[haxx.se](http://daniel.haxx.se/blog/2016/01/19/subject-urgent-warning/)
- "*Oklahoma city threatens to call FBI over 'renegade' Linux maker*" on
[theregister.co.uk](http://www.theregister.co.uk/2006/03/24/tuttle_centos/)
- "*115 batshit stupid things you can put on the internet in as fast as I can
go*" on [youtube.com](https://www.youtube.com/watch?v=hMtu7vV_HmY)
- "*Attack of the Repo Men*" on
[acme.com](http://www.acme.com/software/thttpd/repo.html)

