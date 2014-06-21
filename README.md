# HexBin
Creates a number Bitwise tests with 12 questions and two levels of hardness. 
Exports the tests and the answers to the tests in both PDF and HTML.
The tests are with Bulgarian headings, but you could change it inside the code.

#Uses 
  I use [PDFKit](http://github.com/antialize/wkhtmltopdf) to render the PDFs which on its own uses [wkhtmltopdf](http://github.com/antialize/wkhtmltopdf) to rendet HTML to PDF using Webkit.

## Install
#### Ruby
  If you don't have Ruby installed on your computer you can find it [here](https://www.ruby-lang.org/en/installation/)

#### PDFKit
    `gem install pdfkit`

#### wkhtmltopdf
 * **Automatic**: `sudo pdfkit --install-wkhtmltopdf`  
 install latest version into /usr/local/bin  
 (overwrite defaults with e.g. ARCHITECTURE=amd64 TO=/home/foo/bin)
 * By hand: http://code.google.com/p/wkhtmltopdf/downloads/list

#### HexBin
  * Clone the repository: `git clone https://github.com/hidroo/HexBin.git`
  * Or download link: [here](https://github.com/hidroo/HexBin/archive/master.zip)

## Usage
* You go to the folder `cd HexBin/Project`
*  There you run `ruby HexBin.rb hardness n dir`
  *  The **hardess** can be "easy" or "hard".
  *  The **n** is the number of tests you want to generate.
  * The **dir** is the directory name you want your test to be generated in the "Project" folder. If you don't enter a directory name a random one will be generated for you. If you enter an existing directory name the directory will be deleted and everything inside it.

## Configuration
  It is tested on Mac and Linux. No Windows support for now.
  
## TODO
  Making it work faster by making a smarter algorithm that generates the tests.
  Windows support.
  
## Notes when using
  * It always tries to remove the folder you give it, so **don't worry about texts like:** 
    * `rm: KWpmDLMzgWxWeINz: No such file or directory`
  
## Copyright
Copyright (c) 2014 Mihail 'hidr0' Kirilov & Elsys-bg.org. See LICENSE for details.
