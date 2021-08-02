# JohnAthayde.com

This is a public build for my portfolio site. Suggestions welcome. Want to use the code for your own? Please give me credit. The visuals (logo, images) are not to be reused.

## Fonts

Fonts are served from H&Co. If you are forking this, you need to use your own fonts. This is using

```
font-family: "Gotham Narrow A", "Gotham Narrow B";
font-style: normal / italic;
font-weight: 200, 400, 700, 900; // Light, Regular, Bold, Ultra
```

## Startup

Install Mailcatcher gem outside of bundler: `gem install mailcatcher`. If you get an error about Thin, try this: `gem install mailcatcher -- --with-cflags="-Wno-error=implicit-function-declaration"`

`rails s` to run the rails server, `mailcatcher` to run the mail catching blocker.

Load Mailcatcher by visiting `http://127.0.0.1:1080`