---
title: Wiki
ispage: yes
...

Welcome to my personal Wiki. The primary use of this section is to keep my
personal notes, but maybe someone else might find this useful too.

<!--
Note for anyone reading the source-code: We need to link to the pages using this
strict syntax in order for the static site generator picking it up. We do this
on this index page so that other locations can just link to the page directly
without this special syntax.
-->
* <a href="{{ url_for("hardpagelink", path="/wiki/education")}}">Education</a>
* <a href="{{ url_for("hardpagelink", path="/wiki/human-rights")}}">
    Human Rights
  </a>
* <a href="{{ url_for("hardpagelink", path="/wiki/personal-finance")}}">
    Personal Finance
  </a>

