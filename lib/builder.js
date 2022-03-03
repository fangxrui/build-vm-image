const path = require('path');
const fs = require('fs');

const dockerProvider = require("./dockerProvider");
const scriptsDir = path.join( path.dirname(require.main.filename), 'lib', 'scripts' );
const syslinuxDir = path.join( path.dirname(require.main.filename),'syslinux' );
const myvolDir = path.join( path.dirname(require.main.filename),'my-vol' );

class Builder {

    // Build and tag Dockerfile 
    async buildPackageImage() {
        await dockerProvider.build("p:latest", path.dirname("images/Dockerfile"));
    }

    // Create raw files needed for image.
    async buildRootfs() { 
        await dockerProvider.run("p:latest", `-v${scriptsDir}:/scripts -v${syslinuxDir}:/vol-syslinux -v${myvolDir}:/my-vol`, "/scripts/make-rootfs.sh")
    }

    // Create syslinux image.
    async packageAsIso() { 

        console.log("Begin packaging ... ");
        await dockerProvider.run("p:latest", `-v${scriptsDir}:/scripts -v${syslinuxDir}:/vol-syslinux -v${myvolDir}:/my-vol`, "/scripts/package-iso.sh")

    }
}



module.exports = new Builder();