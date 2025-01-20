#!/bin/bash                                                                                                                                                     
                                                                                                                                                                
cd /home/allfab/downloads                                                                                                                                       
sudo apt install -y git                                                                                                                                         
git clone https://github.com/joshdick/onedark.vim.git                                                                                                           
mkdir -pv ~/.vim/{colors,autoload}                                                                                                                              
cp -Rf onedark.vim/colors/onedark.vim ~/.vim/colors/                                                                                                            
cp -Rf onedark.vim/autoload/onedark.vim ~/.vim/autoload/                                                                                                        
                                                                                                                                                                
touch ~/.vimrc                                                                                                                                                  
tee  ~/.vimrc <<EOF                                                                                                                                             
" ~/.vimrc                                                                                                                                                      
syntax on                                                                                                                                                       
colorscheme onedark                                                                                                                                             
set textwidth=79                                                                                                                                                
set scrolloff=15                                                                                                                                                
set autoindent                                                                                                                                                  
set tabstop=2                                                                                                                                                   
set shiftwidth=2                                                                                                                                                
set expandtab                                                                                                                                                   
set modeline modelines=2                                                                                                                                        
EOF                                                                                                                                                             
                                                                                                                                                                
rm -Rf onedark.vim