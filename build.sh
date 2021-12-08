sudo rm -rf s10_gsrd
mkdir s10_gsrd
cd s10_gsrd
export TOP_FOLDER=$(pwd)

cd $TOP_FOLDER
echo "downloading the cross compiler"
wget https://developer.arm.com/-/media/Files/downloads/gnu-a/10.2-2020.11/binrel\
/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu.tar.xz
echo "cross compiler downloded \n\n
"
echo "unzipping the cross compiler"
tar xf gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu.tar.xz
echo "unzipped cross compiler"

rm gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu.tar.xz

export CROSS_COMPILE=`pwd`/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu/bin\
/aarch64-none-linux-gnu-
export ARCH=arm64

echo "Building the Hardware Design"

cd $TOP_FOLDER
rm -rf s10_soc_devkit_ghrd master.zip
wget https://github.com/altera-opensource/ghrd-socfpga/archive/refs/heads/master.zip
unzip master.zip
mv ghrd-socfpga-master/s10_soc_devkit_ghrd .
rm -rf ghrd-socfpga-master master.zip
cd s10_soc_devkit_ghrd
export IP_ROOTDIR=~/intelFPGA_pro/21.2/ip
make clean && make scrub_clean && rm -rf output_files
~/intelFPGA_pro/21.2/nios2eds/nios2_command_shell.sh \
make generate_from_tcl
~/intelFPGA_pro/21.2/nios2eds/nios2_command_shell.sh \
make sof
cd ..

echo "Building yocto"
cd $TOP_FOLDER
wget https://releases.rocketboards.org/release/2021.04/gsrd/tools/create-linux-distro-release
chmod a+x create-linux-distro-release
sed -i '/u-boot.txt/d' create-linux-distro-release
./create-linux-distro-release -t stratix10 -i gsrd -f yocto
cd ..
