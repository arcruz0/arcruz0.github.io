var links = document.links;

// https://stackoverflow.com/a/4425214/8242291

for (var i = 0, linksLength = links.length; i < linksLength; i++) {

    if (links[i].hostname != window.location.hostname) {
        links[i].target = '_blank';
    }

}