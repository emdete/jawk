Disclaimer
==========

```
Copyright (C) Lucent Technologies 1997
All Rights Reserved

Permission to use, copy, modify, and distribute this software and
its documentation for any purpose and without fee is hereby
granted, provided that the above copyright notice appear in all
copies and that both that the copyright notice and this
permission notice and warranty disclaimer appear in supporting
documentation, and that the name Lucent Technologies or any of
its entities not be used in advertising or publicity pertaining
to distribution of the software without specific, written prior
permission.

LUCENT DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
IN NO EVENT SHALL LUCENT OR ANY OF ITS ENTITIES BE LIABLE FOR ANY
SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER
IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,
ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF
THIS SOFTWARE.
```

awk joins json!
===============

as a big fan of `awk` to do quick investigation i was a bit lost when we
switched to json. we have a json record per line, millions of lines a day - a
proper challange for a unix tool like awk if only awk could use the names
instead of the field positions.

First idea was to use the names instead of number. We have records like:

	`{"abc":"3","xyz":"foo"}`

and the code would then look like:

	`{print abc, xyz}`

but to stick with the awk pattern i just put the values (3, foo in our example)
in their numbered slots (1, 2) as always but create variables (abc, xyz) with
the index values (1, 2). so now you can write:

	`{print $abc, $xyz}`

which looks similar nice and is just a minor hack (less than 50 lines code).
the whole thing has it's drawbacks (the json overwrites vars in the code) and
is limited to the pattern 'a json per line' but this is acceptable for my
usecase (we write exactly that kind of file, i control the variable names in
json and awk).

Usage
=====

The feature is off by default and must be enabled by the commandline option
`-j`.
