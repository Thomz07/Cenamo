# Cenamo
Know your battery just by looking at your dock
# Features
- Show battery level on your dock
- Tint your dock depending on battery state
- Choose custom colors for coloring 
- Enable X style Dock
# Release date
eta s0n
# Note
I know it uses layoutSubviews and that this is not good. I'm waiting for my iPhone X to be delivered and will use the same method Multipla uses.
The issue here is that _backgroundView doesn't exists outside of layoutSubviews on non notched devices for a reason that I don't know.
I will make it so if the device is Notched, it uses non layoutSubviews method and if the device is non notched it uses layoutSubviews method.

This project uses libstylepicker (https://github.com/boo-dev/libstylepicker) by BooDev (https://twitter.com/BooDev)
I haven't managed to include it on my theos because nothing is specified on the project so I added it manually
