require 'fastimage'

size1 = FastImage.size("http://mitsuru-1029.cocolog-nifty.com/photos/uncategorized/2007/08/12/mclaren_mercedes_benz_slr_722_roads.jpg")

p size1

size2 = FastImage.size("https://secure.gravatar.com/avatar/00cdfc0883eeba002eec7d8eda9a927c?s=420&d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png")

p size2

type = FastImage.type("https://secure.gravatar.com/avatar/00cdfc0883eeba002eec7d8eda9a927c?s=420&d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png")

p type