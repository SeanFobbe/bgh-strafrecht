## Install System Dependencies

apt-get install -y wget automake ca-certificates g++ git libtool libleptonica-dev make pkg-config

apt-get install -y --no-install-recommends asciidoc docbook-xsl xsltproc


## Clone Tesseract Repository

git clone  https://github.com/tesseract-ocr/tesseract.git --branch 5.4.1 --single-branch



## Compile from Source

cd tesseract
./autogen.sh
./configure
make
make install
ldconfig


## Download Language Models


# German
wget -O /usr/local/share/tessdata/deu.traineddata https://github.com/tesseract-ocr/tessdata_fast/raw/main/deu.traineddata

