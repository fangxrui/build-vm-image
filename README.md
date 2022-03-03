
# 💿 Building a Virtual Machine Image

How To Run: 
`git clone` this repo 
`cd` into the directory
then
```
npm i
npm link
# Build the custom docker image
p init
# Build rootfs, extract kernel, initrd and package as iso.
p build
```
P.S. Make sure all the .sh file is executable before first try.  
For example, 
```
chmod +x /lib/scripts/package-iso.sh
chmod 777 /my-vol/createVS.sh
```

After successful build, a `disk.img` and `jn.iso` will be in the `my-vol` folder.  
`cd` into `my-vol`, then run `./create.sh` to create the Virtual Machine.  

![createvm](img4readme/createvm.png)  

Open the VM from VirtualBox GUI
> Username: ubuntu  
> Password: ubuntu

```
# set up password to avoid using token
jupyter notebook password
# start jupyter notebook
jupyter notebook --allow-root --ip 0.0.0.0
```
![ubuntu](img4readme/ubuntu.png)


Open your browser in the host and visit `127.0.0.1:8888`  
Run the following code snippet in the working Jupyter Notebook
```
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

titanic = pd.read_csv('/data/titanic.csv')

# Countplot
sns.catplot(x ="Sex", hue ="Survived",
kind ="count", data = titanic)
```
![jupyter](img4readme/jupyter.png)

