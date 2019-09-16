#!/bin/bash

# Clear CSS file
cp -f /opt/regataos-prime/all-files/prime-settings-system-info.css /opt/regataos-prime/www/css/style-system/prime-settings-system-info.css

# Capture CPU
#Identify CPU
cpumodel=$(lscpu | grep -i model | tail -n 1 | cut -d ":" -f 2 |  sed 's/^ \+//')
echo "CPU: $cpumodel"

#Pass the information to CSS
sed -i "s,cpuhere,$cpumodel," /opt/regataos-prime/www/css/style-system/prime-settings-system-info.css

# Capture RAM
#Identify System Memory
ramamount=$(free -mh | grep Mem | awk '{ print $2 }' | sed 's/GiB/ GB/' | sed 's/Gi/ GB/' | sed 's/G/ GB/')
echo "RAM: $ramamount"

#Pass the information to CSS
sed -i "s.ramhere.$ramamount." /opt/regataos-prime/www/css/style-system/prime-settings-system-info.css

# Capture Video Memory
#Identify Video Memory
memoryvideo=$(glxinfo | egrep -i 'device|memory' | grep 'Video memory' | head -n 1 | cut -d: -f 2- | sed 's/MB/ MB/')
echo "VRAM: $memoryvideo"

#Pass the information to CSS
sed -i "s.memoryvideo.$memoryvideo." /opt/regataos-prime/www/css/style-system/prime-settings-system-info.css

# Capture Operational System
#Identify Operational System
osname=$(grep -r PRETTY_NAME /etc/os-release | cut -d= -f 2 | cut -d'"' -f 2)
echo "OS: $osname"

#Pass the information to CSS
sed -i "s,oshere,$osname," /opt/regataos-prime/www/css/style-system/prime-settings-system-info.css

# Capture dGPU
#Identify dGPU
dgpuname=$(inxi -G | grep Card-2)

if [[ $dgpuname == *"AMD"* ]]; then

	kmsg=$(echo $dgpuname | cut -d] -f 2- | cut -d " " -f 2-)
	echo "dGPU: AMD $kmsg"

	#Pass the information to CSS
	sed -i "s.dgpuhere.AMD $kmsg." /opt/regataos-prime/www/css/style-system/prime-settings-system-info.css

elif [[ $dgpuname == *"ATI"* ]]; then

	kmsg=$(echo $dgpuname | cut -d] -f 2-)
	echo "dGPU: AMD $kmsg"

	#Pass the information to CSS
	sed -i "s.dgpuhere.AMD $kmsg." /opt/regataos-prime/www/css/style-system/prime-settings-system-info.css

elif [[ $dgpuname == *"NVIDIA"* ]]; then

	if test -e /usr/bin/nvidia-xconfig ; then
		kmsg=$(nvidia-smi --query-gpu=name --format=csv,noheader)
		echo "dGPU: NVIDIA $kmsg"
	else
		kmsg=$(echo $dgpuname | cut -d: -f 3-)
		echo "dGPU: NVIDIA $kmsg"
	fi

	#Pass the information to CSS
	sed -i "s.dgpuhere.NVIDIA $kmsg." /opt/regataos-prime/www/css/style-system/prime-settings-system-info.css

elif [[ $dgpuname == *"GeForce"* ]]; then

	if test -e /usr/bin/nvidia-xconfig ; then
		kmsg=$(nvidia-smi --query-gpu=name --format=csv,noheader)
		echo "dGPU: NVIDIA $kmsg"
	else
		kmsg=$(echo $dgpuname | cut -d: -f 3-)
		echo "dGPU: NVIDIA $kmsg"
	fi

	#Pass the information to CSS
	sed -i "s.dgpuhere.NVIDIA $kmsg." /opt/regataos-prime/www/css/style-system/prime-settings-system-info.css

else
	echo "Not detected graphics"
fi

# Capture NVIDIA driver version
if test -e /usr/bin/nvidia-xconfig ; then
	#Identify NVIDIA driver version
	nvidiaversion=$(nvidia-smi -i 0 --query-gpu=driver_version --format=csv,noheader)
	echo "NVIDIA driver version: $nvidiaversion"

	#Pass the information to CSS
	sed -i "s,nvdriverversion,$nvidiaversion," /opt/regataos-prime/www/css/style-system/prime-settings-system-info.css
fi

# Capture Mesa version and driver
#Identify NVIDIA driver version
mesaversion=$(glxinfo | grep "OpenGL" | grep "OpenGL version string" | cut -d " " -f 6-)

#Identify driver for Mesa
mesadriver=$(inxi -Gx | grep "driver")

if [[ $mesadriver == *"amdgpu"* ]]; then
	echo "Mesa version: $mesaversion (AMDGPU)"

	sed -i "s,mesaversion,$mesaversion (AMDGPU)," /opt/regataos-prime/www/css/style-system/prime-settings-system-info.css

elif [[ $mesadriver == *"radeon"* ]]; then
	echo "Mesa version: $mesaversion (Radeon)"

	sed -i "s,mesaversion,$mesaversion (Radeon)," /opt/regataos-prime/www/css/style-system/prime-settings-system-info.css

elif [[ $mesadriver == *"nouveau"* ]]; then
	echo "Mesa version: $mesaversion (Nouveau)"

	sed -i "s,mesaversion,$mesaversion (Nouveau)," /opt/regataos-prime/www/css/style-system/prime-settings-system-info.css

elif [[ $mesadriver == *"iris"* ]]; then
	echo "Mesa version: $mesaversion (Iris)"

	sed -i "s,mesaversion,$mesaversion (Iris)," /opt/regataos-prime/www/css/style-system/prime-settings-system-info.css

elif [[ $mesadriver == *"i965"* ]]; then
	echo "Mesa version: $mesaversion (Intel)"

	sed -i "s,mesaversion,$mesaversion (Intel)," /opt/regataos-prime/www/css/style-system/prime-settings-system-info.css

elif [[ $mesadriver == *"intel"* ]]; then
	echo "Mesa version: $mesaversion (Intel)"

	sed -i "s,mesaversion,$mesaversion (Intel)," /opt/regataos-prime/www/css/style-system/prime-settings-system-info.css

else
	echo "Not detected driver for Mesa"
fi