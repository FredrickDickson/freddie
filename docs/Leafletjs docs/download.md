
Leaflet

an open-source JavaScript library
for mobile-friendly interactive maps

    Overview Tutorials Docs Download Plugins Blog 

Download Leaflet
Version 	Description
Leaflet 1.9.4 	Stable version, released on May 18, 2023.
Leaflet 2.0.0-alpha.1 	Prerelease version, released on August 16, 2025.
Development Snapshot / (Single files) 	In-progress version, developed on the main branch.

View Changelog

Note that the main version can contain incompatible changes, so please read the changelog carefully when upgrading to it.
Using a Hosted Version of Leaflet

The latest stable Leaflet release is available on several CDN’s — to start using it straight away, place this in the head of your HTML code:

<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY=" crossorigin="" />
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js" integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo=" crossorigin=""></script>

Note that the integrity hashes are included for security when using Leaflet from CDN.

Leaflet is available on the following free CDNs: unpkg, cdnjs, jsDelivr.

Disclaimer: these services are external to Leaflet; for questions or support, please contact them directly.
Using a Downloaded Version of Leaflet

Inside the archives downloaded from the above links, you will see four things:

    leaflet.js - This is the minified Leaflet JavaScript code.
    leaflet-src.js - This is the readable, unminified Leaflet JavaScript, which is sometimes helpful for debugging. (integrity=”sha256-tPonvXioSHRQt1+4ztWR5mz/1KG1X3yHNzVXprP2gLo=”)
    leaflet.css - This is the stylesheet for Leaflet.
    images - This is a folder that contains images referenced by leaflet.css. It must be in the same directory as leaflet.css.

Unzip the downloaded archive to your website’s directory and add this to the head of your HTML code:

<link rel="stylesheet" href="/path/to/leaflet.css" />
<script src="/path/to/leaflet.js"></script>

Using a JavaScript package manager

If you use the npm package manager, you can fetch a local copy of Leaflet by running:

npm install leaflet

You will find a copy of the Leaflet release files in node_modules/leaflet/dist.
Leaflet Source Code

These download packages above only contain the library itself. If you want to download the full source code, including unit tests, files for debugging, build scripts, etc., you can download it from the GitHub repository.
Building Leaflet from the Source

Leaflet build system is powered by the Node.js platform, which installs easily and works well across all major platforms. Here are the steps to set it up:

    Download and install Node
    Run the following command in the command line:

npm install

Now that you have everything installed, run npm run build inside the Leaflet directory. This will combine and compress the Leaflet source files, saving the build to the dist folder.

© 2010–2025 Volodymyr Agafonkin. Maps © OpenStreetMap contributors.
Follow LeafletJS on X
View Source on GitHub
Leaflet questions on Stack Overflow
